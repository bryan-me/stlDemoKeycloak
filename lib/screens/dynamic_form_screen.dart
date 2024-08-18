import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:oauth2_test/dynamicforms/model/form_detail.dart';
import 'dart:convert';
import 'package:oauth2_test/tokenmanager.dart';
import 'package:signature/signature.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DynamicFormScreen extends StatefulWidget {
  final String formId;

  DynamicFormScreen({required this.formId});

  @override
  _DynamicFormScreenState createState() => _DynamicFormScreenState();
}

class _DynamicFormScreenState extends State<DynamicFormScreen> {
final _formKey = GlobalKey<FormState>();
  Future<FormData>? _formResponse;
  Map<String, String> _textFieldValues = {};
  Map<String, dynamic> _radioGroupValues = {};
  Map<String, Map<String, bool>> _checkboxGroupValues = {};
  List<SignatureController> _signatureControllers = [];
  final ImagePicker _picker = ImagePicker();
  List<XFile?> _images = List<XFile?>.filled(6, null, growable: false);
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _formResponse = fetchFormData(widget.formId);
    _loadFormData(widget.formId);
  }


  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _longitudeController.text = position.longitude.toString();
    _latitudeController.text = position.latitude.toString();
  }

  @override
  void dispose() {
    // Dispose all signature controllers
    for (var controller in _signatureControllers) {
      controller.dispose();
    }
    _saveFormData(widget.formId); // Save form data when disposing
    super.dispose();
  }

  Widget buildForm(List<FormDetails> formDetails) {
    List<Widget> formFields = [];

    for (var field in formDetails) {
      formFields.add(
        Padding(
          padding: const EdgeInsets.only(top: 16.0), // Add padding at the top
          child: Align(
            alignment: Alignment.centerLeft, // Align text to the left
            child: Text(
              field.fieldLabel,
              style: TextStyle(
                fontSize: 18.0, // Increase the font size
                fontWeight: FontWeight.bold, // Optional: Make the text bold
              ),
            ),
          ),
        ),
      );

      switch (field.fieldType.toUpperCase()) {
        case 'RADIO':
          _radioGroupValues[field.fieldLabel] ??= null;
          formFields.addAll(field.fieldOptions.map((option) {
            String optionKey = option.keys.first;
            String optionValue = option.values.first;
            return RadioListTile<String>(
              title: Text(optionValue),
              value: optionKey,
              groupValue: _radioGroupValues[field.fieldLabel],
              onChanged: (value) {
                setState(() {
                  _radioGroupValues[field.fieldLabel] = value;
                });
              },
            );
          }).toList());
          break;
        case 'TEXTAREA':
        case 'INPUT':
          formFields.add(TextFormField(
            initialValue: _textFieldValues[field.fieldLabel] ?? '',
            decoration: InputDecoration(
              hintText: field.placeholder,
            ),
            onChanged: (value) {
              setState(() {
                _textFieldValues[field.fieldLabel] = value;
              });
              _saveFormData(widget.formId);
            },
          ));
          break;
        case 'DROPDOWN':
          formFields.add(DropdownButtonFormField<String>(
            items: field.fieldOptions.map((option) {
              String optionKey = option.keys.first;
              String optionValue = option.values.first;
              return DropdownMenuItem<String>(
                value: optionKey,
                child: Text(optionValue),
              );
            }).toList(),
            onChanged: (value) {
              // Handle dropdown change
              _saveFormData(widget.formId);
            },
            hint: Text(field.placeholder),
          ));
          break;
        case 'CHECKBOX':
          _checkboxGroupValues[field.fieldLabel] ??= {};
          formFields.addAll(field.fieldOptions.map((option) {
            String optionKey = option.keys.first;
            String optionValue = option.values.first;
            return CheckboxListTile(
              title: Text(optionValue),
              value:
                  _checkboxGroupValues[field.fieldLabel]?[optionKey] ?? false,
              onChanged: (value) {
                setState(() {
                  _checkboxGroupValues[field.fieldLabel]?[optionKey] =
                      value ?? false;
                  _saveFormData(widget.formId);
                });
              },
            );
          }).toList());
          break;
        case 'LOCATION':
          formFields.add(Column(
            children: [
              TextFormField(
                controller: _longitudeController,
                decoration: InputDecoration(
                  labelText: 'Longitude',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                ],
                onChanged: (value) {
                  _saveFormData(widget.formId);
                },
              ),
              TextFormField(
                controller: _latitudeController,
                decoration: InputDecoration(
                  labelText: 'Latitude',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                ],
                onChanged: (value) {
                  _saveFormData(widget.formId);
                },
              ),
              ElevatedButton(
                onPressed: _getCurrentLocation,
                child: Text('Get Current Location'),
              ),
            ],
          ));
          break;
        case 'SIGNATURE':
          // Initialize a new SignatureController for each SIGNATURE field
          SignatureController signatureController = SignatureController(
            penStrokeWidth: 5,
            penColor: Colors.black,
            exportBackgroundColor: Colors.white,
          );
          _signatureControllers.add(signatureController);

          formFields.add(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Signature(
                controller: signatureController,
                height: 150,
                backgroundColor: Colors.grey[200]!,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        signatureController.clear();
                      });
                    },
                    child: Text('Clear'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Save or handle the signature
                      _saveFormData(widget.formId);
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ],
          ));
          break;
        case 'IMAGE':
          formFields.add(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Take Pictures (at least 3, up to 6)'),
              GridView.builder(
                shrinkWrap: true,
                itemCount: 6,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.camera);
                      setState(() {
                        if (image != null) {
                          _images[index] = image;
                        }
                      });
                      _saveFormData(widget.formId);
                    },
                    child: Container(
                      margin: EdgeInsets.all(4.0),
                      color: Colors.grey[300],
                      child: _images[index] == null
                          ? Icon(Icons.camera_alt)
                          : Image.file(File(_images[index]!.path)),
                    ),
                  );
                },
              ),
            ],
          ));
          break;
        default:
          formFields.add(Text('Unsupported input type: ${field.fieldType}'));
          break;
      }
    }

    formFields.add(
      ElevatedButton(
        onPressed: () {
          _submitForm();
        },
        child: Text('Submit'),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: formFields,
        ),
      ),
    );
  }

  // void _submitForm() {
  //   // Handling form submission, e.g., collect all input data, validate, and send to server
  //   print('Form Submitted');
  //   print('Radio Group Values: $_radioGroupValues');
  //   print('Checkbox Group Values: $_checkboxGroupValues');
  //   // Handle other form fields like text inputs, signatures, images, etc.

  //   // Clear saved form data upon successful submission
  //   _clearFormData(widget.formId);
  // }

  // void _submitForm() async {
  //   if (_validateForm()) {
  //     try {
  //       // Gather form data into a Map
  //       final Map<String, dynamic> payload = {
  //         ''
  //         'radioGroupValues': _radioGroupValues,
  //         'checkboxGroupValues': _checkboxGroupValues,
  //         'longitude': _longitudeController.text,
  //         'latitude': _latitudeController.text,
  //         // Converting images to base64 or file paths
  //         'images': _images
  //             .where((image) => image != null)
  //             .map((image) => base64Encode(File(image!.path).readAsBytesSync()))
  //             .toList(),
  //         // Add signatures and other fields as necessary
  //         // 'signatures': ...,
  //       };

  //       // final String userId =
  //       //     '5c4eea26-314e-4602-96e6-a1070cdd1136';
  //       final String endpoint =
  //           'http://192.168.250.209:7300/api/v1/messages/submit-form/${widget.formId}';

  //       final response = await http.post(
  //         Uri.parse(endpoint),
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Authorization': 'Bearer ${TokenManager.accessToken}',
  //         },
  //         body: json.encode(payload),
  //       );

  //       if (response.statusCode == 200) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Form submitted successfully!')),
  //         );
  //         _clearFormData(
  //             widget.formId); // Clear saved form data after submission
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //               content: Text('Failed to submit form: ${response.statusCode}')),
  //         );
  //       }
  //     } catch (e) {
  //       print('Error submitting form: $e');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error submitting form: $e')),
  //       );
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Please fill in all required fields.')),
  //     );
  //   }
  // }

  // void _submitForm() async {
  //   if (_formKey.currentState!.validate()) {
  //   _formKey.currentState!.save();
  //   if (_validateForm()) {
  //     try {
  //       // Gather form data into a List of Maps (for submitting as a list)
  //       final List<Map<String, dynamic>> payload = [];

  //       // Add radio group values
  //       _radioGroupValues.forEach((key, value) {
  //         payload.add({'key': key, 'value': value});
  //       });

  //       // Add checkbox group values
  //       _checkboxGroupValues.forEach((key, value) {
  //         value.forEach((optionKey, isSelected) {
  //           if (isSelected) {
  //             payload.add({'key': key, 'value': optionKey});
  //           }
  //         });
  //       });

  //       print("Text Field Values: $_textFieldValues");

  //       // Add text field values
  //       _textFieldValues.forEach((key, value) {
  //         payload.add({'key': key, 'value': value});
  //       });

  //       // Add location data
  //       payload.add({'key': 'Longitude', 'value': _longitudeController.text});
  //       payload.add({'key': 'Latitude', 'value': _latitudeController.text});

  //       // Add images (you can add image paths or base64 strings)
  //       for (var i = 0; i < _images.length; i++) {
  //         if (_images[i] != null) {
  //           payload.add({
  //             'key': 'Image ${i + 1}',
  //             'value': base64Encode(File(_images[i]!.path).readAsBytesSync())
  //           });
  //         }
  //       }

  //       // Add signatures (if you need to include them, you'd convert them to a format like base64)
  //                 for (var i = 0; i < _signatureControllers.length; i++) {
  //           final signatureController = _signatureControllers[i];
  //           if (signatureController.isNotEmpty) {
  //             final exportedSignature =
  //                 await signatureController.toPngBytes();
  //             if (exportedSignature != null) {
  //               payload.add({
  //                 'key': 'Signature${i + 1}',
  //                 'value': base64Encode(exportedSignature)
  //               });
  //             }
  //           }
  //         }


  //       final String endpoint =
  //           'http://192.168.250.209:7300/api/v1/messages/submit-answer/${widget.formId}';

  //       final response = await http.post(
  //         Uri.parse(endpoint),
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Authorization': 'Bearer ${TokenManager.accessToken}',
  //         },
  //         body: json.encode(payload),
  //       );
  //       print(payload);

  //       if (response.statusCode == 200) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Form submitted successfully!')),
  //         );
  //         _clearFormData(
  //             widget.formId); // Clear saved form data after submission
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //               content: Text('Failed to submit form: ${response.statusCode}')),
  //         );
  //       }
  //     } catch (e) {
  //       print('Error submitting form: $e');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error submitting form: $e')),
  //       );
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Please fill in all required fields.')),
  //     );
  //   }
  // } else {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('Please fill in all required fields.')),
  //   );
  // }
  // }

  void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    final List<Map<String, dynamic>> payload = [];

    _textFieldValues.forEach((key, value) {
      payload.add({
        'field_label': key,
        'answer': value,
        'form_id': widget.formId.toString(), // Ensure these IDs are converted to String if necessary
        'created_by': 'some-uuid', // Replace with actual user UUID
        'created_at': DateTime.now().toUtc().toString(),
      });
    });

    final String endpoint =
        'http://192.168.250.209:7300/api/v1/messages/submit-answer/${widget.formId}';

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${TokenManager.accessToken}',
        },
        body: json.encode(payload),
      );

      print('Payload: ${json.encode(payload)}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Form submitted successfully!')),
        );
      } else {
        print('Failed to submit form: ${response.statusCode}');
        print('Response body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to submit form: ${response.statusCode}\n${response.body}')),
        );
      }
    } catch (e) {
      print('Error submitting form: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting form: $e')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please fill in all required fields.')),
    );
  }
}




  bool _validateForm() {
    // Add validation logic for each form field type
    // Example: Check that images are not null if required, etc.
    return true; // Adjust according to validation results
  }

  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Dynamic Form'),
  //     ),
  //     body: FutureBuilder<FormData>(
  //       future: _formResponse,
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return Center(child: CircularProgressIndicator());
  //         } else if (snapshot.hasError) {
  //           return Center(child: Text('Error: ${snapshot.error}'));
  //         } else if (snapshot.hasData) {
  //           return buildForm(snapshot.data!.formDetails);
  //         } else {
  //           return Center(child: Text('No data'));
  //         }
  //       },
  //     ),
  //   );
  // }
  // final _formKey = GlobalKey<FormState>();

Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Dynamic Form'),
    ),
    body: FutureBuilder<FormData>(
      future: _formResponse,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          // Wrap the dynamically generated form fields with a Form widget
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey, 
                child: buildForm(snapshot.data!.formDetails),
            ),
          );
        } else {
          return Center(child: Text('No data'));
        }
      },
    ),
    // floatingActionButton: FloatingActionButton(
    //   onPressed: _submitForm,
    //   child: Icon(Icons.save),
    // ),
  );
}

  // Future<FormData> fetchFormData(String formId) async {
  //   final token = TokenManager.accessToken;
  //   if (token == null) {
  //     throw Exception('Not authenticated');
  //   }

  //   final response = await http.get(
  //     Uri.parse('http://192.168.250.209:7300/api/v1/messages/form/$formId'),
  //     headers: {'Authorization': 'Bearer $token'},
  //   );

  //   if (response.statusCode == 200) {
  //     try {
  //       return FormData.fromJson(json.decode(response.body)['data']);
  //     } catch (e) {
  //       print('Error parsing response: $e'); // Log the parsing error
  //       throw Exception('Failed to parse form data');
  //     }
  //   } else {
  //     // Logging response details for debugging
  //     print('Failed to load form data: ${response.statusCode}');
  //     print('Response body: ${response.body}');
  //     throw Exception('Failed to load form data: ${response.statusCode}');
  //   }
  // }

  Future<FormData> fetchFormData(String formId) async {
    final token = TokenManager.accessToken;
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('http://192.168.250.209:7300/api/v1/messages/form/$formId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      try {
        final jsonBody = json.decode(response.body);

        // Check if 'data' is a list and if it's empty
        if (jsonBody['data'] is List && (jsonBody['data'] as List).isEmpty) {
          throw Exception('No form data available');
        }

        // Assuming 'data' should be a map or at least a non-empty list
        if (jsonBody['data'] is Map<String, dynamic>) {
          return FormData.fromJson(jsonBody['data']);
        } else {
          throw Exception('Unexpected JSON structure: "data" is not a Map');
        }
      } catch (e) {
        print('Error parsing response: $e');
        throw Exception('Failed to parse form data');
      }
    } else {
      // Logging response details for debugging
      print('Failed to load form data: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load form data: ${response.statusCode}');
    }
  }

  // Save form data to SharedPreferences
  Future<void> _saveFormData(String formId) async {
    final prefs = await SharedPreferences.getInstance();
    // Convert images to their paths or other identifiers
    List<String?> imagePaths = _images.map((xFile) => xFile?.path).toList();

    prefs.setString(
        'formData_$formId',
        json.encode({
          'radioGroupValues': _radioGroupValues,
          'checkboxGroupValues': _checkboxGroupValues.map((key, value) =>
              MapEntry(key, value.map((k, v) => MapEntry(k, v)))),
          'longitude': _longitudeController.text,
          'latitude': _latitudeController.text,
          'images': imagePaths,
          // You need to handle saving signatures as bytes or another suitable format
          // Add other fields like text inputs, signatures, images, etc.
        }));
  }

// Load form data from SharedPreferences
  // Future<void> _loadFormData(String formId) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String? formData = prefs.getString('formData_$formId');
  //   if (formData != null) {
  //     final data = json.decode(formData);
  //     setState(() {
  //       _radioGroupValues =
  //           Map<String, dynamic>.from(data['radioGroupValues'] ?? {});
  //       _checkboxGroupValues = Map<String, Map<String, bool>>.from(
  //           (data['checkboxGroupValues'] ?? {}).map(
  //               (key, value) => MapEntry(key, Map<String, bool>.from(value))));
  //       // Load other fields like text inputs, signatures, images, etc.
  //     });
  //   }
  // }

  Future<void> _loadFormData(String formId) async {
    final prefs = await SharedPreferences.getInstance();
    String? formData = prefs.getString('formData_$formId');

    if (formData != null) {
      try {
        final data = json.decode(formData);

        // Validate the structure of the loaded data
        if (data is Map<String, dynamic>) {
          setState(() {
            _radioGroupValues =
                Map<String, dynamic>.from(data['radioGroupValues'] ?? {});
            _checkboxGroupValues = Map<String, Map<String, bool>>.from(
                (data['checkboxGroupValues'] ?? {}).map((key, value) =>
                    MapEntry(key, Map<String, bool>.from(value))));
            // Load other fields like text inputs, signatures, images, etc.
          });
        } else {
          throw Exception('Invalid local data structure');
        }
      } catch (e) {
        print('Error loading saved form data: $e');
        // Handle the error by clearing the invalid local data
        await _clearFormData(formId);
      }
    }
  }

  // Clear form data from SharedPreferences
  Future<void> _clearFormData(String formId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('formData_$formId');
  }
}


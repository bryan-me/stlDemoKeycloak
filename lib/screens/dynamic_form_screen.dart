import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:oauth2_test/dynamicforms/model/form_detail.dart';
import 'package:oauth2_test/dynamicforms/model/form_model.dart';
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
    _startConnectivityListener();
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

  Future<bool> isConnectedToNetwork() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}

Future<bool> _hasInternetConnection() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}



// Method to get the size of a byte array
  int _getByteSize(Uint8List? bytes) {
    return bytes?.lengthInBytes ?? 0;
  }

  // Method to capture the signature as a byte array
  Future<Uint8List?> _captureSignature(SignatureController controller) async {
    if (controller.isNotEmpty) {
      final Uint8List? signatureBytes = await controller.toPngBytes();
      return signatureBytes;
    }
    return null;
  }

  // Method to compress the signature byte array
  Future<Uint8List?> _compressSignature(Uint8List signatureBytes) async {
    final Uint8List? compressedBytes =
        await FlutterImageCompress.compressWithList(
      signatureBytes,
      quality: 70, // Adjust quality as needed
    );
    return compressedBytes;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final List<Map<String, dynamic>> payload = [];

      _textFieldValues.forEach((key, value) {
        payload.add({
          'field_label': key,
          'answer': value,
          'form_id': widget.formId
              .toString(), // Ensure these IDs are converted to String if necessary
          'created_by': 'username', // Replace with actual user UUID
          'created_at': DateTime.now().toUtc().toString(),
        });
      });

      // Handling signature fields
      for (int i = 0; i < _signatureControllers.length; i++) {
        SignatureController controller = _signatureControllers[i];
        final originalSignatureBytes = await _captureSignature(controller);
        if (originalSignatureBytes != null) {
          final originalSize = _getByteSize(originalSignatureBytes);
          print('Original Signature Size: $originalSize bytes');

          final compressedSignatureBytes =
              await _compressSignature(originalSignatureBytes);
          final compressedSize = _getByteSize(compressedSignatureBytes);
          print('Compressed Signature Size: $compressedSize bytes');

          payload.add({
            'field_label': 'signature_$i', // Adjust as needed
            'answer': base64Encode(
                compressedSignatureBytes!), // Send as base64 string
            'original_size': originalSize,
            'compressed_size': compressedSize,
            'form_id': widget.formId.toString(),
            'created_by': 'username', // Replace with actual user UUID
            'created_at': DateTime.now().toUtc().toString(),
          });
        }
      }

      final String endpoint =
          'http://192.168.250.209:7300/api/v1/messages/submit-answer/${widget.formId}';

  //     try {
  //       final response = await http.post(
  //         Uri.parse(endpoint),
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Authorization': 'Bearer ${TokenManager.accessToken}',
  //         },
  //         body: json.encode(payload),
  //       );

  //       print('Payload: ${json.encode(payload)}');

  //       if (response.statusCode == 200) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Form submitted successfully!')),
  //         );
  //       } else {
  //         print('Failed to submit form: ${response.statusCode}');
  //         print('Response body: ${response.body}');
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //               content: Text(
  //                   'Failed to submit form: ${response.statusCode}\n${response.body}')),
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

  if (await _hasInternetConnection()) {
      // If online, submit data to the remote server
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
      // If offline, save data to Hive
      try {
        await _saveFormLocally(payload);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No internet connection. Form saved locally.')),
        );
      } catch (e) {
        print('Error saving form locally: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving form locally: $e')),
        );
      }
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please fill in all required fields.')),
    );
  }
}

Future<void> _saveFormLocally(List<Map<String, dynamic>> payload) async {
  var box = await Hive.openBox<Map<String, dynamic>>('form_submissions');
  await box.addAll(payload); // Save all form data as separate entries
}


void _startConnectivityListener() {
  Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
    if (result != ConnectivityResult.none) {
      // Connectivity restored, sync saved forms
      var box = await Hive.openBox<List<Map<String, dynamic>>>('form_submissions');
      var savedForms = box.values.toList();

      for (var formPayload in savedForms) {
        final String endpoint =
            'http://192.168.250.209:7300/api/v1/messages/submit-answer/${widget.formId}';

        try {
          final response = await http.post(
            Uri.parse(endpoint),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${TokenManager.accessToken}',
            },
            body: json.encode(formPayload),
          );

          if (response.statusCode == 200) {
            print('Form submitted successfully after reconnecting!');
            await box.delete(formPayload); // Remove successfully sent form from Hive
          } else {
            print('Failed to submit form after reconnecting: ${response.statusCode}');
          }
        } catch (e) {
          print('Error submitting form after reconnecting: $e');
        }
      }
    }
  });
}


  bool _validateForm() {
    // Add validation logic for each form field type
    // Example: Check that images are not null if required, etc.
    return true; // Adjust according to validation results
  }

  @override
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

  Future<FormData> fetchFormData(String formId) async {
    bool isConnected = await isConnectedToNetwork();
    if (!isConnected) {
      return _fetchFormDataFromHive(formId);
    } else {
      return _fetchFormDataFromRemote(formId);
    }
  }

  // Future<FormData> _fetchFormDataFromRemote(String formId) async {
  //   final token = TokenManager.accessToken;
  //   if (token == null) {
  //     throw Exception('Not authenticated');
  //   }

  //   final response = await http.get(
  //     Uri.parse('http://192.168.250.209:7300/api/v1/messages/form/$formId'),
  //     headers: {'Authorization': 'Bearer $token'},
  //   );

  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body)['data'];
  //     final formModel = FormModel.fromJson(data);

  //     var box = await Hive.openBox<FormModel>('forms');
  //     await box.put(formModel.id, formModel);
  //     try {
  //       final jsonBody = json.decode(response.body);

  //       // Check if 'data' is a list and if it's empty
  //       if (jsonBody['data'] is List && (jsonBody['data'] as List).isEmpty) {
  //         throw Exception('No form data available');
  //       }

  //       // Assuming 'data' should be a map or at least a non-empty list
  //       if (jsonBody['data'] is Map<String, dynamic>) {
  //         return FormData.fromJson(jsonBody['data']);
  //       } else {
  //         throw Exception('Unexpected JSON structure: "data" is not a Map');
  //       }
  //     } catch (e) {
  //       print('Error parsing response: $e');
  //       throw Exception('Failed to parse form data');
  //     }
  //   } else {
  //     // Logging response details for debugging
  //     print('Failed to load form data: ${response.statusCode}');
  //     print('Response body: ${response.body}');
  //     throw Exception('Failed to load form data: ${response.statusCode}');
  //   }
  // }

  Future<FormData> _fetchFormDataFromRemote(String formId) async {
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
      final jsonResponse = json.decode(response.body);
      if (jsonResponse is Map<String, dynamic> && jsonResponse['data'] is Map<String, dynamic>) {
        final formModel = FormModel.fromJson(jsonResponse['data']);

        // Open the Hive box and save the formModel
        var box = await Hive.openBox<FormModel>('forms');
        await box.put(formModel.id, formModel);
        print('FormModel saved: ${formModel.id}');

        return FormData.fromJson(jsonResponse['data']);
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print('Error parsing response: $e');
      throw Exception('Failed to parse form data');
    }
  } else {
    print('Failed to load form data: ${response.statusCode}');
    print('Response body: ${response.body}');
    throw Exception('Failed to load form data: ${response.statusCode}');
  }
}


Future<FormData> _fetchFormDataFromHive(String formId) async {
  var box = await Hive.openBox<FormModel>('forms');
  var formModel = box.get(formId);

  if (formModel != null) {
    return FormData.fromJson(formModel.toJson());
  } else {
    throw Exception('Form not found in local storage');
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
          'textFieldValues': _textFieldValues, // Save text field values

          // You need to handle saving signatures as bytes or another suitable format
          // Add other fields like text inputs, signatures, images, etc.
        }));
  }

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
            _textFieldValues =
                Map<String, String>.from(data['textFieldValues'] ?? {});

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

  Future<void> _clearFormData(String formId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('formData_$formId');
  }
}

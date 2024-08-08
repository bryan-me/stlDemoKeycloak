// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:oauth2_test/dynamicforms/model/form_detail.dart';
// import 'dart:convert';
// import 'package:oauth2_test/tokenmanager.dart';
// import 'package:signature/signature.dart';

// class DynamicFormScreen extends StatefulWidget {
//   final String formId;

//   DynamicFormScreen({required this.formId});

//   @override
//   _DynamicFormScreenState createState() => _DynamicFormScreenState();
// }

// class _DynamicFormScreenState extends State<DynamicFormScreen> {
//   Future<FormData>? _formResponse;
//   Map<String, dynamic> _radioGroupValues = {};
//   Map<String, Map<String, bool>> _checkboxGroupValues = {};

//   // List to hold SignatureControllers dynamically
//   List<SignatureController> _signatureControllers = [];

//   @override
//   void initState() {
//     super.initState();
//     _formResponse = fetchFormData(widget.formId);
//   }

//   final ImagePicker _picker = ImagePicker();
//   List<XFile?> _images = List<XFile?>.filled(6, null, growable: false);

//   // TextEditingController for longitude and latitude
//   final TextEditingController _longitudeController = TextEditingController();
//   final TextEditingController _latitudeController = TextEditingController();

//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }

//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     _longitudeController.text = position.longitude.toString();
//     _latitudeController.text = position.latitude.toString();
//   }

//   @override
//   void dispose() {
//     // Dispose all signature controllers
//     for (var controller in _signatureControllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   Widget buildForm(List<FormDetails> formDetails) {
//     List<Widget> formFields = [];

//     for (var field in formDetails) {
//       formFields.add(
//         Padding(
//           padding: const EdgeInsets.only(top: 16.0), // Add padding at the top
//           child: Align(
//             alignment: Alignment.centerLeft, // Align text to the left
//             child: Text(
//               field.fieldLabel,
//               style: TextStyle(
//                 fontSize: 18.0, // Increase the font size
//                 fontWeight: FontWeight.bold, // Optional: Make the text bold
//               ),
//             ),
//           ),
//         ),
//       );

//       switch (field.fieldType.toUpperCase()) {
//         case 'RADIO':
//           _radioGroupValues[field.fieldLabel] ??= null;
//           formFields.addAll(field.fieldOptions.map((option) {
//             String optionKey = option.keys.first;
//             String optionValue = option.values.first;
//             return RadioListTile<String>(
//               title: Text(optionValue),
//               value: optionKey,
//               groupValue: _radioGroupValues[field.fieldLabel],
//               onChanged: (value) {
//                 setState(() {
//                   _radioGroupValues[field.fieldLabel] = value;
//                 });
//               },
//             );
//           }).toList());
//           break;
//         case 'TEXTAREA':
//         case 'INPUT':
//           formFields.add(TextFormField(
//             decoration: InputDecoration(
//               hintText: field.placeholder,
//             ),
//           ));
//           break;
//         case 'DROPDOWN':
//           formFields.add(DropdownButtonFormField<String>(
//             items: field.fieldOptions.map((option) {
//               String optionKey = option.keys.first;
//               String optionValue = option.values.first;
//               return DropdownMenuItem<String>(
//                 value: optionKey,
//                 child: Text(optionValue),
//               );
//             }).toList(),
//             onChanged: (value) {
//               // Handle dropdown change
//             },
//             hint: Text(field.placeholder),
//           ));
//           break;
//         case 'CHECKBOX':
//           _checkboxGroupValues[field.fieldLabel] ??= {};
//           formFields.addAll(field.fieldOptions.map((option) {
//             String optionKey = option.keys.first;
//             String optionValue = option.values.first;
//             return CheckboxListTile(
//               title: Text(optionValue),
//               value:
//                   _checkboxGroupValues[field.fieldLabel]?[optionKey] ?? false,
//               onChanged: (value) {
//                 setState(() {
//                   _checkboxGroupValues[field.fieldLabel]?[optionKey] =
//                       value ?? false;
//                 });
//               },
//             );
//           }).toList());
//           break;
//         case 'LOCATION':
//           formFields.add(Column(
//             children: [
//               TextFormField(
//                 controller: _longitudeController,
//                 decoration: InputDecoration(
//                   labelText: 'Longitude',
//                 ),
//                 keyboardType: TextInputType.number,
//                 inputFormatters: [
//                   FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
//                 ],
//               ),
//               TextFormField(
//                 controller: _latitudeController,
//                 decoration: InputDecoration(
//                   labelText: 'Latitude',
//                 ),
//                 keyboardType: TextInputType.number,
//                 inputFormatters: [
//                   FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
//                 ],
//               ),
//               ElevatedButton(
//                 onPressed: _getCurrentLocation,
//                 child: Text('Get Current Location'),
//               ),
//             ],
//           ));
//           break;
//         case 'SIGNATURE':
//           // Initialize a new SignatureController for each SIGNATURE field
//           SignatureController signatureController = SignatureController(
//             penStrokeWidth: 5,
//             penColor: Colors.black,
//             exportBackgroundColor: Colors.white,
//           );
//           _signatureControllers.add(signatureController);

//           formFields.add(Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Signature(
//                 controller: signatureController,
//                 height: 150,
//                 backgroundColor: Colors.grey[200]!,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         signatureController.clear();
//                       });
//                     },
//                     child: Text('Clear'),
//                   ),
//                   ElevatedButton(
//                     onPressed: () async {
//                       final signature = await signatureController.toPngBytes();
//                       // Save or handle the signature
//                     },
//                     child: Text('Save'),
//                   ),
//                 ],
//               ),
//             ],
//           ));
//           break;
//         case 'IMAGE':
//           formFields.add(Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Take Pictures (at least 3, up to 6)'),
//               GridView.builder(
//                 shrinkWrap: true,
//                 itemCount: 6,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3,
//                 ),
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: () async {
//                       final XFile? image =
//                           await _picker.pickImage(source: ImageSource.camera);
//                       setState(() {
//                         if (image != null) {
//                           _images[index] = image;
//                         }
//                       });
//                     },
//                     child: Container(
//                       margin: EdgeInsets.all(4.0),
//                       color: Colors.grey[300],
//                       child: _images[index] == null
//                           ? Icon(Icons.camera_alt)
//                           : Image.file(File(_images[index]!.path)),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ));
//           break;
//         default:
//           formFields.add(Text('Unsupported input type: ${field.fieldType}'));
//           break;
//       }
//     }

//     formFields.add(
//       ElevatedButton(
//         onPressed: () {
//           _submitForm();
//         },
//         child: Text('Submit'),
//       ),
//     );

//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: SingleChildScrollView(
//         child: Column(
//           children: formFields,
//         ),
//       ),
//     );
//   }

//   void _submitForm() {
//     // Handling form submission, e.g., collect all input data, validate, and send to server
//     print('Form Submitted');
//     print('Radio Group Values: $_radioGroupValues');
//     print('Checkbox Group Values: $_checkboxGroupValues');
//     // Handle other form fields like text inputs, signatures, images, etc.
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dynamic Form'),
//         // backgroundColor: Colors.blue, // Change accent color to blue
//       ),
//       body: FutureBuilder<FormData>(
//         future: _formResponse,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             return buildForm(snapshot.data!.formDetails);
//           } else {
//             return Center(child: Text('No data'));
//           }
//         },
//       ),
//     );
//   }

//   Future<FormData> fetchFormData(String formId) async {
//     final token = TokenManager.accessToken;
//     if (token == null) {
//       throw Exception('Not authenticated');
//     }

//     final response = await http.get(
//       Uri.parse('http://192.168.250.209:7300/api/v1/messages/form/$formId'),
//       headers: {'Authorization': 'Bearer $token'},
//     );

//     if (response.statusCode == 200) {
//       try {
//         return FormData.fromJson(json.decode(response.body)['data']);
//       } catch (e) {
//         print('Error parsing response: $e'); // Log the parsing error
//         throw Exception('Failed to parse form data');
//       }
//     } else {
//       // Logging response details for debugging
//       print('Failed to load form data: ${response.statusCode}');
//       print('Response body: ${response.body}');
//       throw Exception('Failed to load form data: ${response.statusCode}');
//     }
//   }
// }


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
  Future<FormData>? _formResponse;
  Map<String, dynamic> _radioGroupValues = {};
  Map<String, Map<String, bool>> _checkboxGroupValues = {};

  // List to hold SignatureControllers dynamically
  List<SignatureController> _signatureControllers = [];

  @override
  void initState() {
    super.initState();
    _formResponse = fetchFormData(widget.formId);
    _loadFormData(widget.formId);
  }

  final ImagePicker _picker = ImagePicker();
  List<XFile?> _images = List<XFile?>.filled(6, null, growable: false);

  // TextEditingController for longitude and latitude
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();

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
            decoration: InputDecoration(
              hintText: field.placeholder,
            ),
            onChanged: (value) {
              // Save text input field value to local storage
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
                      final signature = await signatureController.toPngBytes();
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

  void _submitForm() {
    // Handling form submission, e.g., collect all input data, validate, and send to server
    print('Form Submitted');
    print('Radio Group Values: $_radioGroupValues');
    print('Checkbox Group Values: $_checkboxGroupValues');
    // Handle other form fields like text inputs, signatures, images, etc.

    // Clear saved form data upon successful submission
    _clearFormData(widget.formId);
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
            return buildForm(snapshot.data!.formDetails);
          } else {
            return Center(child: Text('No data'));
          }
        },
      ),
    );
  }

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
        return FormData.fromJson(json.decode(response.body)['data']);
      } catch (e) {
        print('Error parsing response: $e'); // Log the parsing error
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
  prefs.setString('formData_$formId', json.encode({
    'radioGroupValues': _radioGroupValues,
    'checkboxGroupValues': _checkboxGroupValues.map((key, value) =>
      MapEntry(key, value.map((k, v) => MapEntry(k, v)))
    ),
    // Add other fields like text inputs, signatures, images, etc.
  }));
}

// Load form data from SharedPreferences
Future<void> _loadFormData(String formId) async {
  final prefs = await SharedPreferences.getInstance();
  String? formData = prefs.getString('formData_$formId');
  if (formData != null) {
    final data = json.decode(formData);
    setState(() {
      _radioGroupValues = Map<String, dynamic>.from(data['radioGroupValues'] ?? {});
      _checkboxGroupValues = Map<String, Map<String, bool>>.from(
        (data['checkboxGroupValues'] ?? {}).map((key, value) =>
          MapEntry(key, Map<String, bool>.from(value))
        )
      );
      // Load other fields like text inputs, signatures, images, etc.
    });
  }
}


  // Clear form data from SharedPreferences
  Future<void> _clearFormData(String formId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('formData_$formId');
  }
}

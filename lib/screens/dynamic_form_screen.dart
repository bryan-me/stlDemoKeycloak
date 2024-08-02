// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:oauth2_test/dynamicforms/model/form_detail.dart';
// import 'dart:convert';

// import 'package:oauth2_test/tokenmanager.dart';


// class DynamicFormScreen extends StatefulWidget {
//   final String formId;

//   DynamicFormScreen({required this.formId});

//   @override
//   _DynamicFormScreenState createState() => _DynamicFormScreenState();
// }

// class _DynamicFormScreenState extends State<DynamicFormScreen> {
//   Future<ApiResponse>? _formResponse;

//   @override
//   void initState() {
//     super.initState();
//     _formResponse = fetchFormData(widget.formId);
//   }

//   Widget buildForm(List<FormDetails> formDetails) {
//     List<Widget> formFields = [];

//     for (var field in formDetails) {
//       formFields.add(Text(field.fieldLabel));
//       switch (field.fieldType) {
//         case 'RADIO':
//           formFields.add(RadioListTile<bool>(
//             title: Text(field.fieldLabel),
//             value: true,
//             groupValue: null,
//             onChanged: (value) {},
//           ));
//           break;
//         case 'TEXTAREA':
//           formFields.add(TextFormField(
//             decoration: InputDecoration(
//               hintText: field.placeholder,
//             ),
//           ));
//           break;
//         case 'DROPDOWN':
//           formFields.add(DropdownButtonFormField<String>(
//             items: field.fieldOptions.entries.map((entry) {
//               return DropdownMenuItem<String>(
//                 value: entry.key,
//                 child: Text(entry.value),
//               );
//             }).toList(),
//             onChanged: (value) {},
//             hint: Text(field.placeholder),
//           ));
//           break;
//         default:
//           formFields.add(Text('Unsupported input type: ${field.fieldType}'));
//           break;
//       }
//     }

//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: formFields,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Dynamic Form')),
//       body: FutureBuilder<ApiResponse>(
//         future: _formResponse,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             return buildForm(snapshot.data!.data.formDetails);
//           } else {
//             return Center(child: Text('No data'));
//           }
//         },
//       ),
//     );
//   }

//   Future<ApiResponse> fetchFormData(String formId) async {
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
//         return ApiResponse.fromJson(json.decode(response.body));
//       } catch (e) {
//         print('Error parsing response: $e'); 
//         throw Exception('Failed to parse form data');
//       }
//     } else {
//       print('Failed to load form data: ${response.statusCode}');
//       print('Response body: ${response.body}');
//       throw Exception('Failed to load form data: ${response.statusCode}');
//     }
//   }
// }

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:oauth2_test/dynamicforms/model/form_detail.dart';
// import 'dart:convert';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:signature/signature.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:oauth2_test/tokenmanager.dart';

// class DynamicFormScreen extends StatefulWidget {
//   final String formId;

//   DynamicFormScreen({required this.formId});

//   @override
//   _DynamicFormScreenState createState() => _DynamicFormScreenState();
// }

// class _DynamicFormScreenState extends State<DynamicFormScreen> {
//   Future<ApiResponse>? _formResponse;
//   final SignatureController _signatureController = SignatureController(
//     penStrokeWidth: 5,
//     penColor: Colors.black,
//     exportBackgroundColor: Colors.white,
//   );
//   DateTime? _selectedDate;
//   final ImagePicker _picker = ImagePicker();
//   XFile? _image;
//   Map<String, dynamic> _formData = {};

//   @override
//   void initState() {
//     super.initState();
//     _loadFormData();
//     _formResponse = fetchFormData(widget.formId);
//   }

//   void _saveFormData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('formData', json.encode(_formData));
//   }

//   void _loadFormData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? formDataString = prefs.getString('formData');
//     if (formDataString != null) {
//       setState(() {
//         _formData = json.decode(formDataString);
//       });
//     }
//   }

//   void _clearFormData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.remove('formData');
//   }

//   Widget buildForm(List<FormDetails> formDetails) {
//     List<Widget> formFields = [];

//     for (var field in formDetails) {
//       formFields.add(Text(field.fieldLabel));
//       switch (field.fieldType) {
//         case 'RADIO':
//           formFields.add(RadioListTile<bool>(
//             title: Text(field.fieldLabel),
//             value: true,
//             groupValue: _formData[field.fieldLabel] as bool?,
//             onChanged: (value) {
//               setState(() {
//                 _formData[field.fieldLabel] = value;
//                 _saveFormData();
//               });
//             },
//           ));
//           break;
//         case 'TEXTAREA':
//           formFields.add(TextFormField(
//             initialValue: _formData[field.fieldLabel] as String?,
//             decoration: InputDecoration(
//               hintText: field.placeholder,
//             ),
//             onChanged: (value) {
//               setState(() {
//                 _formData[field.fieldLabel] = value;
//                 _saveFormData();
//               });
//             },
//           ));
//           break;
//         case 'DROPDOWN':
//           formFields.add(DropdownButtonFormField<String>(
//             value: _formData[field.fieldLabel] as String?,
//             items: field.fieldOptions.entries.map((entry) {
//               return DropdownMenuItem<String>(
//                 value: entry.key,
//                 child: Text(entry.value),
//               );
//             }).toList(),
//             onChanged: (value) {
//               setState(() {
//                 _formData[field.fieldLabel] = value;
//                 _saveFormData();
//               });
//             },
//             hint: Text(field.placeholder),
//           ));
//           break;
//         case 'DATEPICKER':
//           formFields.add(
//             ListTile(
//               title: Text(_selectedDate == null
//                   ? 'Select date'
//                   : DateFormat.yMMMd().format(_selectedDate!)),
//               trailing: Icon(Icons.calendar_today),
//               onTap: () async {
//                 DateTime? picked = await showDatePicker(
//                   context: context,
//                   initialDate: _selectedDate ?? DateTime.now(),
//                   firstDate: DateTime(2000),
//                   lastDate: DateTime(2101),
//                 );
//                 if (picked != null) {
//                   setState(() {
//                     _selectedDate = picked;
//                     _formData[field.fieldLabel] = picked.toIso8601String();
//                     _saveFormData();
//                   });
//                 }
//               },
//             ),
//           );
//           break;
//         case 'IMAGE':
//           formFields.add(
//             ListTile(
//               title: Text('Pick Image'),
//               trailing: Icon(Icons.image),
//               onTap: () async {
//                 final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//                 setState(() {
//                   _image = pickedFile;
//                   _formData[field.fieldLabel] = _image?.path;
//                   _saveFormData();
//                 });
//               },
//             ),
//           );
//           if (_image != null) {
//             formFields.add(Image.file(File(_image!.path)));
//           }
//           break;
//         case 'SIGNATURE':
//           formFields.add(
//             Column(
//               children: [
//                 Signature(
//                   controller: _signatureController,
//                   height: 150,
//                   backgroundColor: Colors.grey[200]!,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: <Widget>[
//                     ElevatedButton(
//                       onPressed: () {
//                         _signatureController.clear();
//                       },
//                       child: Text('Clear'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () async {
//                         if (_signatureController.isNotEmpty) {
//                           final exportedSignature = await _signatureController.toPngBytes();
//                           setState(() {
//                             _formData[field.fieldLabel] = base64Encode(exportedSignature!);
//                             _saveFormData();
//                           });
//                         }
//                       },
//                       child: Text('Save'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//           break;
//         case 'MULTISELECT':
//           formFields.add(
//             DropdownButtonFormField<List<String>>(
//               value: _formData[field.fieldLabel] as List<String>?,
//               items: field.fieldOptions.entries.map((entry) {
//                 return DropdownMenuItem<List<String>>(
//                   value: [entry.key],
//                   child: Text(entry.value),
//                 );
//               }).toList(),
//               onChanged: (value) {
//                 setState(() {
//                   _formData[field.fieldLabel] = value;
//                   _saveFormData();
//                 });
//               },
//               hint: Text(field.placeholder),
//               isExpanded: true,
//               isDense: true,
//             ),
//           );
//           break;
//         default:
//           formFields.add(Text('Unsupported input type: ${field.fieldType}'));
//           break;
//       }
//     }

//     formFields.add(
//       ElevatedButton(
//         onPressed: _submitForm,
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

//   void _submitForm() async {
//     // Clear the local storage
//     _clearFormData();

//     final token = TokenManager.accessToken;
//     if (token == null) {
//       throw Exception('Not authenticated');
//     }

//     final response = await http.post(
//       Uri.parse('http://192.168.250.209:7300/api/v1/messages/create-form'),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//       body: json.encode(_formData),
//     );

//     if (response.statusCode == 200) {
//       // Handle successful form submission
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Form submitted successfully')));
//     } else {
//       // Handle form submission error
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit form: ${response.statusCode}')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Dynamic Form')),
//       body: FutureBuilder<ApiResponse>(
//         future: _formResponse,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             return buildForm(snapshot.data!.data.formDetails);
//           } else {
//             return Center(child: Text('No data'));
//           }
//         },
//       ),
//     );
//   }

//   Future<ApiResponse> fetchFormData(String formId) async {
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
//         return ApiResponse.fromJson(json.decode(response.body));
//       } catch (e) {
//         print('Error parsing response: $e'); 
//         throw Exception('Failed to parse form data');
//       }
//     } else {
//       print('Failed to load form data: ${response.statusCode}');
//       print('Response body: ${response.body}');
//       throw Exception('Failed to load form data: ${response.statusCode}');
//     }
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2_test/dynamicforms/model/form_detail.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:oauth2_test/tokenmanager.dart';

class DynamicFormScreen extends StatefulWidget {
  final String formId;

  DynamicFormScreen({required this.formId});

  @override
  _DynamicFormScreenState createState() => _DynamicFormScreenState();
}

class _DynamicFormScreenState extends State<DynamicFormScreen> {
  Future<ApiResponse>? _formResponse;
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  DateTime? _selectedDate;
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  Map<String, dynamic> _formData = {};
  Map<String, bool> _fieldValidation = {};

  @override
  void initState() {
    super.initState();
    _loadFormData();
    _formResponse = fetchFormData(widget.formId);
  }

  void _saveFormData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('formData', json.encode(_formData));
  }

  void _loadFormData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? formDataString = prefs.getString('formData');
    if (formDataString != null) {
      setState(() {
        _formData = json.decode(formDataString);
      });
    }
  }

  void _clearFormData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('formData');
  }

  bool _validateForm(List<FormDetails> formDetails) {
    bool isValid = true;
    _fieldValidation.clear();
    for (var field in formDetails) {
      if (field.isRequired && (_formData[field.fieldLabel] == null || _formData[field.fieldLabel].toString().isEmpty)) {
        _fieldValidation[field.fieldLabel] = false;
        isValid = false;
      } else {
        _fieldValidation[field.fieldLabel] = true;
      }
    }
    setState(() {});
    return isValid;
  }

  Widget buildForm(List<FormDetails> formDetails) {
    List<Widget> formFields = [];

    for (var field in formDetails) {
      formFields.add(Text(field.fieldLabel));
      switch (field.fieldType) {
        case 'RADIO':
          formFields.add(RadioListTile<bool>(
            title: Text(field.fieldLabel),
            value: true,
            groupValue: _formData[field.fieldLabel] as bool?,
            onChanged: (value) {
              setState(() {
                _formData[field.fieldLabel] = value;
                _saveFormData();
              });
            },
            tileColor: _fieldValidation[field.fieldLabel] == false ? Colors.red[100] : null,
          ));
          break;
        case 'TEXTAREA':
          formFields.add(TextFormField(
            initialValue: _formData[field.fieldLabel] as String?,
            decoration: InputDecoration(
              hintText: field.placeholder,
              errorText: _fieldValidation[field.fieldLabel] == false ? 'This field is required' : null,
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _formData[field.fieldLabel] = value;
                _saveFormData();
              });
            },
          ));
          break;
        case 'DROPDOWN':
          formFields.add(DropdownButtonFormField<String>(
            value: _formData[field.fieldLabel] as String?,
            items: field.fieldOptions.entries.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.key,
                child: Text(entry.value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _formData[field.fieldLabel] = value;
                _saveFormData();
              });
            },
            hint: Text(field.placeholder),
            decoration: InputDecoration(
              errorText: _fieldValidation[field.fieldLabel] == false ? 'This field is required' : null,
              border: OutlineInputBorder(),
            ),
          ));
          break;
        case 'DATEPICKER':
          formFields.add(
            ListTile(
              title: Text(_selectedDate == null
                  ? 'Select date'
                  : DateFormat.yMMMd().format(_selectedDate!)),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null) {
                  setState(() {
                    _selectedDate = picked;
                    _formData[field.fieldLabel] = picked.toIso8601String();
                    _saveFormData();
                  });
                }
              },
              tileColor: _fieldValidation[field.fieldLabel] == false ? Colors.red[100] : null,
            ),
          );
          break;
        case 'IMAGE':
          formFields.add(
            ListTile(
              title: Text('Pick Image'),
              trailing: Icon(Icons.image),
              onTap: () async {
                final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                setState(() {
                  _image = pickedFile;
                  _formData[field.fieldLabel] = _image?.path;
                  _saveFormData();
                });
              },
              tileColor: _fieldValidation[field.fieldLabel] == false ? Colors.red[100] : null,
            ),
          );
          if (_image != null) {
            formFields.add(Image.file(File(_image!.path)));
          }
          break;
        case 'SIGNATURE':
          formFields.add(
            Column(
              children: [
                Signature(
                  controller: _signatureController,
                  height: 150,
                  backgroundColor: Colors.grey[200]!,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        _signatureController.clear();
                      },
                      child: Text('Clear'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_signatureController.isNotEmpty) {
                          final exportedSignature = await _signatureController.toPngBytes();
                          setState(() {
                            _formData[field.fieldLabel] = base64Encode(exportedSignature!);
                            _saveFormData();
                          });
                        }
                      },
                      child: Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          );
          break;
        case 'MULTISELECT':
          formFields.add(
            DropdownButtonFormField<List<String>>(
              value: _formData[field.fieldLabel] as List<String>?,
              items: field.fieldOptions.entries.map((entry) {
                return DropdownMenuItem<List<String>>(
                  value: [entry.key],
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _formData[field.fieldLabel] = value;
                  _saveFormData();
                });
              },
              hint: Text(field.placeholder),
              decoration: InputDecoration(
                errorText: _fieldValidation[field.fieldLabel] == false ? 'This field is required' : null,
                border: OutlineInputBorder(),
              ),
              isExpanded: true,
              isDense: true,
            ),
          );
          break;
        default:
          formFields.add(Text('Unsupported input type: ${field.fieldType}'));
          break;
      }
    }

    formFields.add(
      ElevatedButton(
        onPressed: () {
          if (_validateForm(formDetails)) {
            _submitForm();
          }
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

  void _submitForm() async {
    // Clear the local storage
    _clearFormData();

    final token = TokenManager.accessToken;
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.post(
      Uri.parse('http://192.168.250.209:7300/api/v1/messages/create-form'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(_formData),
    );

    if (response.statusCode == 200) {
      // Handle successful form submission
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Form submitted successfully')));
    } else {
      // Handle form submission error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit form: ${response.statusCode}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dynamic Form')),
      body: FutureBuilder<ApiResponse>(
        future: _formResponse,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return buildForm(snapshot.data!.data.formDetails);
          } else {
            return Center(child: Text('No data'));
          }
        },
      ),
    );
  }

  Future<ApiResponse> fetchFormData(String formId) async {
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
        return ApiResponse.fromJson(json.decode(response.body));
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
}

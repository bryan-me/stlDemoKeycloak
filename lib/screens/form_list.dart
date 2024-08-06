// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:oauth2_test/dynamicforms/model/form_detail.dart';
// import 'package:oauth2_test/tokenmanager.dart';
// import 'dart:convert';

// import 'dynamic_form_screen.dart';

// class FormListScreen extends StatefulWidget {
//   @override
//   _FormListScreenState createState() => _FormListScreenState();
// }

// class _FormListScreenState extends State<FormListScreen> {
//   Future<ApiResponse>? _formsResponse;

//   @override
//   void initState() {
//     super.initState();
//     _formsResponse = fetchForms();
//   }

//   Future<ApiResponse> fetchForms() async {
//     final token = TokenManager.accessToken;
//     if (token == null) {
//       throw Exception('Not authenticated');
//     }

//     final response = await http.get(
//       Uri.parse('http://192.168.250.209:7300/api/v1/messages/findAllForms'),
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Forms List')),
//       body: FutureBuilder<ApiResponse>(
//         future: _formsResponse,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             return ListView.builder(
//               itemCount: snapshot.data!.data.length,
//               itemBuilder: (context, index) {
//                 final form = snapshot.data!.data[index];
//                 return ListTile(
//                   title: Text(form.name),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => DynamicFormScreen(formId: form.id),
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           } else {
//             return Center(child: Text('No data'));
//           }
//         },
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:oauth2_test/dynamicforms/model/form_detail.dart';
// import 'package:oauth2_test/tokenmanager.dart';
// import 'dart:convert';

// import 'dynamic_form_screen.dart';

// class FormListScreen extends StatefulWidget {
//   @override
//   _FormListScreenState createState() => _FormListScreenState();
// }

// class _FormListScreenState extends State<FormListScreen> {
//   Future<ApiResponse>? _formsResponse;

//   @override
//   void initState() {
//     super.initState();
//     _formsResponse = fetchForms();
//   }

//   Future<ApiResponse> fetchForms() async {
//     final token = TokenManager.accessToken;
//     if (token == null) {
//       throw Exception('Not authenticated');
//     }

//     final response = await http.get(
//       Uri.parse('http://192.168.250.209:7300/api/v1/messages/findAllForms'),
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Forms List')),
//       body: FutureBuilder<ApiResponse>(
//         future: _formsResponse,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             return ListView.builder(
//               itemCount: snapshot.data!.data.length,
//               itemBuilder: (context, index) {
//                 final form = snapshot.data!.data[index];
//                 return Card(
//                   elevation: 4,
//                   margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   child: ListTile(
//                     title: Text(form.name),
//                     subtitle: Text('Version: ${form.version}'),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => DynamicFormScreen(formId: form.id),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               },
//             );
//           } else {
//             return Center(child: Text('No data'));
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2_test/dynamicforms/model/form_detail.dart';
import 'package:oauth2_test/tokenmanager.dart';
import 'dart:convert';

import 'dynamic_form_screen.dart';

class FormListScreen extends StatefulWidget {
  @override
  _FormListScreenState createState() => _FormListScreenState();
}

class _FormListScreenState extends State<FormListScreen> {
  Future<ApiResponse>? _formsResponse;

  @override
  void initState() {
    super.initState();
    _formsResponse = fetchForms();
  }

  Future<ApiResponse> fetchForms() async {
    final token = TokenManager.accessToken;
    if (token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('http://192.168.250.209:7300/api/v1/messages/findAllForms'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forms List')),
      body: FutureBuilder<ApiResponse>(
        future: _formsResponse,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.data.length,
              itemBuilder: (context, index) {
                final form = snapshot.data!.data[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.description,
                          size: 40,
                          color: Colors.white,
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              form.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Version: ${form.version}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}
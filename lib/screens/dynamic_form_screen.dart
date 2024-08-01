import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2_test/dynamicforms/model/form_detail.dart';
import 'dart:convert';

import 'package:oauth2_test/tokenmanager.dart';


class DynamicFormScreen extends StatefulWidget {
  final String formId;

  DynamicFormScreen({required this.formId});

  @override
  _DynamicFormScreenState createState() => _DynamicFormScreenState();
}

class _DynamicFormScreenState extends State<DynamicFormScreen> {
  Future<ApiResponse>? _formResponse;

  @override
  void initState() {
    super.initState();
    _formResponse = fetchFormData(widget.formId);
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
            groupValue: null,
            onChanged: (value) {},
          ));
          break;
        case 'TEXTAREA':
          formFields.add(TextFormField(
            decoration: InputDecoration(
              hintText: field.placeholder,
            ),
          ));
          break;
        case 'DROPDOWN':
          formFields.add(DropdownButtonFormField<String>(
            items: field.fieldOptions.entries.map((entry) {
              return DropdownMenuItem<String>(
                value: entry.key,
                child: Text(entry.value),
              );
            }).toList(),
            onChanged: (value) {},
            hint: Text(field.placeholder),
          ));
          break;
        default:
          formFields.add(Text('Unsupported input type: ${field.fieldType}'));
          break;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: formFields,
      ),
    );
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


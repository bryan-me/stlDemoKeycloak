import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oauth2_test/dynamicforms/model/dynamic_model.dart';

Future<List<DynamicModel>> fetchFormConfig() async {
  final response = await http.get(Uri.parse('http://192.168.250.209:7300/api/v1/messages/findAllForms'));
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((item) => DynamicModel.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load form config');
  }
}
import 'dart:convert';
import 'package:oauth2_test/widgets/dynamic_form.dart';
import 'package:http/http.dart' as http;

Future<DynamicForm> fetchFormById(String id) async {
  final response = await http.get(Uri.parse('http://192.168.250.209:7300/api/v1/messages/$id'));

  if(response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body)['data'];
    return DynamicForm.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to load form');
  }
}
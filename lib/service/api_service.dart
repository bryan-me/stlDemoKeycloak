// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:oauth2_test/widgets/dynamic_form.dart';

// Future<DynamicForm> fetchFormById(String id, String token) async {
//   final url = 'http://192.168.250.209:7300/api/v1/messages/form/$id';
//   print('Fetching form from URL: $url');
  
//   final response = await http.get(
//     Uri.parse(url),
//     headers: {
//       'Authorization': 'Bearer $token',
//     },
//   );
//   print ('$token');
//   print('Response status code: ${response.statusCode}');
//   print('Response body: ${response.body}');

//   if (response.statusCode == 200) {
//     try {
//       return DynamicForm.fromJson(jsonDecode(response.body));
//     } catch (e) {
//       print('Error parsing JSON: $e');
//       throw Exception('Failed to parse form');
//     }
//   } else {
//     throw Exception('Failed to load form');
//   }
// }
// import 'package:oauth2_test/dynamicforms/model/form_detail.dart';


// class DynamicForm {
//   final String id;
//   final String name;
//   final int version;
//   final List<FormDetail> formDetails;

//   DynamicForm({
//     required this.id,
//     required this.name,
//     required this.version,
//     required this.formDetails,
//   });

//   factory DynamicForm.fromJson(Map<String, dynamic> json) {
//     return DynamicForm(
//       id: json['id'],
//       name: json['name'],
//       version: json['version'],
//       formDetails: (json['formDetails'] as List)
//           .map((detail) => FormDetail.fromJson(detail))
//           .toList(),
//     );
//   }
// }
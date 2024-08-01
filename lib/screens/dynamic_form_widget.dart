// import 'package:flutter/material.dart';
// import 'package:oauth2_test/service/api_service.dart';
// import 'package:oauth2_test/widgets/dynamic_form.dart';

// class DynamicFormWidget extends StatefulWidget {
//   final String formId;
//   final String token;

//   DynamicFormWidget({required this.formId, required this.token});

//   @override
//   _DynamicFormWidgetState createState() => _DynamicFormWidgetState();
// }

// class _DynamicFormWidgetState extends State<DynamicFormWidget> {
//   late Future<DynamicForm> futureForm;

//   @override
//   void initState() {
//     super.initState();
//     futureForm = fetchFormById(widget.formId, widget.token);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dynamic Form'),
//       ),
//       body: FutureBuilder<DynamicForm>(
//         future: futureForm,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             print('Error: ${snapshot.error}');
//             return Center(child: Text('Failed to load form: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             return buildForm(snapshot.data!);
//           } else {
//             return Center(child: Text('No form data available'));
//           }
//         },
//       ),
//     );
//   }

//   Widget buildForm(DynamicForm form) {
//     List<Widget> formWidgets = form.formDetails.map((detail) {
//       switch (detail.inputType) {
//         case 'TEXT':
//           return TextFormField(
//             decoration: InputDecoration(labelText: detail.label),
//           );
//         case 'TEXTAREA':
//           return TextFormField(
//             decoration: InputDecoration(labelText: detail.label),
//             maxLines: null,
//           );
//         case 'DROPDOWN':
//           return DropdownButtonFormField<String>(
//             decoration: InputDecoration(labelText: detail.label),
//             items: (detail.option['items'] as List)
//                 .map<DropdownMenuItem<String>>((item) {
//               return DropdownMenuItem<String>(
//                 value: item['value'],
//                 child: Text(item['label']),
//               );
//             }).toList(),
//             onChanged: (value) {},
//           );
//         case 'RADIO':
//           return Column(
//             children: (detail.option['items'] as List).map<Widget>((item) {
//               return RadioListTile<String>(
//                 title: Text(item['label']),
//                 value: item['value'],
//                 groupValue: null,
//                 onChanged: (value) {},
//               );
//             }).toList(),
//           );
//         default:
//           return Container();
//       }
//     }).toList();

//     return Card(
//       margin: EdgeInsets.all(10),
//       child: Padding(
//         padding: EdgeInsets.all(10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: formWidgets,
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:oauth2_test/screens/dynamic_form_widget.dart';

// class FormScreen extends StatelessWidget {
//   final TextEditingController _controller = TextEditingController();

//   void _navigateToForm(BuildContext context, String id) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => DynamicFormWidget(formId: id, token: '',),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dynamic Form Fetcher'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _controller,
//               decoration: InputDecoration(
//                 labelText: 'Enter Form ID',
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 String id = _controller.text;
//                 _navigateToForm(context, id);
//               },
//               child: Text('Fetch Form'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
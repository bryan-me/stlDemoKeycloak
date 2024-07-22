// // import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:oauth2_test/constants.dart';
// // import 'package:chat_app/constants.dart';

// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {

//   // final _auth=FirebaseAuth.instance;
//   // FirebaseUser loggedInUser;
//   // void getCurrentUser()async{
//   //   try{
//   //   final user=await _auth.currentUser();
//   //   if(user!=null){
//   //     loggedInUser=user;
//   //     print(loggedInUser.email);
//   //     print(loggedInUser.displayName);
//   //   }
//   //   }
//   //   catch(e){
//   //     print(e);
//   //   }
//   // }

// @override
//   void initState() {
//     super.initState();
//     // getCurrentUser();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: null,
//         actions: <Widget>[
//           IconButton(
//               icon: Icon(Icons.close),
//               onPressed: () {
//                 //Implement logout functionality
//               }),
//         ],
//         title: Text('⚡️Chat'),
//         backgroundColor: Colors.lightBlueAccent,
//       ),
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             Container(
//               decoration: kMessageContainerDecoration,
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Expanded(
//                     child: TextField(
//                       onChanged: (value) {
//                         //Do something with the user input.
//                       },
//                       decoration: kMessageTextFieldDecoration,
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       //Implement send functionality.
//                     },
//                     child: Text(
//                       'Send',
//                       style: kSendButtonTextStyle,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:oauth2_test/constants.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController chatMsgTextController = TextEditingController();
  String messageText = '';
  String username = 'User';
  String email = 'user@example.com';

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    // Replace this with your own authentication logic
    // For example, you might want to fetch the current user's details from your backend
    setState(() {
      username = 'Me';
      email = 'user@example.com';
    });
  }

  void sendMessage() async {
    if (messageText.isNotEmpty) {
      final response = await http.post(
        Uri.parse('http://localhost:7300/api/v1/messages/create-message'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'sender': username,
          'text': messageText,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'senderEmail': email,
        }),
      );

      if (response.statusCode == 201) {
        // Message sent successfully, clear the text field
        chatMsgTextController.clear();
        setState(() {
          messageText = '';
        });
      } else {
        // Handle error
        print('Failed to send message');
      }
    }
  }

  void logout() {
    // Replace this with your own logout logic
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              logout();
            },
          ),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: chatMsgTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: sendMessage,
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

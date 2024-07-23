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


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2_test/constants.dart';
import 'package:oauth2_test/tokenmanager.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController chatMsgTextController = TextEditingController();
  String messageText = '';
  String username = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    final accessToken = TokenManager.accessToken; 

    if (accessToken == null) {
      print('No access token available');
      return;
    }

    print('Fetching user details with access token: $accessToken');

    final response = await http.get(
      Uri.parse('http://192.168.250.209:7300/api/v1/users/me'), 
      headers: {
        'Authorization': 'Bearer $accessToken', 
      },
    );

    print('User details response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      setState(() {
        username = userData['username'] ?? 'Unknown User'; 
        email = userData['email'] ?? 'Unknown Email'; 
      });

      print('Fetched user details: username=$username, email=$email');
    } else {
      print('Failed to fetch user details: ${response.statusCode} ${response.body}');
    }
  }

  void sendMessage() async {
    if (messageText.isNotEmpty) {
      print('Sending message: $messageText');

      final response = await http.post(
        Uri.parse('http://192.168.250.209:7300/api/v1/messages/create-message'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${TokenManager.accessToken}', 
          'apikey': '65bcc0d4-3d68-455c-b6c1-168c8f20eb27' 
        },
        body: jsonEncode({
          'sender': username,
          'text': messageText,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'senderEmail': email,
        }),
      );

      print('Send message response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 201) {
        setState(() {
          chatMsgTextController.clear();
          messageText = '';
        });

        print('Message sent successfully');
      } else {
        print('Failed to send message: ${response.statusCode} ${response.body}');
      }
    } else {
      print('Message text is empty, not sending');
    }
  }

  void logout() {
    print('Logging out');
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
            onPressed: logout,
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
            // Chat messages will go here

            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: chatMsgTextController,
                      onChanged: (value) {
                        setState(() {
                          messageText = value;
                        });

                        print('Message text changed: $messageText');
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

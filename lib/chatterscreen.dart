// // import 'package:edge_alert/edge_alert.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:oauth2_test/constants.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// import '../constants.dart';

// // final _firestore = Firestore.instance;
// String username = 'User';
// String email = 'user@example.com';
// // String messageText;
// // FirebaseUser loggedInUser;

// class ChatterScreen extends StatefulWidget {
//   @override
//   _ChatterScreenState createState() => _ChatterScreenState();
// }

// class _ChatterScreenState extends State<ChatterScreen> {
//   final chatMsgTextController = TextEditingController();

//   // final _auth = FirebaseAuth.instance;

//   @override
//   void initState() {
//     super.initState();
//     // getCurrentUser();
//     // getMessages();
//   }

//   // void getCurrentUser() async {
//   //   try {
//   //     final user = await _auth.currentUser();
//   //     if (user != null) {
//   //       loggedInUser = user;
//   //       setState(() {
//   //         username = loggedInUser.displayName;
//   //         email = loggedInUser.email;
//   //       });
//   //     }
//   //   } catch (e) {
//   //     EdgeAlert.show(context,
//   //         title: 'Something Went Wrong',
//   //         description: e.toString(),
//   //         // gravity: EdgeAlert.BOTTOM,
//   //         icon: Icons.error,
//   //         backgroundColor: Colors.deepPurple[900]);
//   //   }
//   // }
//   // void getMessages()async{
//   //   final messages=await _firestore.collection('messages').getDocuments();
//   //   for(var message in messages.documents){
//   //     print(message.data);
//   //   }
//   // }

//   // void messageStream() async {
//   //   await for (var snapshot in _firestore.collection('messages').snapshots()) {
//   //     snapshot.documents;
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.blue),
//         elevation: 0,
//         bottom: PreferredSize(
//           preferredSize: Size(25, 10),
//           child: Container(
//             child: LinearProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               backgroundColor: Colors.blue[100],
//             ),
//             decoration: BoxDecoration(
//                 color: Colors.blue,

//                 borderRadius: BorderRadius.circular(20)
//                 ),
//             constraints: BoxConstraints.expand(height: 1),
//           ),
//         ),
//         backgroundColor: Colors.white10,
//         leading: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: CircleAvatar(backgroundImage: NetworkImage('https://cdn.clipart.email/93ce84c4f719bd9a234fb92ab331bec4_frisco-specialty-clinic-vail-health_480-480.png'),),
//         ),
//         title: Row(
//           children: <Widget>[
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text(
//                   'Push Messenger',
//                   style: TextStyle(
//                       fontFamily: 'Poppins',
//                       fontSize: 16,
//                       color: Colors.blue),
//                 ),
//                 Text('by SuperTech',
//                     style: TextStyle(
//                         fontFamily: 'Poppins',
//                         fontSize: 8,
//                         color: Colors.blue))
//               ],
//             ),
//           ],
//         ),
//         actions: <Widget>[
//           GestureDetector(
//             child: Icon(Icons.more_vert),
//           )
//         ],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           children: <Widget>[
//             UserAccountsDrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.blue[900],
//               ),
//               accountName: Text(username),
//               accountEmail: Text(email),
//               currentAccountPicture: CircleAvatar(
//                 backgroundImage: NetworkImage(
//                     "https://cdn.clipart.email/93ce84c4f719bd9a234fb92ab331bec4_frisco-specialty-clinic-vail-health_480-480.png"),
//               ),
//               onDetailsPressed: () {},
//             ),
//             ListTile(
//               leading: Icon(Icons.exit_to_app),
//               title: Text("Logout"),
//               subtitle: Text("Sign out of this account"),
//               onTap: () async {
//                 // await _auth.signOut();
//                 Navigator.pushReplacementNamed(context, '/');
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: <Widget>[
//           ChatStream(),
//           Container(
//             padding: EdgeInsets.symmetric(vertical:10,horizontal: 10),
//             decoration: kMessageContainerDecoration,
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Expanded(
//                   child: Material(
//                     borderRadius: BorderRadius.circular(50),
//                     color: Colors.white,
//                     elevation:5,
//                     child: Padding(
//                       padding: const EdgeInsets.only(left:8.0,top:2,bottom: 2),
//                       child: TextField(
//                         onChanged: (value) {
//                           // messageText = value;
//                         },
//                         controller: chatMsgTextController,
//                         decoration: kMessageTextFieldDecoration,
//                       ),
//                     ),
//                   ),
//                 ),
//                 MaterialButton(
//                   shape: CircleBorder(),
//                   color: Colors.blue,
//                   onPressed: () {
//                     chatMsgTextController.clear();
//                     // _firestore.collection('messages').add({
//                     //   'sender': username,
//                     //   'text': messageText,
//                     //   'timestamp':DateTime.now().millisecondsSinceEpoch,
//                     //   'senderemail': email
//                     // });
//                   },
//                   child:Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Icon(Icons.send,color: Colors.white,),
//                   ) 
//                   // Text(
//                   //   'Send',
//                   //   style: kSendButtonTextStyle,
//                   // ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ChatStream extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       // stream: _firestore.collection('messages').orderBy('timestamp').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           final messages = 'Hello';
//           List<MessageBubble> messageWidgets = [];
//           // for (var message in messages) {
//           //   final msgText = message.data['text'];
//           //   final msgSender = message.data['sender'];
//           //   // final msgSenderEmail = message.data['senderemail'];
//           //   final currentUser = loggedInUser.displayName;

//           //   // print('MSG'+msgSender + '  CURR'+currentUser);
//           //   final msgBubble = MessageBubble(
//           //       msgText: msgText,
//           //       msgSender: msgSender,
//           //       user: currentUser == msgSender);
//           //   messageWidgets.add(msgBubble);
//           // }
//           return Expanded(
//             child: ListView(
//               reverse: true,
//               padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
//               children: messageWidgets,
//             ),
//           );
//         } 
//         else {
//           return Center(
//             child:
//                 CircularProgressIndicator(backgroundColor: Colors.blue),
//           );
//         }
//       }, stream: null,
//     );
//   }
// }

// class MessageBubble extends StatelessWidget {
//   final String msgText;
//   final String msgSender;
//   final bool user;
//   MessageBubble({required this.msgText, required this.msgSender, required this.user});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: Column(
//         crossAxisAlignment:
//             user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: <Widget>[
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 10),
//             child: Text(
//               msgSender,
//               style: TextStyle(
//                   fontSize: 13, fontFamily: 'Poppins', color: Colors.black87),
//             ),
//           ),
//           Material(
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(50),
//               topLeft: user ? Radius.circular(50) : Radius.circular(0),
//               bottomRight: Radius.circular(50),
//               topRight: user ? Radius.circular(0) : Radius.circular(50),
//             ),
//             color: user ? Colors.blue : Colors.white,
//             elevation: 5,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//               child: Text(
//                 msgText,
//                 style: TextStyle(
//                   color: user ? Colors.white : Colors.blue,
//                   fontFamily: 'Poppins',
//                   fontSize: 15,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:oauth2_test/constants.dart';
// import '../constants.dart';

// String username = 'User';
// String email = 'user@example.com';

// class ChatterScreen extends StatefulWidget {
//   @override
//   _ChatterScreenState createState() => _ChatterScreenState();
// }

// class _ChatterScreenState extends State<ChatterScreen> {
//   final chatMsgTextController = TextEditingController();
//   List<MessageBubble> messages = [];

//   @override
//   void initState() {
//     super.initState();
//     getCurrentUser();
//     getMessages();
//   }

//   void getCurrentUser() async {
//     // Replace this with your own authentication logic
//     // For example, you might want to fetch the current user's details from your backend
//     setState(() {
//       username = 'Logged In User';
//       email = 'user@example.com';
//     });
//   }

//   void getMessages() async {
//     final response = await http.get(Uri.parse('http://localhost:7300/api/v1/messages/findAll'));
//     if (response.statusCode == 200) {
//       final List<dynamic> messageList = jsonDecode(response.body);
//       setState(() {
//         messages = messageList.map((message) {
//           return MessageBubble(
//             msgText: message['text'],
//             msgSender: message['sender'],
//             user: message['sender'] == username,
//           );
//         }).toList();
//       });
//     } else {
//       // Handle error
//       print('Failed to load messages');
//     }
//   }

//   void sendMessage(String messageText) async {
//     final response = await http.post(
//       Uri.parse('http://localhost:7300/api/v1/messages/create-message'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'sender': username,
//         'text': messageText,
//         'timestamp': DateTime.now().millisecondsSinceEpoch,
//         'senderEmail': email,
//       }),
//     );
//     if (response.statusCode == 201) {
//       // Message sent successfully, clear the text field and update the UI
//       chatMsgTextController.clear();
//       getMessages();
//     } else {
//       // Handle error
//       print('Failed to send message');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.blue),
//         elevation: 0,
//         bottom: PreferredSize(
//           preferredSize: Size(25, 10),
//           child: Container(
//             child: LinearProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//               backgroundColor: Colors.blue[100],
//             ),
//             decoration: BoxDecoration(
//                 color: Colors.blue,
//                 borderRadius: BorderRadius.circular(20)),
//             constraints: BoxConstraints.expand(height: 1),
//           ),
//         ),
//         backgroundColor: Colors.white10,
//         leading: Padding(
//           padding: const EdgeInsets.all(12.0),
//           // child: CircleAvatar(
//           //   backgroundImage: NetworkImage(
//           //     'https://cdn.clipart.email/93ce84c4f719bd9a234fb92ab331bec4_frisco-specialty-clinic-vail-health_480-480.png',
//           //   ),
//           // ),
//         ),
//         title: Row(
//           children: <Widget>[
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text(
//                   'Push Messenger',
//                   style: TextStyle(
//                       fontFamily: 'Poppins',
//                       fontSize: 16,
//                       color: Colors.blue),
//                 ),
//                 Text(
//                   'by SuperTech',
//                   style: TextStyle(
//                       fontFamily: 'Poppins',
//                       fontSize: 8,
//                       color: Colors.blue),
//                 )
//               ],
//             ),
//           ],
//         ),
//         actions: <Widget>[
//           GestureDetector(
//             child: Icon(Icons.more_vert),
//           )
//         ],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           children: <Widget>[
//             UserAccountsDrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.blue[900],
//               ),
//               accountName: Text(username),
//               accountEmail: Text(email),
//               // currentAccountPicture: CircleAvatar(
//               //   backgroundImage: NetworkImage(
//               //       "https://cdn.clipart.email/93ce84c4f719bd9a234fb92ab331bec4_frisco-specialty-clinic-vail-health_480-480.png"),
//               // ),
//               onDetailsPressed: () {},
//             ),
//             ListTile(
//               leading: Icon(Icons.exit_to_app),
//               title: Text("Logout"),
//               subtitle: Text("Sign out of this account"),
//               onTap: () async {
//                 // Replace this with your own logout logic
//                 Navigator.pushReplacementNamed(context, '/');
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: <Widget>[
//           ChatStream(messages: messages),
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//             decoration: kMessageContainerDecoration,
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Expanded(
//                   child: Material(
//                     borderRadius: BorderRadius.circular(50),
//                     color: Colors.white,
//                     elevation: 5,
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 8.0, top: 2, bottom: 2),
//                       child: TextField(
//                         onChanged: (value) {
//                           // messageText = value;
//                         },
//                         controller: chatMsgTextController,
//                         decoration: kMessageTextFieldDecoration,
//                       ),
//                     ),
//                   ),
//                 ),
//                 MaterialButton(
//                   shape: CircleBorder(),
//                   color: Colors.blue,
//                   onPressed: () {
//                     if (chatMsgTextController.text.isNotEmpty) {
//                       sendMessage(chatMsgTextController.text);
//                     }
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Icon(Icons.send, color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class ChatStream extends StatelessWidget {
//   final List<MessageBubble> messages;

//   ChatStream({required this.messages});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: ListView(
//         reverse: true,
//         padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
//         children: messages,
//       ),
//     );
//   }
// }

// class MessageBubble extends StatelessWidget {
//   final String msgText;
//   final String msgSender;
//   final bool user;

//   MessageBubble({required this.msgText, required this.msgSender, required this.user});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: Column(
//         crossAxisAlignment: user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: <Widget>[
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 10),
//             child: Text(
//               msgSender,
//               style: TextStyle(
//                   fontSize: 13, fontFamily: 'Poppins', color: Colors.black87),
//             ),
//           ),
//           Material(
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(50),
//               topLeft: user ? Radius.circular(50) : Radius.circular(0),
//               bottomRight: Radius.circular(50),
//               topRight: user ? Radius.circular(0) : Radius.circular(50),
//             ),
//             color: user ? Colors.blue : Colors.white,
//             elevation: 5,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//               child: Text(
//                 msgText,
//                 style: TextStyle(
//                   color: user ? Colors.white : Colors.blue,
//                   fontFamily: 'Poppins',
//                   fontSize: 15,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:oauth2_test/constants.dart';
import 'package:oauth2_test/tokenmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



class ChatterScreen extends StatefulWidget {
  final String token;
  final String username;
  final String email;
  final String sessionState;

  ChatterScreen({
    required this.token,
    required this.username,
    required this.email,
    required this.sessionState,
  });

  @override
  _ChatterScreenState createState() => _ChatterScreenState();
}

class _ChatterScreenState extends State<ChatterScreen> {
  final chatMsgTextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<MessageBubble> messages = [];

  @override
  void initState() {
    super.initState();
    print('Session State in ChatterScreen: ${widget.sessionState}');
    getMessages();
  }

  Future<void> getMessages() async {
    final url = Uri.parse('http://192.168.250.209:7300/api/v1/messages/findAll');
    final headers = {
      'Authorization': 'Bearer ${widget.token}',
    };

    print('Fetching messages from: $url with headers: $headers');

    try {
      final response = await http.get(url, headers: headers);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Assuming the messages are in a field called 'data'
        final List<dynamic> messageData = responseData['data'] ?? [];

        setState(() {
          messages = messageData.map((message) {
            return MessageBubble(
              msgText: message['message'] ?? 'No message',
              msgSender: message['senderId'] ?? 'Unknown',
              user: message['senderId'] == widget.username,
            );
          }).toList();
        });

        WidgetsBinding.instance?.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      } else {
        print('Failed to load messages');
      }
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  void sendMessage() async {
    final messageText = chatMsgTextController.text;

    if (messageText.isEmpty) {
      print('Message text is empty');
      return;
    }

    final url = Uri.parse('http://192.168.250.209:7300/api/v1/messages/create-message');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
      'apikey': '65bcc0d4-3d68-455c-b6c1-168c8f20eb27',
    };
    final body = jsonEncode({
      'sender': widget.username,
      'message': messageText,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'senderEmail': widget.email,
    });

    print('Sending message to: $url with headers: $headers and body: $body');

    try {
      final response = await http.post(url, headers: headers, body: body);

      print('Send message response status: ${response.statusCode}');
      print('Send message response body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          messages.add(MessageBubble(
            msgText: messageText,
            msgSender: widget.username,
            user: true,
          ));
          chatMsgTextController.clear();
        });
        _scrollToBottom();
      } else {
        print('Failed to send message: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> logout() async {
    final sessionState = widget.sessionState;
    if (sessionState.isEmpty) {
      print('No session state found.');
      return;
    }

    final logoutEndpoint = Uri.parse('http://192.168.250.209:8070/auth/admin/realms/Push/sessions/$sessionState');
    print('Logging out from: $logoutEndpoint with token: ${widget.token}');

    try {
      final response = await http.delete(
        logoutEndpoint,
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      print('Logout response status: ${response.statusCode}');
      print('Logout response body: ${response.body}');

      if (response.statusCode == 204) {
        print('Logout successful.');
        TokenManager.clearTokens();
        Navigator.pushReplacementNamed(context, '/'); // Adjust the route as needed
      } else {
        print('Logout failed: ${response.body}');
      }
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blue),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              backgroundColor: Colors.blue[100],
            ),
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20)),
            constraints: BoxConstraints.expand(height: 1),
          ),
        ),
        backgroundColor: Colors.white10,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
        ),
        title: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Push Messenger',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.blue),
                ),
                Text(
                  'by SuperTech',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 8,
                      color: Colors.blue),
                )
              ],
            ),
          ],
        ),
        actions: <Widget>[
          GestureDetector(
            child: Icon(Icons.more_vert),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue[900],
              ),
              accountName: Text(widget.username),
              accountEmail: Text(widget.email),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Logout"),
              subtitle: Text("Sign out of this account"),
              onTap: () async {
                await logout();
                // Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ChatStream(messages: messages, scrollController: _scrollController),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: kMessageContainerDecoration,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Material(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 2, bottom: 2),
                      child: TextField(
                        controller: chatMsgTextController,
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                  shape: CircleBorder(),
                  color: Colors.blue,
                  onPressed: () {
                    sendMessage();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatStream extends StatelessWidget {
  final List<MessageBubble> messages;
  final ScrollController scrollController;

  ChatStream({required this.messages, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        controller: scrollController,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        children: messages,
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String msgText;
  final String msgSender;
  final bool user;

  MessageBubble({
    required this.msgText,
    required this.msgSender,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              topLeft: user ? Radius.circular(50) : Radius.circular(0),
              bottomRight: Radius.circular(50),
              topRight: user ? Radius.circular(0) : Radius.circular(50),
            ),
            color: user ? Colors.blue : Colors.white,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                msgText,
                style: TextStyle(
                  color: user ? Colors.white : Colors.blue,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

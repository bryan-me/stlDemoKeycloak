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


import 'package:flutter/material.dart';
import 'package:oauth2_test/constants.dart';
import '../constants.dart';

String username = 'Logged In User';
String email = 'user@example.com';

class ChatterScreen extends StatefulWidget {
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
    getCurrentUser();
    getMessages();
  }

  void getCurrentUser() {
    setState(() {
      username = 'Logged In User';
      email = 'user@example.com';
    });
  }

  void getMessages() {
    // Dummy data for messages
    final dummyMessages = [
      {'text': 'Hello there!', 'sender': 'Friend'},
      {'text': 'Hi! How are you?', 'sender': 'Logged In User'},
      {'text': 'I am good, thank you!', 'sender': 'Friend'},
      {'text': 'What about you?', 'sender': 'Friend'},
      {'text': 'I am doing great, thanks!', 'sender': 'Logged In User'},
    ];
    setState(() {
      messages = dummyMessages.map((message) {
        return MessageBubble(
          msgText: message['text'] as String,
          msgSender: message['sender'] as String,
          user: message['sender'] == username,
        );
      }).toList();
    });

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void sendMessage(String messageText) {
    final newMessage = {
      'text': messageText,
      'sender': username,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'senderEmail': email,
    };
    setState(() {
      messages.add(MessageBubble(
        msgText: newMessage['text'] as String,
        msgSender: newMessage['sender'] as String,
        user: true,
      ));
      chatMsgTextController.clear();
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blue),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size(25, 10),
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
              accountName: Text(username),
              accountEmail: Text(email),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Logout"),
              subtitle: Text("Sign out of this account"),
              onTap: () async {
                Navigator.pushReplacementNamed(context, '/');
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
                        onChanged: (value) {
                        },
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
                    if (chatMsgTextController.text.isNotEmpty) {
                      sendMessage(chatMsgTextController.text);
                    }
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

  MessageBubble({required this.msgText, required this.msgSender, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          // Hello
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


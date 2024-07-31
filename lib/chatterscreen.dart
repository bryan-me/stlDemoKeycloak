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

// import 'dart:convert';
// import 'package:centrifuge/centrifuge.dart' as centrifuge;
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:oauth2_test/constants.dart';
// import 'package:oauth2_test/service/client/client.dart';
// import 'package:oauth2_test/tokenmanager.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class ChatterScreen extends StatefulWidget {
//   final String token;
//   final String username;
//   final String email;
//   final String sessionState;

//   ChatterScreen({
//     required this.token,
//     required this.username,
//     required this.email,
//     required this.sessionState,
//   });

//   @override
//   _ChatterScreenState createState() => _ChatterScreenState();
// }

// class _ChatterScreenState extends State<ChatterScreen> {
//   final chatMsgTextController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   List<MessageBubble> messages = [];
//   late centrifuge.Client centrifugoClient;
//   late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//   late ChatClient chatClient;

//   @override
//   void initState() {
//     super.initState();
//     print('Session State in ChatterScreen: ${widget.sessionState}');
//     getMessages();
//     // connectToCentrifugo();
//     initNotifications();
//     chatClient = ChatClient();
//     _initializeChatClient();
//   }

// Future<void> _initializeChatClient() async {
//   // await chatClient.init(widget.username, widget.token.hashCode); // or any unique user ID
//   await chatClient.connect(() {
//     chatClient.subscribe('chat_channel').then((_) {
//       chatClient.subscription?.publication.map<String>((e) => utf8.decode(e.data)).listen((data) {
//         final d = json.decode(data) as Map<String, dynamic>;
//         final msg = d["message"].toString();
//         final username = d["username"].toString();
//         if (username != widget.username) { // Don't add own messages
//           setState(() {
//             messages.add(MessageBubble(
//               msgText: msg,
//               msgSender: username,
//               user: false,
//             ));
//           });
//           _scrollToBottom();
//         }
//       });
//     });
//   });
// }

//   void initNotifications() {
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//     flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

// //     const AndroidNotificationDetails androidPlatformChannelSpecifics =
// //         AndroidNotificationDetails(
// //       'your_channel_id',
// //       'your_channel_name',
// //       channelDescription: 'your_channel_description',
// //       importance: Importance.max,
// //       priority: Priority.high,
// //       showWhen: false,
// //     );
// //     const NotificationDetails platformChannelSpecifics =
// //         NotificationDetails(android: androidPlatformChannelSpecifics);
// //     await flutterLocalNotificationsPlugin.show(
// //       0,
// //       'New Message',
// //       message,
// //       platformChannelSpecifics,
// //       payload: 'item x',
// //     );
// //   }

//   Future<void> getMessages() async {
//     final url = Uri.parse('http://192.168.250.209:7300/api/v1/messages/findAll');
//     final headers = {
//       'Authorization': 'Bearer ${widget.token}',
//     };

//     print('Fetching messages from: $url with headers: $headers');

//     try {
//       final response = await http.get(url, headers: headers);

//       print('Response status: ${response.statusCode}');
//       print('Response body: ${response.body}');

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = jsonDecode(response.body);

//         // Assuming the messages are in a field called 'data'
//         final List<dynamic> messageData = responseData['data'] ?? [];

//         setState(() {
//           messages = messageData.map((message) {
//             return MessageBubble(
//               msgText: message['message'] ?? 'No message',
//               msgSender: message['senderId'] ?? 'Unknown',
//               user: message['senderId'] == widget.username,
//             );
//           }).toList();
//         });

//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           _scrollToBottom();
//         });
//       } else {
//         print('Failed to load messages');
//       }
//     } catch (e) {
//       print('Error fetching messages: $e');
//     }
//   }

//   void sendMessage() async {
//     final messageText = chatMsgTextController.text;

//     if (messageText.isEmpty) {
//       print('Message text is empty');
//       return;
//     }

//     final url = Uri.parse('http://192.168.250.209:7300/api/v1/messages/create-message');
//     final headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer ${widget.token}',
//       'apikey': '65bcc0d4-3d68-455c-b6c1-168c8f20eb27',
//     };
//     final body = jsonEncode({
//       'sender': widget.username,
//       'message': messageText,
//       'timestamp': DateTime.now().millisecondsSinceEpoch,
//       'senderEmail': widget.email,
//     });

//     print('Sending message to: $url with headers: $headers and body: $body');

//     try {
//       final response = await http.post(url, headers: headers, body: body);

//       print('Send message response status: ${response.statusCode}');
//       print('Send message response body: ${response.body}');

//       if (response.statusCode == 200) {
//         setState(() {
//           messages.add(MessageBubble(
//             msgText: messageText,
//             msgSender: widget.username,
//             user: true,
//           ));
//           chatMsgTextController.clear();
//         });
//         _scrollToBottom();
//       } else {
//         print('Failed to send message: ${response.statusCode} ${response.body}');
//       }
//     } catch (e) {
//       print('Error sending message: $e');
//     }
//   }

//   void _scrollToBottom() {
//     _scrollController.animateTo(
//       _scrollController.position.maxScrollExtent,
//       duration: Duration(milliseconds: 300),
//       curve: Curves.easeOut,
//     );
//   }

//   Future<void> logout() async {
//     final sessionState = widget.sessionState;
//     if (sessionState.isEmpty) {
//       print('No session state found.');
//       return;
//     }

//     final logoutEndpoint = Uri.parse('http://192.168.250.209:8070/auth/admin/realms/Push/sessions/$sessionState');
//     print('Logging out from: $logoutEndpoint with token: ${widget.token}');

//     try {
//       final response = await http.delete(
//         logoutEndpoint,
//         headers: {
//           'Authorization': 'Bearer ${widget.token}',
//           'Content-Type': 'application/json',
//         },
//       );

//       print('Logout response status: ${response.statusCode}');
//       print('Logout response body: ${response.body}');

//       if (response.statusCode == 204) {
//         print('Logout successful.');
//         TokenManager.clearTokens();
//         Navigator.pushReplacementNamed(context, '/'); // Adjust the route as needed
//       } else {
//         print('Logout failed: ${response.body}');
//       }
//     } catch (e) {
//       print('Error during logout: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.blue),
//         elevation: 0,
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(1),
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
//               accountName: Text(widget.username),
//               accountEmail: Text(widget.email),
//             ),
//             ListTile(
//               leading: Icon(Icons.exit_to_app),
//               title: Text("Logout"),
//               subtitle: Text("Sign out of this account"),
//               onTap: () async {
//                 await logout();
//                 // Navigator.pushReplacementNamed(context, '/');
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: <Widget>[
//           ChatStream(messages: messages, scrollController: _scrollController),
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
//                     sendMessage();
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
//   final ScrollController scrollController;

//   ChatStream({required this.messages, required this.scrollController});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: ListView(
//         controller: scrollController,
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

//   MessageBubble({
//     required this.msgText,
//     required this.msgSender,
//     required this.user,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: Column(
//         crossAxisAlignment: user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: <Widget>[
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

// import 'dart:convert';
// import 'package:centrifuge/centrifuge.dart' as centrifuge;
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:logging/logging.dart';
// import 'package:oauth2_test/constants.dart';
// import 'package:oauth2_test/tokenmanager.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class ChatterScreen extends StatefulWidget {
//   final String token;
//   final String username;
//   final String email;
//   final String sessionState;

//   ChatterScreen({
//     required this.token,
//     required this.username,
//     required this.email,
//     required this.sessionState,
//   });

//   @override
//   _ChatterScreenState createState() => _ChatterScreenState();
// }

// class _ChatterScreenState extends State<ChatterScreen> {
//   final logger = Logger('$_ChatterScreenState');
//   final chatMsgTextController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   List<MessageBubble> messages = [];
//   late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//   late centrifuge.Client centrifugoClient;

//   @override
//   void initState() {
//     super.initState();
//     print('Session State in ChatterScreen: ${widget.sessionState}');
//     getMessages();
//     connectToCentrifugo();
//     initNotifications();
//   }

//   void initNotifications() {
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//     flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   Future<void> connectToCentrifugo() async {
//     final url = Uri.parse('http://192.168.250.209:7300/api/v1/messages/credentials');
//     final headers = {
//       'Authorization': 'Bearer ${widget.token}',
//       'Content-Type': 'application/json',
//     };

//     print('Fetching Centrifugo credentials from: $url with headers: $headers');

//     try {
//       final response = await http.get(url, headers: headers);

//       print('Response status: ${response.statusCode}');
//       print('Response body: ${response.body}');

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = jsonDecode(response.body);
//         final centrifugoToken = responseData['token'];

//         print('Connecting to Centrifugo with token: $centrifugoToken');

//         final onEvent = (dynamic event) {
//           print('This is the centrifugo event > $event');
//             // print('client event> $event');
//         };

//        final onError = (dynamic error) {
//         print('This is the centrifugo error > $error');
//         if (error is centrifuge.Error) {
//           print('Error code: ${error.code}, message: ${error.message}');
//         }
//       };

//         // Create Centrifugo client with WebSocket URL
//         centrifugoClient = centrifuge.createClient(
//           'wss://smpp.stlghana.com/connection/websocket?token=$centrifugoToken&id=1',
//           centrifuge.ClientConfig(
//             token: centrifugoToken,
//           ),
//         );

//         print('$centrifugoClient');

//         centrifugoClient.connecting.listen(onEvent);
//         centrifugoClient.connected.listen(onEvent);
//         centrifugoClient.disconnected.listen(onEvent);
//         centrifugoClient.error.listen(onError);

//         await centrifugoClient.connect();

//         final onSubscriptionEvent = (dynamic event) async {
//           print('subscription> $event');
//         };

//         final onSubscriptionError = (dynamic error) {
//         print('subscription error> $error');
//       };

//         final subscription = centrifugoClient.newSubscription('downSitesMonitor');

//         subscription.subscribing.listen(onSubscriptionEvent);
//         subscription.subscribed.listen(onSubscriptionEvent);
//         subscription.unsubscribed.listen(onSubscriptionEvent);
//         subscription.error.listen(onSubscriptionError);

//         await subscription.subscribe();
//       } else {
//         print('Failed to fetch Centrifugo credentials');
//       }
//     } catch (e) {
//       print('Error fetching Centrifugo credentials: $e');
//     }
//   }

//   void _onNewMessage(centrifuge.PublicationEvent event) {
//     try {
//       final messageData = jsonDecode(utf8.decode(event.data)) as Map<String, dynamic>;
//       print('Parsed message data: $messageData');

//       final message = MessageBubble(
//         msgText: messageData['message'] ?? 'No message',
//         msgSender: messageData['senderId'] ?? 'Unknown',
//         user: messageData['senderId'] == widget.username,
//       );

//       setState(() {
//         messages.add(message);
//       });
//       _scrollToBottom();

//       _showNotification(messageData['message']);
//     } catch (e) {
//       print('Error parsing message: $e');
//     }
//   }

//   Future<void> _showNotification(String message) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'your_channel_id',
//       'your_channel_name',
//       channelDescription: 'your_channel_description',
//       importance: Importance.max,
//       priority: Priority.high,
//       showWhen: false,
//     );
//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       'New Message',
//       message,
//       platformChannelSpecifics,
//       payload: 'item x',
//     );
//   }

//   Future<void> getMessages() async {
//     final url = Uri.parse('http://192.168.250.209:7300/api/v1/messages/findAll');
//     final headers = {
//       'Authorization': 'Bearer ${widget.token}',
//     };

//     print('Fetching messages from: $url with headers: $headers');

//     try {
//       final response = await http.get(url, headers: headers);

//       print('Response status: ${response.statusCode}');
//       print('Response body: ${response.body}');

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = jsonDecode(response.body);

//         // Assuming the messages are in a field called 'data'
//         final List<dynamic> messageData = responseData['data'] ?? [];

//         setState(() {
//           messages = messageData.map((message) {
//             return MessageBubble(
//               msgText: message['message'] ?? 'No message',
//               msgSender: message['senderId'] ?? 'Unknown',
//               user: message['senderId'] == widget.username,
//             );
//           }).toList();
//         });

//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           _scrollToBottom();
//         });
//       } else {
//         print('Failed to load messages');
//       }
//     } catch (e) {
//       print('Error fetching messages: $e');
//     }
//   }

//   void sendMessage() async {
//     final messageText = chatMsgTextController.text;

//     if (messageText.isEmpty) {
//       print('Message text is empty');
//       return;
//     }

//     final url = Uri.parse('http://192.168.250.209:7300/api/v1/messages/create-message');
//     final headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer ${widget.token}',
//       'apikey': '65bcc0d4-3d68-455c-b6c1-168c8f20eb27',
//     };
//     final body = jsonEncode({
//       'sender': widget.username,
//       'message': messageText,
//       'timestamp': DateTime.now().millisecondsSinceEpoch,
//       'senderEmail': widget.email,
//     });

//     print('Sending message to: $url with headers: $headers and body: $body');

//     try {
//       final response = await http.post(url, headers: headers, body: body);

//       print('Send message response status: ${response.statusCode}');
//       print('Send message response body: ${response.body}');

//       if (response.statusCode == 200) {
//         setState(() {
//           messages.add(MessageBubble(
//             msgText: messageText,
//             msgSender: widget.username,
//             user: true,
//           ));
//           chatMsgTextController.clear();
//         });
//         _scrollToBottom();
//       } else {
//         print('Failed to send message: ${response.statusCode} ${response.body}');
//       }
//     } catch (e) {
//       print('Error sending message: $e');
//     }
//   }

//   void _scrollToBottom() {
//     _scrollController.animateTo(
//       _scrollController.position.maxScrollExtent,
//       duration: Duration(milliseconds: 300),
//       curve: Curves.easeOut,
//     );
//   }

//   Future<void> logout() async {
//     final sessionState = widget.sessionState;
//     if (sessionState.isEmpty) {
//       print('No session state found.');
//       return;
//     }

//     final logoutEndpoint = Uri.parse('http://192.168.250.209:8070/auth/admin/realms/Push/sessions/$sessionState');
//     print('Logging out from: $logoutEndpoint with token: ${widget.token}');

//     try {
//       final response = await http.delete(
//         logoutEndpoint,
//         headers: {
//           'Authorization': 'Bearer ${widget.token}',
//           'Content-Type': 'application/json',
//         },
//       );

//       print('Logout response status: ${response.statusCode}');
//       print('Logout response body: ${response.body}');

//       if (response.statusCode == 204) {
//         print('Logout successful.');
//         TokenManager.clearTokens();
//         Navigator.pushReplacementNamed(context, '/'); // Adjust the route as needed
//       } else {
//         print('Logout failed: ${response.body}');
//       }
//     } catch (e) {
//       print('Error during logout: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.blue),
//         elevation: 0,
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(1),
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
//               accountName: Text(widget.username),
//               accountEmail: Text(widget.email),
//             ),
//             ListTile(
//               leading: Icon(Icons.exit_to_app),
//               title: Text("Logout"),
//               subtitle: Text("Sign out of this account"),
//               onTap: () async {
//                 await logout();
//                 // Navigator.pushReplacementNamed(context, '/');
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: <Widget>[
//           ChatStream(messages: messages, scrollController: _scrollController),
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
//                     sendMessage();
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
//   final ScrollController scrollController;

//   ChatStream({required this.messages, required this.scrollController});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: ListView(
//         controller: scrollController,
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

//   MessageBubble({
//     required this.msgText,
//     required this.msgSender,
//     required this.user,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: Column(
//         crossAxisAlignment: user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: <Widget>[
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
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:oauth2_test/constants.dart';
import 'package:oauth2_test/tokenmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ChatterScreen extends StatefulWidget {
  final String token;
  final String username;
  final String email;
  final String sub;

  ChatterScreen({
    required this.token,
    required this.username,
    required this.email,
    required this.sub,
  });

  @override
  _ChatterScreenState createState() => _ChatterScreenState();
}

class _ChatterScreenState extends State<ChatterScreen> {
  final logger = Logger('$_ChatterScreenState');
  final chatMsgTextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<MessageBubble> messages = [];
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late WebSocketChannel channel;

  @override
  void initState() {
    super.initState();
    print('Session State in ChatterScreen: ${widget.sub}');
    getMessages();
    connectToCentrifugo();
    initNotifications();
  }

  void initNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> connectToCentrifugo() async {
    final url =
        Uri.parse('http://192.168.250.209:7300/api/v1/messages/credentials');
    final headers = {
      'Authorization': 'Bearer ${widget.token}',
      'Content-Type': 'application/json',
    };

    print('Fetching Centrifugo credentials from: $url with headers: $headers');

    try {
      final response = await http.get(url, headers: headers);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final centrifugoToken = responseData['token'];

        print('Connecting to Centrifugo with token: $centrifugoToken');

        // Create WebSocket channel
        final websocketUrl = 'wss://smpp.stlghana.com/connection/websocket';
        channel = WebSocketChannel.connect(Uri.parse(websocketUrl));

        // Listen for messages from the WebSocket
        channel.stream.listen((message) {
          if (message is String) {
            print('Received String message: $message');
            _handleMessage(message);
          } else if (message is List<int>) {
            final decodedMessage = utf8.decode(message);
            print('Received List<int> message: $decodedMessage');
            _handleMessage(decodedMessage);
          }
        }, onError: (error) {
          print('WebSocket error: $error');
        }, onDone: () {
          print('WebSocket connection closed');
        });

        // Send authentication message with token and id
        final authMessage = jsonEncode({
          "params": {
            "token": centrifugoToken,
          },
          "id": 1
        });
        channel.sink.add(authMessage);
        print('Sent authentication message: $authMessage');

        // Subscribe to downSitesMonitor channel
        final subscribeMessage = jsonEncode({
          "method": 1,
          "params": {"channel": "save"},
          "id": 2
        });
        channel.sink.add(subscribeMessage);
        print('Sent subscription message: $subscribeMessage');

        // Publish to Channel
      } else {
        print('Failed to fetch Centrifugo credentials');
      }
    } catch (e) {
      print('Error fetching Centrifugo credentials: $e');
    }
  }

  void _handleMessage(dynamic message) {
    try {
      final messageData = jsonDecode(message) as Map<String, dynamic>?;

      if (messageData != null && messageData.containsKey('result')) {
        final result = messageData['result'] as Map<String, dynamic>?;
        if (result != null && result.containsKey('data')) {
          final dataWrapper = result['data'] as Map<String, dynamic>?;
          if (dataWrapper != null && dataWrapper.containsKey('data')) {
            final data = dataWrapper['data'] as Map<String, dynamic>?;

            final messageContent =
                data?['message'] as String? ?? 'Null message';
            // final status = data?['status'] as String? ?? 'Unknown status';

            // onMessageReceived('Site: $messageContent, Status: $status', 'System');
            onMessageReceived('$messageContent', 'User');
          } else {
            print('No "data" key in dataWrapper');
          }
        } else {
          print('No "data" key in result');
        }
      } else {
        print('No "result" key in messageData');
      }
    } catch (e) {
      print('Error parsing message: $e');
    }
  }

  void onMessageReceived(String messageContent, String sender) {
    final messageBubble = MessageBubble(
      msgText: messageContent,
      msgSender: sender,
      user: false,
    );

    setState(() {
      messages.add(messageBubble);
    });
    _scrollToBottom();

    _showNotification(messageContent);
  }

  Future<void> _showNotification(String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'Down Sites Monitor',
      channelDescription: 'channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'New Message',
      message,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  Future<void> getMessages() async {
    final url =
        Uri.parse('http://192.168.250.209:7300/api/v1/messages/findAll');
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

        WidgetsBinding.instance.addPostFrameCallback((_) {
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

    final url =
        Uri.parse('http://192.168.250.209:7300/api/v1/messages/create-message');
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
        print(
            'Failed to send message: ${response.statusCode} ${response.body}');
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
    final sub = widget.sub;
    if (sub.isEmpty) {
      print('No session state found.');
      return;
    }

    final logoutEndpoint = Uri.parse(
        'http://192.168.250.209:8070/auth/admin/realms/Push/users/$sub/sessions');
    print('Logging out from: $logoutEndpoint with token: ${widget.token}');

    try {
      final response = await http.get(
        logoutEndpoint,
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      print('Logout response status: ${response.statusCode}');
      print('Logout response body: ${response.body}');

      Navigator.pushReplacementNamed(
          context, '/'); // Adjust the route as needed
      if (response.statusCode == 204) {
        print('Logout successful.');
        TokenManager.clearTokens();
        Navigator.pushReplacementNamed(
            context, '/'); // Adjust the route as needed
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
                color: Colors.blue, borderRadius: BorderRadius.circular(20)),
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
                      color: Colors.blue.shade800),
                ),
                Text(
                  'by SuperTech',
                  style: TextStyle(
                      fontFamily: 'Poppins', fontSize: 8, color: Colors.blue),
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
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return messages[index];
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: chatMsgTextController,
                    decoration: kMessageTextFieldDecoration,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
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
        crossAxisAlignment:
            user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              topLeft: user ? Radius.circular(50) : Radius.circular(0),
              bottomRight: Radius.circular(50),
              topRight: user ? Radius.circular(0) : Radius.circular(50),
            ),
            color: user ? Colors.grey : Colors.blue.shade800,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                msgText,
                style: TextStyle(
                  color: user ? Colors.black : Colors.white,
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

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:logging/logging.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:oauth2_test/service/client/centrifugomanager.dart';

// class ChatterScreen extends StatefulWidget {
//   final String token;
//   final String username;
//   final String email;
//   final String sessionState;

//   ChatterScreen({
//     required this.token,
//     required this.username,
//     required this.email,
//     required this.sessionState,
//   });

//   @override
//   _ChatterScreenState createState() => _ChatterScreenState();
// }

// class _ChatterScreenState extends State<ChatterScreen> {
//   final logger = Logger('$_ChatterScreenState');
//   final chatMsgTextController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   List<MessageBubble> messages = [];
//   late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//   late CentrifugoManager centrifugoManager;

//   @override
//   void initState() {
//     super.initState();
//     print('Session State in ChatterScreen: ${widget.sessionState}');
//     getMessages();
//     initNotifications();
//     centrifugoManager = CentrifugoManager(
//       token: widget.token,
//       username: widget.username,
//       onMessageReceived: _handleMessage,
//     );
//     centrifugoManager.connect();
//   }

//   void initNotifications() {
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//     flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   void _handleMessage(String messageContent, String messageSender) {
//     final newMessage = MessageBubble(
//       msgText: messageContent,
//       msgSender: messageSender,
//       user: messageSender == widget.username,
//     );

//     setState(() {
//       messages.add(newMessage);
//     });
//     _scrollToBottom();

//     _showNotification(messageContent);
//   }

//   Future<void> _showNotification(String message) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'your_channel_id',
//       'your_channel_name',
//       channelDescription: 'your_channel_description',
//       importance: Importance.max,
//       priority: Priority.high,
//       showWhen: false,
//     );
//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       'New Message',
//       message,
//       platformChannelSpecifics,
//       payload: 'item x',
//     );
//   }

//   Future<void> getMessages() async {
//     final url = Uri.parse('http://192.168.250.209:7300/api/v1/messages/findAll');
//     final headers = {
//       'Authorization': 'Bearer ${widget.token}',
//     };

//     print('Fetching messages from: $url with headers: $headers');

//     try {
//       final response = await http.get(url, headers: headers);

//       print('Response status: ${response.statusCode}');
//       print('Response body: ${response.body}');

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = jsonDecode(response.body);

//         final List<dynamic> messageData = responseData['data'] ?? [];

//         setState(() {
//           messages = messageData.map((message) {
//             return MessageBubble(
//               msgText: message['message'] ?? 'No message',
//               msgSender: message['senderId'] ?? 'Unknown',
//               user: message['senderId'] == widget.username,
//             );
//           }).toList();
//         });

//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           _scrollToBottom();
//         });
//       } else {
//         print('Failed to load messages');
//       }
//     } catch (e) {
//       print('Error fetching messages: $e');
//     }
//   }

//   void sendMessage() async {
//     final messageText = chatMsgTextController.text;

//     if (messageText.isEmpty) {
//       print('Message text is empty');
//       return;
//     }

//     final url = Uri.parse('http://192.168.250.209:7300/api/v1/messages/create-message');
//     final headers = {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer ${widget.token}',
//       'apikey': '65bcc0d4-3d68-455c-b6c1-168c8f20eb27',
//     };
//     final body = jsonEncode({
//       'sender': widget.username,
//       'message': messageText,
//       'timestamp': DateTime.now().millisecondsSinceEpoch,
//       'senderEmail': widget.email,
//     });

//     print('Sending message to: $url with headers: $headers and body: $body');

//     try {
//       final response = await http.post(url, headers: headers, body: body);

//       print('Send message response status: ${response.statusCode}');
//       print('Send message response body: ${response.body}');

//       if (response.statusCode == 200) {
//         setState(() {
//           messages.add(MessageBubble(
//             msgText: messageText,
//             msgSender: widget.username,
//             user: true,
//           ));
//           chatMsgTextController.clear();
//         });
//         _scrollToBottom();
//       } else {
//         print('Failed to send message: ${response.statusCode} ${response.body}');
//       }
//     } catch (e) {
//       print('Error sending message: $e');
//     }
//   }

//   void _scrollToBottom() {
//     _scrollController.animateTo(
//       _scrollController.position.maxScrollExtent,
//       duration: Duration(milliseconds: 300),
//       curve: Curves.easeOut,
//     );
//   }

//   Future<void> logout() async {
//     final sessionState = widget.sessionState;
//     if (sessionState.isEmpty) {
//       print('No session state found.');
//       return;
//     }

//     final logoutEndpoint = Uri.parse('http://192.168.250.209:8070/auth/admin/realms/Push/sessions/$sessionState');
//     print('Logging out from: $logoutEndpoint with token: ${widget.token}');

//     try {
//       final response = await http.delete(
//         logoutEndpoint,
//         headers: {
//           'Authorization': 'Bearer ${widget.token}',
//           'Content-Type': 'application/json',
//         },
//       );

//       print('Logout response status: ${response.statusCode}');
//       print('Logout response body: ${response.body}');

//       if (response.statusCode == 204) {
//         print('Logout successful.');
//         // Clear tokens and navigate to login screen
//         Navigator.pushReplacementNamed(context, '/'); // Adjust the route as needed
//       } else {
//         print('Logout failed: ${response.body}');
//       }
//     } catch (e) {
//       print('Error during logout: $e');
//     }
//   }

//   @override
//   void dispose() {
//     centrifugoManager.disconnect();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Push Messenger'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: logout,
//           ),
//         ],
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 return messages[index];
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: <Widget>[
//                 Expanded(
//                   child: TextField(
//                     controller: chatMsgTextController,
//                     decoration: InputDecoration(
//                       hintText: 'Enter your message...',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MessageBubble extends StatelessWidget {
//   final String msgText;
//   final String msgSender;
//   final bool user;

//   MessageBubble({
//     required this.msgText,
//     required this.msgSender,
//     required this.user,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(10.0),
//       child: Column(
//         crossAxisAlignment:
//             user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             msgSender,
//             style: TextStyle(
//               fontSize: 12.0,
//               color: Colors.black54,
//             ),
//           ),
//           Material(
//             borderRadius: user
//                 ? BorderRadius.only(
//                     topLeft: Radius.circular(30.0),
//                     bottomLeft: Radius.circular(30.0),
//                     bottomRight: Radius.circular(30.0))
//                 : BorderRadius.only(
//                     topRight: Radius.circular(30.0),
//                     bottomLeft: Radius.circular(30.0),
//                     bottomRight: Radius.circular(30.0)),
//             elevation: 5.0,
//             color: user ? Colors.lightBlueAccent : Colors.white,
//             child: Padding(
//               padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//               child: Text(
//                 msgText,
//                 style: TextStyle(
//                   color: user ? Colors.white : Colors.black54,
//                   fontSize: 15.0,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

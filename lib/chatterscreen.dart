import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:oauth2_test/screens/form_list.dart';
import 'package:oauth2_test/widgets/internet_status.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:oauth2_test/constants.dart';
// import 'package:oauth2_test/tokenmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

WebSocketChannel? channel;

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

    // Variables to hold user details
  late String username;
  late String email;
  late String sub;

  @override
  void initState() {
    super.initState();
    print('Session State in ChatterScreen: ${widget.sub}');
     extractUserDetailsFromToken();
    getMessages();
    connectToCentrifugo();
    initNotifications();
  }

  void extractUserDetailsFromToken() {
    try {
      // Decode the JWT token
      final jwt = JWT.decode(widget.token);

      // Extract user details from the payload
      username = jwt.payload['name'];
      email = jwt.payload['email'];
      sub = jwt.payload['sub'];

      print('Extracted username: $username');
      print('Extracted email: $email');
      print('Extracted sub: $sub');
    } catch (e) {
      print('Error decoding JWT token: $e');
    }
  }

  bool isUserSender(String loggedInUsername, String senderUsername) {
  return loggedInUsername == senderUsername;
}


  void initNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void connectToCentrifugo() async {
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

        // Verify connection by listening to the WebSocket stream
        channel!.stream.listen((message) {
          print('WebSocket message received: $message');
          if (message is String) {
            _handleMessage(message);
          } else if (message is List<int>) {
            final decodedMessage = utf8.decode(message);
            _handleMessage(decodedMessage);
          }
        }, onError: (error) {
          print('WebSocket error: $error');
        }, onDone: () {
          print('WebSocket connection closed');
        });

        // Send authentication message with token
        final authMessage = jsonEncode({
          "params": {
            "token": centrifugoToken,
          },
          "id": 1
        });
        channel!.sink.add(authMessage);
        print('Sent authentication message: $authMessage');

        // Subscribe to downSitesMonitor channel
        final subscribeMessage = jsonEncode({
          "method": 1,
          "params": {"channel": "save"},
          "id": 2
        });
        channel!.sink.add(subscribeMessage);
        print('Sent subscription message: $subscribeMessage');
      } else {
        print('Failed to fetch Centrifugo credentials');
      }
    } catch (e) {
      print('Error fetching Centrifugo credentials: $e');
    }
  }

  void _handleMessage(dynamic message) {
  print('Raw message received: $message'); // Log the raw message

  try {
    final decodedMessage = message is String ? jsonDecode(message) : jsonDecode(utf8.decode(message));
    
    if (decodedMessage is Map<String, dynamic>) {
      if (decodedMessage.containsKey('result')) {
        final result = decodedMessage['result'] as Map<String, dynamic>?;

        if (result != null && result.containsKey('data')) {
          final dataWrapper = result['data'] as Map<String, dynamic>?;

          if (dataWrapper != null && dataWrapper.containsKey('data')) {
            final data = dataWrapper['data'] as Map<String, dynamic>?;

            final messageContent = data?['message'] as String? ?? 'Null message';
            final senderId = data?['senderId'] as String? ?? '';  // Get senderId
            final senderName = data?['sender'] as String? ?? 'Unknown'; // Get sender name

            final isUserMessage = senderId == widget.sub; // Check if the sender is the current user

            onMessageReceived(messageContent, senderName, isUserMessage);
          } else {
            print('No "data" key in dataWrapper');
          }
        } else {
          print('No "data" key in result');
        }
      } else {
        print('No "result" key in decodedMessage');
      }
    } else {
      print('Received message is not a valid JSON object: $decodedMessage');
    }
  } catch (e) {
    print('Error parsing message: $e');
  }
}

void onMessageReceived(String messageContent, String sender, bool isUserMessage) {
  final messageBubble = MessageBubble(
    msgText: messageContent,
    msgSender: username,
    user: isUserMessage,
  );

  setState(() {
    messages.add(messageBubble);
  });
  _scrollToBottom();

  if (!isUserMessage) {
    _showNotification(messageContent);
  }
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
              user: message['senderId'] == username,
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
      'senderId': widget.sub, // Use the unique identifier of the sender
      'sender': username, // Include the username in the payload
      'message': messageText,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'senderEmail': email,
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
            msgSender: username,
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
        // TokenManager.clearTokens();
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
                // Check internet status
                InternetStatusWidget(),
                // Text(
                //   'by SuperTech',
                //   style: TextStyle(
                //       fontFamily: 'Poppins', fontSize: 8, color: Colors.blue),
                // )
              ],
            ),
          ],
        ),
        actions: <Widget>[
          GestureDetector(
            child: Icon(Icons.more_vert),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FormListScreen()
                    // DynamicFormScreen(
                    //     formId: '871ea5f3-d4d0-4a76-815d-95d1b90756c3'),
                    ),
              );
            },
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

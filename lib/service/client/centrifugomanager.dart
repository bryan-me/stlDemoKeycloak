import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

class CentrifugoManager {
  final String token;
  final String username;
  final Function(String message, String sender) onMessageReceived;
  late WebSocketChannel _channel;

  CentrifugoManager({
    required this.token,
    required this.username,
    required this.onMessageReceived,
  });

  Future<void> connect() async {
    final url = Uri.parse('http://192.168.250.209:7300/api/v1/messages/credentials');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final centrifugoToken = responseData['token'];

        final websocketUrl = 'wss://smpp.stlghana.com/connection/websocket';
        _channel = WebSocketChannel.connect(Uri.parse(websocketUrl));

        _channel.stream.listen((message) {
          _handleMessage(message);
        }, onError: (error) {
          print('WebSocket error: $error');
        }, onDone: () {
          print('WebSocket connection closed');
        });

        final authMessage = jsonEncode({
          "params": {
            "token": centrifugoToken
          },
          "id": 1
        });
        _channel.sink.add(authMessage);

        final subscriptionMessage = jsonEncode({
          "method": 1,
          "params": {
            "channel": "downSitesMonitor"
          },
          "id": 2
        });
        _channel.sink.add(subscriptionMessage);
      } else {
        print('Failed to fetch Centrifugo credentials');
      }
    } catch (e) {
      print('Error fetching Centrifugo credentials: $e');
    }
  }

  void _handleMessage(dynamic message) {
    try {
      final messageData = jsonDecode(message) as Map<String, dynamic>;

      if (messageData.containsKey('params') && messageData['params'].containsKey('data')) {
        final messageContent = messageData['params']['data']['message'] ?? 'No message';
        final messageSender = messageData['params']['data']['sender'] ?? 'Unknown';

        onMessageReceived(messageContent, messageSender);
      }
    } catch (e) {
      print('Error parsing message: $e');
    }
  }

  void disconnect() {
    _channel.sink.close();
  }
}

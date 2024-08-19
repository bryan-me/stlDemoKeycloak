import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class WebSocketManager {
  WebSocketChannel? channel;
  Timer? _reconnectTimer;
  String? centrifugoToken;

  Future<void> connectToCentrifugo(String token) async {
    final url =
        Uri.parse('http://192.168.250.209:7300/api/v1/messages/credentials');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    print('Fetching Centrifugo credentials from: $url with headers: $headers');

    try {
      final response = await http.get(url, headers: headers);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        centrifugoToken = responseData['token'];

        print('Connecting to Centrifugo with token: $centrifugoToken');

        _connectWebSocket();
      } else {
        print('Failed to fetch Centrifugo credentials');
      }
    } catch (e) {
      print('Error fetching Centrifugo credentials: $e');
      _attemptReconnect(token);
    }
  }

  void _connectWebSocket() {
    final websocketUrl = 'wss://smpp.stlghana.com/connection/websocket';
    channel = WebSocketChannel.connect(Uri.parse(websocketUrl));

    // Listen for messages from the WebSocket
    channel?.stream.listen(
      (message) {
        print('WebSocket message received: $message');
        if (message is String) {
          _handleMessage(message);
        } else if (message is List<int>) {
          final decodedMessage = utf8.decode(message);
          _handleMessage(decodedMessage);
        }
      },
      onError: (error) {
        print('WebSocket error: $error');
        _attemptReconnect(centrifugoToken!);
      },
      onDone: () {
        print('WebSocket connection closed');
        _attemptReconnect(centrifugoToken!);
      },
    );

    // Send authentication message with token and id
    final authMessage = jsonEncode({
      "params": {
        "token": centrifugoToken,
      },
      "id": 1,
    });
    channel?.sink.add(authMessage);
    print('Sent authentication message: $authMessage');

    // Subscribe to downSitesMonitor channel
    final subscribeMessage = jsonEncode({
      "method": 1,
      "params": {"channel": "save"},
      "id": 2,
    });
    channel?.sink.add(subscribeMessage);
    print('Sent subscription message: $subscribeMessage');
  }

  void _attemptReconnect(String token) {
    _reconnectTimer?.cancel();

    _reconnectTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      print('Attempting to reconnect...');
      try {
        connectToCentrifugo(token);
        if (channel != null) {
          timer.cancel(); // Stop the reconnection attempts
          _resubscribe(); // Re-subscribe after reconnecting
        }
      } catch (e) {
        print('Reconnection failed: $e');
      }
    });
  }

  void _resubscribe() {
    if (channel != null && centrifugoToken != null) {
      // Resubscribe to channels or send any initial messages
      final subscribeMessage = jsonEncode({
        "method": 1,
        "params": {"channel": "save"},
        "id": 2,
      });
      channel?.sink.add(subscribeMessage);
      print('Resent subscription message: $subscribeMessage');
    }
  }

  void dispose() {
    channel?.sink.close(status.goingAway);
    _reconnectTimer?.cancel();
  }

  void _handleMessage(String message) {
    // Handle incoming messages
  }
}

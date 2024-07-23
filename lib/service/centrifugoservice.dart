import 'dart:async';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CentrifugoService {
  final String url;
  final String token;
  final WebSocketChannel channel;
  final StreamController<String> _messageController = StreamController<String>();

  CentrifugoService({required this.url, required this.token})
      : channel = WebSocketChannel.connect(Uri.parse(url));

  Stream<String> get messages => _messageController.stream;

  void connect() {
    channel.sink.add('{"method":"subscribe","params":{"channel":"chat"}}');

    channel.stream.listen((message) {
      // Handle incoming messages
      _messageController.add(message);
    }, onError: (error) {
      print('WebSocket error: $error');
    });
  }

  void dispose() {
    channel.sink.close();
    _messageController.close();
  }
}

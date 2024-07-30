import 'package:flutter/material.dart';
import 'package:centrifuge/centrifuge.dart' as centrifuge;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CentrifugoDemo(),
    );
  }
}

class CentrifugoDemo extends StatefulWidget {
  @override
  _CentrifugoDemoState createState() => _CentrifugoDemoState();
}

class _CentrifugoDemoState extends State<CentrifugoDemo> {
  centrifuge.Client? _client;

  final String CENTRIFUGO_WEBSOCKET = 'wss://smpp.stlghana.com/connection/websocket'; // Replace with your Centrifugo WebSocket URL
  final String CENTRIFUGO_ACCESS_TOKEN = 'eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJDZW50cmlmdWdvV2ViIiwiYXVkIjoiQ2VudHJpZnVnbyIsImlhdCI6MTcyMTgzODA2MCwiZXhwIjoxNzI0NTE2NDYwLCJzdWIiOiI1YzRlZWEyNi0zMTRlLTQ2MDItOTZlNi1hMTA3MGNkZDExMzYifQ.BKWEcrLeYBqYzTvo4IbHYLsHTRaXnLqSw5JFvuv1cg4'; // Replace with your JWT token

  @override
  void initState() {
    super.initState();
    _connectToCentrifugo();
  }

  void _connectToCentrifugo() async {
    _client = centrifuge.createClient(
      CENTRIFUGO_WEBSOCKET,
      centrifuge.ClientConfig(
        token: CENTRIFUGO_ACCESS_TOKEN,
      ),
    );

    _client?.connected.listen((event) {
      print('Connected to Centrifugo');
    });

    _client?.disconnected.listen((event) {
      print('Disconnected from Centrifugo');
    });

    await _client?.connect();

    _subscribeToChannels();
  }

  void _subscribeToChannels() {
    final channels = ['downSitesMonitor', 'notification', 'reminderChannel'];

    for (var channel in channels) {
      final sub = _client?.getSubscription(channel);

      sub?.subscribed.listen((event) {
        print('Subscribed to $channel');
      });

      sub?.subscribing.listen((event) {
        print('Failed to subscribe to $channel: ${event}');
      });

      sub?.publication.listen((event) {
        print('Data from $channel: ${event.data}');
      });

      sub?.subscribe();
    }
  }

  @override
  void dispose() {
    _client?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Centrifugo Demo'),
      ),
      body: Center(
        child: Text('Connected to Centrifugo'),
      ),
    );
  }
}
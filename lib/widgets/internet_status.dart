import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetStatusWidget extends StatefulWidget {
  @override
  _InternetStatusWidgetState createState() => _InternetStatusWidgetState();
}

class _InternetStatusWidgetState extends State<InternetStatusWidget> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _updateConnectionStatus(result);
    } as void Function(ConnectivityResult event)?);
  }

  Future<void> _initConnectivity() async {
    ConnectivityResult result;
    try {
      result = (await _connectivity.checkConnectivity()) as ConnectivityResult;
    } catch (e) {
      result = ConnectivityResult.none;
    }
    if (!mounted) {
      return;
    }
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    String status;
    switch (_connectionStatus) {
      case ConnectivityResult.wifi:
        status = 'Connected to WiFi';
        break;
      case ConnectivityResult.mobile:
        status = 'Connected to Mobile Network';
        break;
      case ConnectivityResult.none:
      default:
        status = 'No Internet Connection';
        break;
    }

   return Container(
  color: _connectionStatus == ConnectivityResult.none ? Colors.red : Colors.green,
  padding: EdgeInsets.all(8.0), 
  child: Row(
    children: [
      CircleAvatar(
        radius: 4.0, 
        backgroundColor: Colors.white, 
      ),
      SizedBox(width: 8.0), 
      Text(
        status,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 10,
          color: Colors.white,
        ),
      ),
    ],
  ),
);

        

  }
}

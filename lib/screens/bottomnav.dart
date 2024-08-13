import 'package:flutter/material.dart';
import 'package:oauth2_test/chatterscreen.dart';
import 'package:oauth2_test/screens/form_list.dart';
import 'package:oauth2_test/tokenmanager.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  // Ensure the required values are accessible from TokenManager or passed accordingly
  final List<Widget> _widgetOptions = <Widget>[
    ChatterScreen(
      token: TokenManager.accessToken ?? '',
      username: username ?? '',
      email: email ?? '',
      sub: TokenManager.sub ?? '',
    ), // Chat screen
    FormListScreen(),// MyHomePage(title: 'Home'), // Home screen
     FormListScreen(),
     FormListScreen(),  // Form screen (Uncomment when the form screen is ready)
      ChatterScreen(
      token: TokenManager.accessToken ?? '',
      username: username ?? '',
      email: email ?? '',
      sub: TokenManager.sub ?? '',
    ),
  ];
  
  static get email => null;
  
  static get username => null;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Task',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: 'Incidents',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.poll),
            label: 'Surveys',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue.shade800,
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
      selectedLabelStyle: TextStyle(fontSize: 12), // Adjust label font size
      unselectedLabelStyle: TextStyle(fontSize: 10), // Smaller font size for unselected items
      ),
    );
  }
}

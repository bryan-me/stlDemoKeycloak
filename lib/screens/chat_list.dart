// chat_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:oauth2_test/chatterscreen.dart';

class ChatList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dummy data for contacts
    final contacts = [
      {'username': 'Dummy User', 'lastMessage': 'Last Message'},
      {'username': 'Bob Marley', 'lastMessage': 'Last Message'},
      {'username': 'Charlie Puth', 'lastMessage': 'Last Message'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        backgroundColor: Colors.blue.shade800,
        leading: null,
      ),
      body: ListView.separated(
        itemCount: contacts.length,
        separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[300]),
        itemBuilder: (context, index) {
          final contact = contacts[index];
          final nameParts = contact['username']!.split(' ');
          final initials = nameParts.length > 1
              ? '${nameParts[0][0]}${nameParts[1][0]}'
              : '${nameParts[0][0]}';

          return ListTile(
            leading: CircleAvatar(
              child: Text(initials, style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.blue.shade800,
            ),
            title: Text(contact['username']!),
            subtitle: Text(contact['lastMessage']!),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatterScreen(
                    token: 'YOUR_AUTH_TOKEN', // Pass actual token
                    username: contact['username']!,
                    email: 'default@example.com', // Placeholder; replace with actual email
                    sub: 'YOUR_SESSION_STATE', // Pass actual session state
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
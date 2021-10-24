import 'package:chat/widgets/chat/messages.dart';
import 'package:chat/widgets/chat/new_message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final fbm = FirebaseMessaging();
    fbm.configure(onMessage: (msg) async {
      print(msg);
      return;
    }, onLaunch: (msg) async {
      print(msg);

      return;
    }, onResume: (msg) async {
      Future.delayed(Duration.zero).then((value) => showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Text('Test'),
              )));
      print(msg);
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'IMessage',
          style: TextStyle(
              fontFamily: 'Ephesis',
              fontSize: 35,
              color: Theme.of(context).colorScheme.secondary),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: DropdownButton(
              onTap: () {},
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  value: 'logout',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [Icon(Icons.logout), Text('Logout')],
                  ),
                )
              ],
              onChanged: (value) {
                if (value == 'logout') {
                  FirebaseAuth.instance.signOut();
                }
              },
            ),
          )
        ],
      ),
      body: Column(
        children: [Expanded(child: Messages()), NewMessage()],
      ),
    );
  }
}

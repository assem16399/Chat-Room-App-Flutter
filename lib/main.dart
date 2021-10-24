import './screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './screens/chat_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.yellowAccent),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              backgroundColor: MaterialStateProperty.all(Colors.cyan),
              foregroundColor: MaterialStateProperty.all(Colors.yellowAccent),
            ),
          ),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (context, streamDataSnapshot) {
            if (streamDataSnapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: Text('Loading..'),
                ),
              );
            }
            if (streamDataSnapshot.hasData) {
              return ChatScreen();
            }
            return AuthScreen();
          },
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_sample/home.dart';
import 'package:firebase_sample/login.dart';

void main() {
  runApp(InitialView());
}

class InitialView extends StatefulWidget {
  @override
  _InitialViewState createState() => _InitialViewState();
}

class _InitialViewState extends State<InitialView> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Center(
            child: Text("🤕 Something weent wrong"),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return FirebasseApp();
        }

        return Material(
          child: Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
      },
    );
  }
}

class FirebasseApp extends StatefulWidget {
  FirebasseApp({
    Key? key,
  }) : super(key: key);

  @override
  _FirebasseAppState createState() => _FirebasseAppState();
}

class _FirebasseAppState extends State<FirebasseApp> {
  late final _stream;

  @override
  void initState() {
    _stream = FirebaseAuth.instance.authStateChanges();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.orange,
            ),
            routes: {
              '/login': (_) => Login(),
              '/': (_) => Home(),
            },
            initialRoute: snapshot.hasData ? '/' : '/login',
          );
        }

        return Material(
          child: Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
      },
    );
  }
}

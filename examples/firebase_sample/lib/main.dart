import 'package:firebase_sample/settings.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:firebase_sample/home.dart';
import 'package:firebase_sample/login.dart';
import 'package:firebase_sample/theme.dart';

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
            child: Text("🤕 Something went wrong"),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MyFirebaseApp();
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

class MyFirebaseApp extends StatefulWidget {
  MyFirebaseApp({
    Key? key,
  }) : super(key: key);

  @override
  _MyFirebaseAppState createState() => _MyFirebaseAppState();
}

class _MyFirebaseAppState extends State<MyFirebaseApp> {
  late final Stream<User?> _userStream;

  @override
  void initState() {
    _userStream = FirebaseAuth.instance.authStateChanges();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _userStream,
      builder: (context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return ChangeNotifierProvider<AppTheme>(
            create: (_) => AppTheme(),
            child: Consumer<AppTheme>(
              builder: (context, AppTheme theme, __) {
                return MaterialApp(
                  themeMode: theme.themeMode,
                  darkTheme: ThemeData.dark(),
                  theme: ThemeData.light(),
                  routes: {
                    '/login': (_) => Login(),
                    '/': (_) => Home(),
                    '/settings': (_) => SettingsView(),
                  },
                  initialRoute: snapshot.hasData ? '/' : '/login',
                );
              },
            ),
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

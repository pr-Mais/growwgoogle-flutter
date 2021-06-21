import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loading = false;
  Future<void> _loginAnon() async {
    setState(() {
      loading = !loading;
    });

    try {
      await FirebaseAuth.instance.signInAnonymously();

      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    } catch (e) {
      //TODO handle errors better
      log('$e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Someething is wrong'),
        ),
      );
      setState(() {
        loading = !loading;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FlutterFire'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Welcome 🔥",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _loginAnon,
                  icon: Icon(Icons.person),
                  label: Text("Login"),
                ),
              ),
            ),
            SizedBox(
              height: 30,
              child: loading ? CircularProgressIndicator.adaptive() : null,
            )
          ],
        ),
      ),
    );
  }
}

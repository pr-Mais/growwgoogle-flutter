import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController controller = TextEditingController();
  List<String> myList = [];
  late final User? currentUser;

  @override
  void initState() {
    super.initState();

    currentUser = FirebaseAuth.instance.currentUser;
    _getMyListFromFirestore();
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();

      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      //TODO handle errors better
    }
  }

  Future<void> _updateMyRecord() async {
    await FirebaseFirestore.instance.collection('user').doc(currentUser?.uid).set(
      {'list': myList},
      SetOptions(mergeFields: ['list']),
    );
  }

  Future<void> _getMyListFromFirestore() async {
    try {
      final snapshot = await FirebaseFirestore.instance.doc('user/${currentUser?.uid}').get();
      final _list = snapshot.data()?['list'] ?? [];

      setState(() {
        myList = _list.cast<String>();
        myList = myList.reversed.toList();
      });
    } catch (e) {
      log('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Welcome to your Home'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(hintText: 'Add items to your list'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      setState(() {
                        myList.add(controller.text);
                      });

                      controller.clear();

                      _updateMyRecord();
                    }
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: myList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(myList[index]),
                  leading: Text('${index + 1}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        myList.remove(myList[index]);
                      });
                      _updateMyRecord();
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 40.0),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _logout,
                icon: Icon(Icons.logout),
                label: Text("Logout"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

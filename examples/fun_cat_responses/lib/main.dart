import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(Home());
}

class Home extends StatefulWidget {
  Home({Key? key, this.client}) : super(key: key);

  final http.Client? client;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController controller = TextEditingController();
  String statusCode = '';

  late CatsAPI cats;

  @override
  void initState() {
    if (widget.client != null) {
      cats = CatsAPI.withClient(widget.client!);
    } else {
      cats = CatsAPI();
    }
    super.initState();
  }

  onSearch() async {
    try {
      final _statusCode = await cats.checkStatusCode(controller.text);

      setState(() {
        statusCode = _statusCode;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Opsie, something is wrong'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('URL StatusCode Detector'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Type a URL...',
                          prefixText: 'https://',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: onSearch,
                      icon: Icon(
                        Icons.search,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 800),
                  child: statusCode.isEmpty
                      ? Container(
                          child: Text('Type a URL to get started'),
                        )
                      : Container(
                          key: ValueKey('cat'),
                          child: Image.network('https://http.cat/$statusCode'),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CatsAPI {
  @visibleForTesting
  CatsAPI.withClient(http.Client client) : _client = client;

  CatsAPI();

  http.Client? _client;

  Future<String> checkStatusCode(String link) async {
    try {
      final url = Uri.parse('https://' + link);
      final res =
          _client != null ? await _client!.post(url) : await http.get(url);
      return res.statusCode.toString();
    } catch (e) {
      log('$e');
      rethrow;
    }
  }
}

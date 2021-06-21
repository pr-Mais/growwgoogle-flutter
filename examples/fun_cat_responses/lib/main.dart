import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController controller = TextEditingController();
  String statusCode = '';

  checkStatusCode() async {
    try {
      final uri = await http.get(Uri.parse('https://' + controller.text));
      setState(() {
        statusCode = uri.statusCode.toString();
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Opsie, something is wrong'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    onPressed: checkStatusCode,
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
                        key: UniqueKey(),
                        child: Image.network('https://http.cat/$statusCode'),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

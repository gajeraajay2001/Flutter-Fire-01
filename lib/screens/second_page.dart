import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  static const routes = "/second_page";
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Page"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Logout Successfully"
                      "..... "),
                ),
              );
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/", (route) => false);
            },
            icon: Icon(Icons.power_settings_new),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

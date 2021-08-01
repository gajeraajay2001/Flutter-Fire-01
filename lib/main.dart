import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire01/screens/authentication_page.dart';
import 'package:flutterfire01/screens/second_page.dart';
import 'screens/home_screen.dart';

initFireBaseApp() async {
  await Firebase.initializeApp();
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => HomeScreen(),
        AuthenticationPage.routes: (context) => AuthenticationPage(),
        SecondPage.routes: (context) => SecondPage(),
      },
    ),
  );
}

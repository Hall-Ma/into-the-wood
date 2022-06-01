import 'package:flutter/material.dart';
import 'package:frontend/splashScreen.dart';
// import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Into The Wood',
      home: SplashScreenImpl(),
      debugShowCheckedModeBanner: false,
    );
  }
}

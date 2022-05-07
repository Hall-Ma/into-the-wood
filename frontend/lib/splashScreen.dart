import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'home.dart';

class SplashScreenImpl extends StatefulWidget {
  const SplashScreenImpl({Key? key}) : super(key: key);

  @override
  State<SplashScreenImpl> createState() => _SplashScreenImplState();
}

class _SplashScreenImplState extends State<SplashScreenImpl> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: Home(),
      title: Text('Into The Wood',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Color.fromARGB(255, 103, 170, 8))),
      image: Image.asset('assets/sampleLogo.jpeg'),
      photoSize: 100.0,
      backgroundColor: Colors.black,
      loaderColor: Color.fromARGB(255, 109, 89, 0),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _picker = ImagePicker();
  XFile? _image;

  takeImage() async {
    var image = await _picker.pickImage(source: ImageSource.camera);

    if (image == null) return null;

    setState(() {
      _image = XFile(image.path);
    });
  }

  pickImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) return null;

    setState(() {
      _image = XFile(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0), // here the desired height
          child: AppBar(
            title: Text('IntoTheWood'),
            backgroundColor: Color(0xFF00E98C),
          )),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/wald.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            // SizedBox(height: 6,),
            // Text(
            //   'Plants',
            //   style: TextStyle(
            //       color: Color(0xFF00E98C),
            //       fontWeight: FontWeight.w500,
            //       fontSize: 28),
            // ),
            SizedBox(height: 5),
            // Center(
            //   child: Container(
            //     width: 300,
            //     child: Column(
            //       children: <Widget>[
            //         Image.asset('assets/sampleLogo.jpeg'),
            //         SizedBox(height: 10)
            //       ],
            //     ),
            //   ),
            // ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: takeImage,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 260,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                      decoration: BoxDecoration(
                          color: Color(0xFF00E98C),
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        'Take a photo',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 260,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                      decoration: BoxDecoration(
                          color: Color(0xFF00E98C),
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        'Camera Roll',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

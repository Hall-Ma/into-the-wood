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
            centerTitle: true,
            title: Text('IntoTheWood'),
            backgroundColor: Color(0xFF255B45),
          )),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/WaldZukunft.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: takeImage,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 260,
                      alignment: Alignment.bottomCenter,
                      padding:
                      EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                      decoration: BoxDecoration(
                          color: Color(0xFF255B45),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        'Take a photo',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 260,
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                      padding:
                      EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                      decoration: BoxDecoration(
                          color: Color(0xFF255B45),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        'Camera Roll',
                        style: TextStyle(color: Colors.white, fontSize: 17),
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

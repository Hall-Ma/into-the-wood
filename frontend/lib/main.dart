import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

void main() => runApp(MaterialApp(
  home: ImageDetectApp(),
));

class ImageDetectApp extends StatefulWidget {
  @override
  _ImageDetectState createState() => _ImageDetectState();
}

class _ImageDetectState extends State<ImageDetectApp> {
  List? _listResult;
  PickedFile? _imageFile;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loading = true;
    _loadModel();
  }

  void _loadModel() async {
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/label.txt",
    ).then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('../assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(
        byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  void _imageSelection() async {
   // File f = await getImageFileFromAssets('oak_example.jpg');

    Image b = Image.file(File("C:\\Users\\Phil\\AndroidStudioProjects\\into-the-wood\\oak_example.jpg")) ;
    //_imageFile.file(new File("oak_example.jpg"));
    //var imageFile =  await imageFile.copy('../oak_example.jpg');
  // var imageFile = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _loading = true;
      _imageFile =b as PickedFile?;
    });
    _imageClassification(_imageFile!);
  }

  void _imageClassification(PickedFile image) async {
    print('in classfication');
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _loading = false;
      _listResult = output;
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: _imageSelection,
            backgroundColor: Colors.blue,
            child: Icon(Icons.add_photo_alternate_outlined)
        )
    );
  }




/*  Widget build(BuildContext context) {
    floatingActionButton: FloatingActionButton(
        onPressed: _imageSelection,
        backgroundColor: Colors.blue,
        child: Icon(Icons.add_photo_alternate_outlined)
);
    throw UnimplementedError();
  }*/
}
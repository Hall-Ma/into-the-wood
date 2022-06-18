import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() => runApp(MaterialApp(
      home: Upload(),
    ));

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  File? _imageFile;
  bool _loading = false;
  var resJson;
  var percentage;

  @override
  void initState() {
    super.initState();
    _loading = true;
  }

  void _imageSelection() async {
    var imageFile = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      _loading = true;
      _imageFile = File(imageFile!.path);
    });

    uploadImageToServer(File(imageFile!.path));
  }

  void _takeImage() async {
    var imageFile = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      _loading = true;
      _imageFile = File(imageFile!.path);
    });

    uploadImageToServer(File(imageFile!.path));
  }

  uploadImageToServer(File imageFile) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse("https://intothewood.herokuapp.com/");
    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));
    request.files.add(multipartFile);

    var res = await request.send();
    http.Response response = await http.Response.fromStream(res);
    setState(() {
      resJson = jsonDecode(response.body);
      percentage = double.parse(resJson["prediction"]["predicted_percentage"]);
    });
    print(resJson.runtimeType);
  }

  String getPredictionText(double percentage) {
    if (resJson != null && percentage < 50) {
      return "Oops, I think you have caught an unknown species but you can try again!";
    } else if (resJson != null && percentage >= 50 && percentage < 80) {
      return "Hmm, I'm not sure but this could be a leaf from a " +
          resJson["prediction"]["predicted tree"] +
          " tree!";
    } else {
      return "Cool, I think you caught a leaf from a " +
          resJson["prediction"]["predicted tree"] +
          " tree!";
    }
  }

  launchWiki(String tree) async {
    var url = 'https://en.wikipedia.org/wiki/' + tree ;

       await launchUrlString(url);

  }

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /*2*/
                _imageFile == null
                    ? Container(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/logo.png',
                            width: 250,
                            height: 250,
                          ),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            width: 8,
                            color: Color(0xFF0C9BA8),
                          ),
                        ),
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _imageFile!,
                            width: 250,
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                resJson != null
                    ? Container(
                        margin: const EdgeInsets.only(top: 12),
                        child: Text(
                          getPredictionText(double.parse(
                              resJson["prediction"]["predicted_percentage"])),
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 17, color: Color(0xFF0A7A81)),
                        ),
                      )
                    : Container(
                        margin: const EdgeInsets.only(top: 12),
                        child: Text(
                          "What's in your net?",
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 17, color: Color(0xFF0A7A81)),
                        ),
                      ),
                resJson != null && percentage >= 50
                    ? Container(
                        child: ElevatedButton(
                          onPressed: () => launchWiki(resJson["prediction"]["predicted tree"]),
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFF0A7A81)),
                          child: const Text('Learn More'),
                        ),
                      )
                    : Container(
                        width: 40,
                        height: 40,
                      ),
              ],
            ),
          ),
          /*3*/
        ],
      ),
    );

    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButtonColumn(Icons.camera, 'TAKE A PHOTO', _takeImage),
          buildButtonColumn(Icons.photo, 'PICK FROM GALLERY', _imageSelection),
        ],
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'IntoTheWood',
      home: Scaffold(
        backgroundColor: Color(0xFFBBEBFF),
        // appBar: PreferredSize(
        //     preferredSize: Size.fromHeight(40.0), // here the desired height
        //     child: AppBar(
        //       centerTitle: true,
        //       title: Text('IntoTheWood'),
        //       backgroundColor: Color(0xFF135644),
        //     )),
        body: ListView(
          children: [
            Image.asset(
              'assets/WaldZukunft.jpg',
              width: 600,
              height: 220,
              fit: BoxFit.cover,
            ),
            titleSection,
            buttonSection,
          ],
        ),
      ),
    );
  }

  buildButtonColumn(icon, label, onTap) {
    Color color = Color(0xFF0A7A81);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          Container(
            margin: const EdgeInsets.only(top: 8.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

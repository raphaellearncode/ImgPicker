import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //global variables:
  File imageFile;
  String finalPath;

  //store string value
  Future<void> storeSharedPrefs(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  //restore string value
  Future<String> restoreSharedPrefs(String key, String inputValue) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(key);

    if (value == null) {
      return null;
    }

    setState(() {
      inputValue = value;
    });

    return inputValue;
  }

  //load saves
  void loadPrefs() async {
    try {
      //restore saved shared prefs:
      finalPath = await restoreSharedPrefs('image', finalPath);

      //load imageFile with restored shared prefs path:
      this.setState(() {
        if (finalPath != null) imageFile = File(finalPath);
      });
      debugPrint('restored path is: $finalPath');
    } catch (e) {
      print('loading error: $e');
    }
  }

  //open device gallery / camera depend from argument input
  _getPhoto(BuildContext context, ImageSource source) async {
    //get Image file:
    File selected = await ImagePicker.pickImage(source: source);
    //store file path:
    storeSharedPrefs('image', selected.path);
    //set selected image
    this.setState(() {
      imageFile = selected;
      print('image path is:  ${selected.path}');
    });
    //close dialog
    Navigator.of(context).pop();
  }

  //create option dialog:
  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: Text(
              'Load picture',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.panorama,
                          color: Colors.grey[200],
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Gallery',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                    onTap: () {
                      _getPhoto(context, ImageSource.gallery);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.camera,
                          color: Colors.grey[200],
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Camera',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                    onTap: () {
                      // _openCamera(context);
                      _getPhoto(context, ImageSource.camera);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    loadPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigo,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Center(
                child: imageFile == null
                    ? Text(
                        'No image selected',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 30,
                            fontStyle: FontStyle.italic),
                      )
                    : Image.file(
                        imageFile,
                        width: 400,
                        height: 400,
                      ),
              ),
              RaisedButton(
                color: Colors.blueAccent,
                onPressed: () {
                  _showChoiceDialog(context);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.picture_in_picture,
                      color: Colors.grey[200],
                      size: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'add image',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

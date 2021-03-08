import 'package:flutter/material.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

void floresPage() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(),
    home: Flores(),
  ));
}

class Flores extends StatefulWidget {
  @override
  _FloresState createState() => _FloresState();
}

class _FloresState extends State<Flores> {
  bool _isLoading;
  File _image;
  List _output;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    loadMLModel().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reconocimiento de Flores"),
      ),
      body: _isLoading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _image == null ? Container() : Image.file(_image),
                  SizedBox(
                    height: 16,
                  ),
                  _output == null ? Text("") : Text("${_output[0]["label"]}")
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          escogerImagen();
        },
        child: Icon(Icons.image),
      ),
    );
  }

  escogerImagen() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _isLoading = true;
      _image = image;
    });
    correrModelo(image);
  }

  correrModelo(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.5);
    setState(() {
      _isLoading = false;
      _output = output;
    });
  }

  loadMLModel() async {
    await Tflite.loadModel(
        model: "assets/images/model_unquant.tflite",
        labels: "assets/images/labels.txt");
  }
}

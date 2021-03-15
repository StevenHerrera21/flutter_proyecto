import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_proyecto/providers/resultado_provider.dart';
import 'dart:io';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Flores extends StatefulWidget {
  @override
  _FloresState createState() => _FloresState();
}

class _FloresState extends State<Flores> {
  bool _isLoading;
  File _image;
  List _output;
  String email;
  ResultadoProvider _resultadoProvider = new ResultadoProvider();

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    loadMLModel().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        this.email = user.email;
      }
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
                children: <Widget>[
                  _buttons(context),
                  _image == null
                      ? Container()
                      : Image.file(
                          _image,
                          height: 300,
                          width: 500,
                          fit: BoxFit.fitHeight,
                        ),
                  SizedBox(
                    height: 16,
                  ),
                  _output == null || _output.isEmpty
                      ? Text("Flor no identificada")
                      : Text('Nombre: ' +
                          (_output[0]["label"]).toString() +
                          ' \nConfiabilidad: ' +
                          (_output[0]['confidence']).toString())
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

  Widget _buttons(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          RaisedButton(
            color: Colors.green[300],
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('Agregar resultado'),
            ),
            onPressed: () {
              _agregarInfo();
            },
          ),
          RaisedButton(
            color: Colors.yellow[300],
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('Ver resultados'),
            ),
            onPressed: () {
              Navigator.pushNamed(context, 'results');
            },
          ),
        ],
      ),
    );
  }

  void _agregarInfo() async {
    if (_image == null) {
      print('No se puede agregar');
    } else {
      String ruta = await _resultadoProvider.subirImagen(_image);
      CollectionReference resultados = FirebaseFirestore.instance
          .collection('Usuarios')
          .doc(email)
          .collection('results');
      resultados.add({
        'imagen': ruta,
        'nombre': _output[0]['label'],
      }).then((value) {
        print('userAdd');
        setState(() {
          _image = null;
          _output = null;
        });
      }).catchError((error) => print("Failed to add user: $error"));
    }
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

  /*void _signOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, 'loginPage');
  }*/
}

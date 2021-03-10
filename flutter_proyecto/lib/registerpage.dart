import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterPage extends StatefulWidget {
  final String title = 'Registro';

  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passswordController = TextEditingController();
  bool _success;
  String _userEmail;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.number,
              maxLength: 10,
              controller: _cedulaController,
              decoration: InputDecoration(
                labelText: 'Cédula',
              ),
              validator: (value) {
                if (value.isEmpty || value.length <= 9) {
                  return 'Ingrese su cédula';
                }
              },
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: _nombresController,
              decoration: InputDecoration(
                labelText: 'Nombres',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Ingrese sus nombres';
                }
              },
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: _apellidosController,
              decoration: InputDecoration(
                labelText: 'Apellidos',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Ingrese sus apellidos';
                }
              },
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              validator: (value) {
                bool emailValid =
                    RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                        .hasMatch(value);
                if (emailValid == false) {
                  return 'Ingrese un correo valido';
                }
              },
            ),
            TextFormField(
              controller: _passswordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Ingrese Contraseña';
                }
              },
            ),
            FlatButton(
                child: Text('Registrarse'),
                color: Colors.deepPurple,
                textColor: Colors.white,
                onPressed: () {
                  _register();
                }),
            Container(
              alignment: Alignment.center,
              child: Text(_success == null
                  ? ''
                  : (_success
                      ? '¡Registro Exitoso!' + _userEmail
                      : 'Registro fallido')),
            )
          ],
        ),
      ),
    );
  }

  void dispose() {
    _cedulaController.dispose();
    _nombresController.dispose();
    _apellidosController.dispose();
    _emailController.dispose();
    _passswordController.dispose();
    super.dispose();
  }

  void _register() async {/*
    if (_formKey.currentState.validate()) {
      final UserCredential user = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passswordController.text,
      );
      FirebaseFirestore.instance
          .collection("Usuarios")
          .document(_emailController.text)
          .setData({
        "Cedula": _cedulaController.text,
        "Nombres": _nombresController.text,
        "Apellidos": _apellidosController.text,
        "Email": _emailController.text,
      });
      setState(() {
        _success = true;
        _userEmail = user.email;
        _cedulaController.clear();
        _nombresController.clear();
        _apellidosController.clear();
        _emailController.clear();
        _passswordController.clear();
      });
    } else {
      _success = false;
    }*/
  }
}

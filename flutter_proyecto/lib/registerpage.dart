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
    double alto = MediaQuery.of(context).size.height;
    return Scaffold(
      //resizeToAvoidBottomPadding: false, //evitar error bottom overflowed
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                Container(
                  //En caso de conseguir una imagen png utilizar este codigo
                  /*child: Center(
                    child: Image(
                      image: AssetImage('assets/images/icono-login.png'),
                      height: 90.0,
                    ),
                  ),*/
                  color: Colors.blue[700],
                  width: double.infinity,
                  height: alto * 0.40,
                ),
                /*Container(
                  height: alto*0.70,
                  color: Colors.white,
                ),*/
              ],
            ),
          ),
          Container(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _formulario(),
                    _botones(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _formulario() {
    return Form(
      key: _formKey,
      child: Container(
        //padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 25.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Informacion de la cuenta',
                style: TextStyle(fontSize: 25.0),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  color: Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 25.0,
                      spreadRadius: 7.0,
                      offset: Offset(3.0, 20),
                    )
                  ]),
              child: Column(
                children: [_email(), _pass()],
              ),
            ),
            SizedBox(
              height: 65.0,
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Informacion personal',
                style: TextStyle(fontSize: 25.0),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  color: Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 25.0,
                      spreadRadius: 7.0,
                      offset: Offset(3.0, 20),
                    )
                  ]),
              child: Column(
                children: [
                  _cedula(),
                  _nombres(),
                  _apellidos(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _email() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: TextFormField(
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
    );
  }

  Widget _pass() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: TextFormField(
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
    );
  }

  Widget _cedula() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: TextFormField(
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
    );
  }

  Widget _nombres() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: TextFormField(
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
    );
  }

  Widget _apellidos() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: TextFormField(
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
    );
  }

  Widget _botones() {
    return Container(
      child: Column(
        children: [
          FlatButton(
              child: Text('Registrarse'),
              color: Colors.red,
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
          ),
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              child: Text(
                '¿Ya tienes cuenta? Inicia Sesion',
                style: TextStyle(
                  color: Colors.grey,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 25.0,
          )
        ],
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

  void _register() async {
    if (_formKey.currentState.validate()) {
      final UserCredential user = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passswordController.text,
      );
      FirebaseFirestore.instance
          .collection("Usuarios")
          .doc(_emailController.text)
          .set({
        "Cedula": _cedulaController.text,
        "Nombres": _nombresController.text,
        "Apellidos": _apellidosController.text,
        "Email": _emailController.text,
      });
      setState(() {
        _success = true;
        _userEmail = "";
        _cedulaController.clear();
        _nombresController.clear();
        _apellidosController.clear();
        _emailController.clear();
        _passswordController.clear();
      });
    } else {
      _success = false;
    }
  }
}

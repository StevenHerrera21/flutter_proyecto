import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterPage extends StatefulWidget {
  final String title = 'Registration';

  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
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
                      ? 'Successfully registered' + _userEmail
                      : 'Registration failed')),
            )
          ],
        ),
      ),
    );
  }

  void dispose() {
    _emailController.dispose();
    _passswordController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState.validate()) {
      final FirebaseUser user = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passswordController.text,
      );
      setState(() {
        _success = true;
        _userEmail = user.email;
      });
    } else {
      _success = false;
    }
  }
}

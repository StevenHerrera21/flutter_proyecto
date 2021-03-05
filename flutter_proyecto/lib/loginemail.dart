import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_proyecto/googlepage.dart';
import 'package:flutter_proyecto/page.dart';
import 'package:flutter_proyecto/registerpage.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth',
      home: LoginPage(title: 'Firebase Auth'),
    );
  }
}

class LoginPage extends StatefulWidget {
  final String title;

  LoginPage({Key key, this.title}) : super(key: key);

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false, //evitar error bottom overflowed
      body: Form(
        key: _formKey,
        //autovalidate: _autovalidate,
        child: Container(
          //padding: EdgeInsets.all(15.0),
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage('assets/images/login2.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                child: new Card(
                  color: Colors.grey[100],
                  margin: new EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 250.0, bottom: 80.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  elevation: 8.0,
                  child: new Padding(
                    padding: new EdgeInsets.all(25.0),
                    child: new Column(
                      children: <Widget>[
                        new Container(
                          child: new TextFormField(
                            maxLines: 1,
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            textInputAction: TextInputAction.next,
                            decoration: new InputDecoration(
                                labelText: 'Email', icon: Icon(Icons.email)),
                            validator: (value) {
                              bool emailValid = RegExp(
                                      r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                  .hasMatch(value);
                              if (emailValid == false) {
                                return 'Ingrese un correo valido';
                              }
                            },
                          ),
                        ),
                        new Container(
                          child: new TextFormField(
                            maxLines: 1,
                            controller: _passwordController,
                            obscureText: true,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            decoration: new InputDecoration(
                              labelText: 'Password',
                              icon: Icon(
                                Icons.vpn_key,
                                color: Colors.black,
                              ),
                            ),
                            onFieldSubmitted: (value) {
                              //FocusScope.of(context).requestFocus(_phoneFocusNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Ingrese la contraseña';
                              }
                            },
                          ),
                        ),
                        new Padding(padding: new EdgeInsets.only(top: 30.0)),
                        new RaisedButton(
                          color: Colors.blue,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          padding: new EdgeInsets.all(16.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text(
                                'Login',
                                style: new TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          onPressed: () {
                            signInWithEmail();
                          },
                        ),
                        Divider(),
                        new RaisedButton(
                          color: Colors.blue,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          padding: new EdgeInsets.all(16.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Text(
                                'Google Sign In',
                                style: new TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          onPressed: () => _pushPage(context, SignInDemo()),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 6,
                              right: 32,
                            ),
                            child: InkWell(
                              onTap: () => _pushPage(context, RegisterPage()),
                              child: Container(
                                child: Text(
                                  'No tienes cuenta? Registrate!',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signInWithEmail() async {
    // marked async

    FirebaseUser user;
    try {
      if (_formKey.currentState.validate()) {
        user = await _auth.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      if (user != null) {
        _emailController.clear();
        _passwordController.clear();
        // sign in successful!
        _pushPage(context, Pintar());
      } else {
        // sign in unsuccessful
        print('sign in Not');
        // ex: prompt the user to try again
      }
    }
  }
}

void _pushPage(BuildContext context, Widget page) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => page),
  );
}

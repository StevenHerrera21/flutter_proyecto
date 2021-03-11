import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

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
                  child: Icon(
                    Icons.lock_rounded,
                    color: Colors.white,
                    size: 110.0,
                  ),
                  //En caso de conseguir una imagen png utilizar este codigo
                  /*child: Center(
                    child: Image(
                      image: AssetImage('assets/images/icono-login.png'),
                      height: 90.0,
                    ),
                  ),*/
                  color: Colors.blue[700],
                  width: double.infinity,
                  height: alto*0.35,
                ),
                /*Container(
                  height: alto*0.70,
                  color: Colors.white,
                ),*/
              ],
            ),
          ),
          Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: alto*0.25,),
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(17.0),
                        color: Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black45,
                            blurRadius: 25.0,
                            spreadRadius: 7.0,
                            offset: Offset(3.0, 20),
                          )
                        ]
                      ),
                      margin: EdgeInsets.all(25.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 30.0),
                            child: Text('Login', style: TextStyle(fontSize: 35.0),),
                          ),
                          _correo(),
                          SizedBox(height: 10.0),
                          _pass(),
                          SizedBox(height: 20.0,)
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: _botones(),
                    margin: EdgeInsets.symmetric(horizontal: 75.0),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _correo(){
    return TextFormField(
      maxLines: 1,
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          labelText: 'Email', icon: Icon(Icons.email)),
      validator: (value) {
        bool emailValid = RegExp(
                r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
            .hasMatch(value);
        if (emailValid == false) {
          return 'Ingrese un correo valido';
        }
      },
    );
  }

  Widget _pass(){
    return TextFormField(
      maxLines: 1,
      controller: _passwordController,
      obscureText: true,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
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
    );
  }

  Widget _botones(){
    return Container(
      child: Column(
        children: [
          RaisedButton(
            color: Colors.red,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
               Text(
                  'Iniciar Sesión',
                  style: TextStyle(
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
          SizedBox(height: 15.0),
          RaisedButton(
            color: Colors.red,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
               Text(
                  'Ingresa con Google',
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ],
            ),
            onPressed: () => Navigator.pushNamed(context, 'sign'),
          ),
          SizedBox(height: 15.0),
          InkWell(
            onTap: () => Navigator.pushNamed(context, 'register'),
            child: Container(
              child: Text(
                '¿No tienes cuenta? Registrate',
                style: TextStyle(
                  color: Colors.grey,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          SizedBox(height: 15.0),
        ],
      ),
    );
  }

  void signInWithEmail() async {
    // marked async

    UserCredential user;
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
        Navigator.pushNamed(context, 'flores');
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

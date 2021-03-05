import 'package:flutter/material.dart';

class Pintar extends StatefulWidget {
  @override
  _PintarState createState() => _PintarState();
}

class _PintarState extends State<Pintar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login oKi'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Text('Hello GOT'),
          ),
        ],
      ),
    );
  }
  /*
    void _signOut() {
    FirebaseAuth.instance.signOut();
    //print('$user');
    _pushPage(context, LoginPage());
  }

  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
  */
}

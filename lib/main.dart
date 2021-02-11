import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stable/home_widget.dart';
import 'package:stable/authentication/login.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home_Page(), //Nav()
    );
  }
}

class Home_Page extends StatefulWidget {
  Home_Page({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _Home_PageState createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  @override
  Widget build(BuildContext context) {
    checkUserActiveLogin().then((isLogin) {
      if (isLogin == true) {
        print('Already login');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
            (route) => false);
      } else {
        print('Not login');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false);
      }
    });
    return new Scaffold(
      body: Card(
        child: Center(
          child: Text(
            'Loading......',
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.indigo),
          ),
        ),
      ),
    );
  }
}

checkUserActiveLogin() async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  return _auth
      .currentUser()
      .then((user) => user != null ? true : false)
      .catchError((onError) => false);
}

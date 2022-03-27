import 'dart:async';
import 'package:chat/Utils/DataBaseHelper.dart';
import 'package:flutter/material.dart';
import '../GeneratedRoutes.dart';

class Splashcreen extends StatefulWidget {
  @override
  _SplashcreenState createState() => _SplashcreenState();
}

class _SplashcreenState extends State<Splashcreen> {
  DataBaseHelper helper = DataBaseHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => helper.getUser().then((value) {
              if (value.length == 0) {
                Navigator.pushNamed(context, GeneratedRoutes.signIn);
              } else {
                Navigator.pushNamed(context, GeneratedRoutes.home);
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircleAvatar(
            child: Image(
              image: AssetImage("image/messengerlogo.png"),
            ),
            radius: 80,
          ),
        ));
  }
}

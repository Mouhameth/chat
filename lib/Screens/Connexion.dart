import 'package:chat/GeneratedRoutes.dart';
import 'package:chat/Providers/LoginProviders.dart';
import 'package:chat/widgets/ConnexionButton.dart';
import 'package:chat/widgets/ConnexionWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginProviders(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Messenger",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ConnexionWidget(),
              ConnexionButton(),
              GestureDetector(
                  onTap: () async {
                    Navigator.pushNamed(context, GeneratedRoutes.loginScreen);
                  },
                  child: Center(
                      child: Container(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 20, bottom: 20),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(fontSize: 10, color: Colors.blue),
                          ))))
            ],
          ),
        ),
      ),
    );
  }
}

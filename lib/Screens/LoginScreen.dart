import 'package:chat/Providers/LoginProviders.dart';
import 'package:chat/widgets/FormWidget.dart';
import 'package:chat/widgets/ImagePickerWidget.dart';
import 'package:chat/widgets/LoginButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
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
            children: [
              ImagePIckerWiget(),
              FormWidget(),
              LoginButton()
            ],
          ),
        ),
      ),
    );
  }
}

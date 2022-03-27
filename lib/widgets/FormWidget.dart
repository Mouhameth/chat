import 'package:chat/Providers/LoginProviders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/TextFormFIeldWidget.dart';

class FormWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String _controller;
    return Consumer<LoginProviders>(
      builder: (_, model, __) {
        return Form(
          key: model.keyForm,
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            child: Column(
              children: [
                TextFormFieldWidget(
                    "firstName",
                    Icon(
                      Icons.person,
                      color: Colors.blue,
                    ),
                    model.fnamecontrol,false,(value) {
                  if (value != "")
                    return null;
                  else
                    return "name not good!";
                }),
                TextFormFieldWidget(
                    "lastName",
                    Icon(Icons.person, color: Colors.blue),
                    model.lnamecontrol,false,(value) {
                  if (value != "")
                    return null;
                  else
                    return "name not good!";
                }),
                TextFormFieldWidget(
                    "email",
                    Icon(Icons.email_outlined, color: Colors.blue),
                    model.emailcontrol,false,(value) {
                  if (value.contains("@"))
                    return null;
                  else
                    return "Email not good!";
                }),
                TextFormFieldWidget(
                    "password",
                    Icon(Icons.lock, color: Colors.blue),
                    model.passcontrol,true,(value) {
                  if (value == "" || value.length < 6)
                    return "password must be at least 6 caracters!";
                  else {
                    _controller = value;
                    return null;
                  }
                }),
                TextFormFieldWidget(
                    "confirm password",
                    Icon(Icons.lock, color: Colors.blue),
                    model.cpasscontrol,true,(value) {
                  if (_controller != value)
                    return "passwords are not the same!";
                  else
                    return null;
                })
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:chat/Providers/LoginProviders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'TextFormFIeldWidget.dart';

class ConnexionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProviders>(
      builder: (_, model, __) {
        return Form(
          key: model.keyForm,
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            child: Column(
              children: [
                TextFormFieldWidget(
                    "email",
                    Icon(
                      Icons.mail,
                      color: Colors.blue,
                    ),
                    model.emailcontrol,false,(value) {
                  if (value != "")
                    return null;
                  else
                    return "email not good!";
                }),
                TextFormFieldWidget(
                    "password",
                    Icon(Icons.lock, color: Colors.blue),
                    model.passcontrol,true,(value) {
                  if (value != "")
                    return null;
                  else
                    return "password not good!";
                }),
                
              ],
            ),
          ),
        );
      },
    );
  }
}
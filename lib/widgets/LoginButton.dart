import 'dart:async';
import 'dart:io';
import 'package:chat/GeneratedRoutes.dart';
import 'package:chat/Networking/Networking.dart';
import 'package:chat/Providers/LoginProviders.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class LoginButton extends StatefulWidget {
  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Animation button;
  FToast fToast;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    button = new Tween(begin: 320.0, end: 70.0).animate(new CurvedAnimation(
        parent: animationController, curve: new Interval(0.0, 0.250)));
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    print(animationController.value);
    return Consumer<LoginProviders>(
      builder: (_, model, __) {
        return AnimatedBuilder(
          animation: animationController,
          builder: (context, widget) {
            return GestureDetector(
              onTap: () async {
                animationController.forward();
                if (model.keyForm.currentState.validate()) {
                  int result = await Networking.inscription(
                      model.emailcontrol.text, model.passcontrol.text);
                  if (result == 1) {
                    
                    int ok = await Networking.saveProfileAndData(
                        File(model.file.path),
                        model.fnamecontrol.text,
                        model.lnamecontrol.text,
                        model.emailcontrol.text,model.passcontrol.text);

                    if (ok == 1) {
                      _showToast();
                      Timer(
                          Duration(seconds: 2),
                          () => Navigator.pushNamed(
                              context, GeneratedRoutes.home));
                    } else
                      _showError("check your network");
                  } else if (result == -1)
                    _showError("email already in use");
                  else {
                    _showError("check your connexion");
                  }
                }
                animationController.reverse();
              },
              child: Container(
                width: button.value,
                height: 50,
                alignment: FractionalOffset.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.blue),
                child: button.value > 70
                    ? Text(
                        "Sign up",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )
                    : Center(
                        child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      )),
              ),
            );
          },
        );
      },
    );
  }

  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("inscritption réussie!"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );

    // Custom Toast Position
    fToast.showToast(
        child: toast,
        toastDuration: Duration(seconds: 2),
        positionedToastBuilder: (context, child) {
          return Positioned(
            child: child,
            top: 16.0,
            left: 16.0,
          );
        });
  }

  _showError(String txt) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error),
          SizedBox(
            width: 12.0,
          ),
          Text(txt),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }
}

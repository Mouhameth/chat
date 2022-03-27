import 'package:chat/Networking/Networking.dart';
import 'package:chat/Providers/LoginProviders.dart';
import 'package:chat/Utils/DataBaseHelper.dart';
import 'package:chat/models/Contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../GeneratedRoutes.dart';

class ConnexionButton extends StatefulWidget {
  @override
  _ConnexionButtonState createState() => _ConnexionButtonState();
}

class _ConnexionButtonState extends State<ConnexionButton>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Animation button;
  FToast fToast;
  DataBaseHelper helper = DataBaseHelper();
  
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
    return Consumer<LoginProviders>(
      builder: (_, model, __) {
        return AnimatedBuilder(
          animation: animationController,
          builder: (context, widget) {
            return GestureDetector(
              onTap: () async {
                animationController.forward();
                if (model.keyForm.currentState.validate()) {
                  int result = await Networking.connexion(
                      model.emailcontrol.text.toString(),
                      model.passcontrol.text.toString());
                  if (result == 1) {
                    
                    String url,userName;
                       FirebaseFirestore.instance
                          .collection('users')
                          .doc(model.emailcontrol.text.toString())
                          .get()
                          .then((DocumentSnapshot documentSnapshot) {
                            if (documentSnapshot.exists) {
                              url = documentSnapshot["urlImage"];
                              userName = documentSnapshot["userName"];
                            }
                          });
                            Contact contact =Contact(model.emailcontrol.text.toString(),
                                                     "false",userName);
                            helper.insertUser(contact);
                            Navigator.pushNamed(context, GeneratedRoutes.home);

                  } else if (result == -1)
                    _showToast("user-not-found!");
                  else if (result == 0)
                    _showToast("wrong-password!"); 
                  else
                    _showToast("check your connexion!");
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
                        "Sign In",
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

  _showToast(String txt) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline),
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

import 'package:chat/GeneratedRoutes.dart';
import 'package:chat/Networking/Networking.dart';
import 'package:flutter/material.dart';

class Quit extends StatelessWidget {
  List<String> list;
  Quit(this.list);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: GestureDetector(
          onTap: () async {
            final int i = await Networking.quitterGroupe(list[0], list[1]);
            if (i == 1) {
              for (int j = 2; j < list.length; j++) {
                final int k = await Networking.quitterOtherGroupe(
                    list[j], list[0], list[1]);
                if (k == 1) {
                  
                  Navigator.pushNamed(context, GeneratedRoutes.home);
                }
              }
            }
          },
          child: Center(
              child: Container(
                  width: 100,
                  height: 50,
                  alignment: FractionalOffset.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Colors.blue),
                  child: Text(
                    "Quitter",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )))),
    ));
  }
}

import 'dart:io';

import 'package:chat/Networking/Networking.dart';
import 'package:chat/Providers/LoginProviders.dart';
import 'package:chat/Utils/DataBaseHelper.dart';
import 'package:chat/models/Contact.dart';
import 'package:chat/models/Groupe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomSheetGroup extends StatefulWidget {
  String nom;
  BottomSheetGroup(this.nom);
  @override
  _BottomSheetGroupState createState() => _BottomSheetGroupState();
}

class _BottomSheetGroupState extends State<BottomSheetGroup> {
  TextEditingController _messageController = TextEditingController();
  DataBaseHelper helper = DataBaseHelper();
  bool isImage = false;
  List<Groupe> allg = [];
  @override
  Widget build(BuildContext context) {
    print(widget.nom);
    return FutureBuilder<List<Contact>>(
      future: DataBaseHelper().getUser(),
      builder: (context, snapashot) {
        if (snapashot.hasData) {
          return Consumer<LoginProviders>(
              builder: (context, model, _) => Container(
                  height: 80,
                  width: double.infinity,
                  decoration:
                      BoxDecoration(color: Colors.white.withOpacity(0.4)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15.0,
                      right: 15.0,
                      bottom: 25.0,
                    ),
                    child: Row(children: [
                      Expanded(
                        child: FutureBuilder<List<Contact>>(
                            future: DataBaseHelper().getUser(),
                            builder: (context, asyncsnapshot) {
                              if (asyncsnapshot.hasError)
                                return Text("Aucun message");
                              else if (asyncsnapshot.connectionState ==
                                  ConnectionState.waiting)
                                return Center(
                                    child: CircularProgressIndicator());
                              else
                                return StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(asyncsnapshot.data[0].email)
                                        .collection("groupes")
                                        .doc(widget.nom)
                                        .collection("member")
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        List<Groupe> allgroup = [];
                                        for (var doc
                                            in snapshot.data.docChanges) {
                                          allgroup.add(Groupe.fromMembers(
                                              doc.doc.data()));
                                        }
                                        allg = allgroup;
                                      }
                                      return Text("");
                                    });
                            }),
                      ),
                      Container(
                        width: (MediaQuery.of(context).size.width - 30) / 2,
                        child: Row(children: [
                          GestureDetector(
                            child: Icon(
                              Icons.add_circle,
                              color: Colors.blue,
                              size: 30,
                            ),
                            onTap: () {},
                          ),
                          SizedBox(width: 15.0),
                          GestureDetector(
                              child: Icon(
                                Icons.camera_alt_sharp,
                                color: Colors.blue,
                                size: 30,
                              ),
                              onTap: () {}),
                          SizedBox(width: 10.0),
                          GestureDetector(
                              child: Icon(
                                Icons.photo,
                                color: Colors.blue,
                                size: 30,
                              ),
                              onTap: () {
                                model.send = 1;
                                model.getNewImage();
                                isImage = true;
                              }),
                          SizedBox(width: 5.0),
                          GestureDetector(
                              child: Icon(
                                Icons.keyboard_voice,
                                color: Colors.blue,
                                size: 30,
                              ),
                              onTap: () {}),
                        ]),
                      ),
                      Container(
                        width: (MediaQuery.of(context).size.width - 30) / 2,
                        child: Row(children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(20)),
                            width:
                                (MediaQuery.of(context).size.width - 140) / 2,
                            height: 40,
                            child: Padding(
                                padding: const EdgeInsets.only(left: 15.0),
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Aa",
                                      suffixIcon: Icon(
                                        Icons.face,
                                        color: Colors.blue,
                                        size: 30,
                                      )),
                                  cursorColor: Colors.black,
                                  controller: _messageController,
                                  onTap: () {
                                    model.send = 1;
                                    model.chnageState();
                                    model.messages = [];
                                  },
                                )),
                          ),
                          SizedBox(width: 5.0),
                          GestureDetector(
                            child: model.send == 0
                                ? Icon(
                                    Icons.thumb_up,
                                    color: Colors.blue,
                                    size: 30,
                                  )
                                : Icon(
                                    Icons.send,
                                    color: Colors.blue,
                                    size: 30,
                                  ),
                            onTap: () async {
                              if (model.send == 1 &&
                                  _messageController.text != "" &&
                                  isImage == false) {
                                int insert = 0;
                                for (int i = 0; i < allg.length; i++) {
                                  final int j =
                                      await Networking.envoyerMessageGroupe(
                                          allg[i].emailMember,
                                          allg[i].nomMemeber,
                                          widget.nom,
                                          _messageController.text,
                                          false,
                                          null);
                                  if (j == 1) insert++;
                                }
                                if (insert == allg.length) {
                                  model.send = 0;
                                  _messageController.clear();
                                  model.chnageState();
                                  model.message = [];
                                  print(allg.length);
                                }
                              } else if (model.send == 1 && isImage == true) {
                                int ins = 0;
                                for (int i = 0; i < allg.length; i++) {
                                  final int j =
                                      await Networking.envoyerMessageGroupe(
                                          allg[i].emailMember,
                                          allg[i].nomMemeber,
                                          widget.nom,
                                          model.file.path,
                                          true,
                                          File(model.file.path));
                                  if (j == 1) ins++;
                                }
                                if (ins == allg.length) {
                                  model.send = 0;
                                  _messageController.clear();
                                  model.chnageState();
                                  model.message = [];
                                }
                              }
                            },
                          )
                        ]),
                      )
                    ]),
                  )));
        } else {
          return Container(
            child: Center(
              child: Text(""),
            ),
          );
        }
      },
    );
  }
}

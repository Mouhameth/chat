import 'dart:io';
import 'package:chat/Networking/Networking.dart';
import 'package:chat/Providers/LoginProviders.dart';
import 'package:chat/Utils/DataBaseHelper.dart';
import 'package:chat/models/Contact.dart';
import 'package:chat/widgets/CircularImageUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../GeneratedRoutes.dart';

class AppBarMessenger extends StatefulWidget {
  @override
  _AppBarMessengerState createState() => _AppBarMessengerState();
}

class _AppBarMessengerState extends State<AppBarMessenger> {
  String email;
  final double radius = 50;
  String url;
  String nom;
  List<String> nomUrl=[];
  Contact con;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      
      child: SafeArea(
        child: Consumer<LoginProviders>(builder: (context, model, _) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FutureBuilder<List<Contact>>(
                future: DataBaseHelper().getUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    email = snapshot.data[0].email;
                    return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .snapshots(),
                        builder: (context, asyncsnapshot) {
                          if (asyncsnapshot.hasData) {
                            if (model.file != null) {
                              print(model.file.path);
                              Networking.updateImage(
                                  email, File(model.file.path));
                              model.file = null;
                            }
                            for (var doc in asyncsnapshot.data.docChanges) {
                              Contact contact =
                                  Contact.fromJson(doc.doc.data());
                              if (contact.email == email)
                                {url = contact.urlImage;
                                nom = contact.userName;
                                nomUrl.add(nom);
                                nomUrl.add(url);
                                con = contact;
                                }
                            }
                            if (url != null) {
                              return GestureDetector(
                                child: CircularImageUser(
                                    urlImage: url, radius: 50),
                                onTap: () {
                                  model.getNewImage();
                                  model.changeIntent(model.index);
                                },
                              );
                            } else {
                              return GestureDetector(
                                child: CircleAvatar(
                                    radius: 30,
                                    child: Icon(
                                      Icons.person_sharp,
                                      size: 30,
                                    )),
                                onTap: () async {
                                  model.getNewImage();
                                },
                              );
                            }
                          } else {
                            return GestureDetector(
                              child: CircleAvatar(
                                  radius: 30,
                                  child: Icon(
                                    Icons.image_search_outlined,
                                    size: 30,
                                  )),
                              onTap: () async {
                                model.getNewImage();
                              },
                            );
                          }
                        });
                  } else {
                    return GestureDetector(
                      child: CircleAvatar(
                          radius: 30,
                          child: Icon(
                            Icons.image_search_outlined,
                            size: 30,
                          )),
                      onTap: () async {
                        model.getNewImage();
                      },
                    );
                  }
                }),
            Text(
              "Messenger",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                fontStyle: FontStyle.italic,
              ),
            ),
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.pushNamed(context, GeneratedRoutes.groupe,arguments: nomUrl);
                })
          ],
        ),
      );
    })),
    onTap: (){
        Navigator.pushNamed(context, GeneratedRoutes.profile,arguments:con );
      });
  }
}

import 'package:chat/Providers/LoginProviders.dart';
import 'package:chat/Utils/DataBaseHelper.dart';
import 'package:chat/models/Contact.dart';
import 'package:chat/widgets/ListViewAllContact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../GeneratedRoutes.dart';

class GroupCreate extends StatefulWidget {
  @override
  _GroupCreateState createState() => _GroupCreateState();
}

class _GroupCreateState extends State<GroupCreate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                    padding:
                        const EdgeInsets.only(top: 60.0, left: 8.0, right: 8.0),
                    child: Row(children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, GeneratedRoutes.home);
                        },
                        child: Text(
                          "Annuler",
                          style:
                              TextStyle(color: Colors.blueAccent, fontSize: 18),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Text("Nouveau message",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold)))
                    ])),
                SizedBox(
                  height: 10,
                ),
                ChangeNotifierProvider(
                    create: (context) => LoginProviders(),
                    child: Consumer<LoginProviders>(
                      builder: (context, model, _) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              width: double.infinity,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(5)),
                              child: TextFormField(
                                cursorColor: Colors.black.withOpacity(0.2),
                                decoration: InputDecoration(
                                    hintText: "  A : ",
                                    border: InputBorder.none),
                                onChanged: (value) {
                                  return model.search(value);
                                },
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, GeneratedRoutes.create);
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.people_rounded),
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Text(
                                          "Créer un nouveau groupe",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ))
                                  ],
                                )),
                            SizedBox(
                              height: 30,
                            ),
                            Padding(
                                padding: const EdgeInsets.only(right: 274.0),
                                child: Container(
                                    child: Text("SUGGESTIONS",
                                        style: TextStyle(color: Colors.grey)))),
                          ],
                        );
                      },
                    )),
                Expanded(
                    child: FutureBuilder<List<Contact>>(
                        future: DataBaseHelper().getUser(),
                        builder: (context, asyncsnapshot) {
                          if (asyncsnapshot.hasError)
                            return Text("Some error");
                          else if (asyncsnapshot.connectionState ==
                              ConnectionState.waiting)
                            return Center(child: CircularProgressIndicator());
                          else
                            return StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection("users")
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text("Some error");
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting)
                                    return Center(
                                        child: CircularProgressIndicator());
                                  else if (snapshot.hasData) {
                                    List<Contact> allContact = [];
                                    for (var doc in snapshot.data.docChanges) {
                                      if (Contact.fromJson(doc.doc.data())
                                              .email !=
                                          asyncsnapshot.data[0].email)
                                        allContact.add(
                                            Contact.fromJson(doc.doc.data()));
                                    }
                                    return ListViewAllContact(allContact, asyncsnapshot.data[0].optionVu);
                                  } else
                                    return Center(
                                        child: Icon(
                                      Icons.wifi_off_rounded,
                                      color: Colors.pinkAccent,
                                    ));
                                });
                        })
                    // voir definition
                    )
              ],
            )));
  }
}

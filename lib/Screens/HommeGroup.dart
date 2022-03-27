import 'package:chat/Providers/LoginProviders.dart';
import 'package:chat/Utils/DataBaseHelper.dart';
import 'package:chat/models/Contact.dart';
import 'package:chat/models/Groupe.dart';
import 'package:chat/models/messageGp.dart';
import 'package:chat/widgets/AppBarGroupe.dart';
import 'package:chat/widgets/BottomSheetGroup.dart';
import 'package:chat/widgets/ListViewMessageGroup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HommeGroupe extends StatefulWidget {
  Groupe groupe;
  HommeGroupe(this.groupe);
  @override
  _HommeGroupeState createState() => _HommeGroupeState();
}

class _HommeGroupeState extends State<HommeGroupe> {
  List<MessageGp> messages = [];
  String email;
  String nom;
  
  @override
  Widget build(BuildContext context) {
    
    return ChangeNotifierProvider(
        create: (context) => LoginProviders(),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                AppBarGroupe(widget.groupe),
                SizedBox(
                  height: 10,
                ),
                Consumer<LoginProviders>(
                    builder: (context, model, _) => Expanded(
                            child: model.file == null
                                ? FutureBuilder<List<Contact>>(
                                    future: DataBaseHelper().getUser(),
                                    builder: (context, asyncsnapshot) {
                                      if (asyncsnapshot.hasError)
                                        return Text("Some error");
                                      else if (asyncsnapshot.connectionState ==
                                          ConnectionState.waiting)
                                        return Center(
                                            child: CircularProgressIndicator());
                                      else {
                                        email = asyncsnapshot.data[0].email;
                                        nom = asyncsnapshot.data[0].userName;
                                        return StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(
                                                    asyncsnapshot.data[0].email)
                                                .collection("groupes")
                                                .doc(widget.groupe.nom)
                                                .collection("messages")
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return Text("Some error");
                                              } else if (snapshot
                                                      .connectionState ==
                                                  ConnectionState.waiting)
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              else if (snapshot.hasData) {
                                                for (var doc in snapshot
                                                    .data.docChanges) {
                                                  if (MessageGp.fromJson(
                                                              doc.doc.data())
                                                          .email ==
                                                      asyncsnapshot
                                                          .data[0].email) {
                                                    MessageGp mes = MessageGp(
                                                        MessageGp.fromJson(
                                                                doc.doc.data())
                                                            .nom,
                                                        MessageGp.fromJson(
                                                                doc.doc.data())
                                                            .email,
                                                        MessageGp.fromJson(
                                                                doc.doc.data())
                                                            .message,
                                                        true,
                                                        MessageGp.fromJson(
                                                                doc.doc.data())
                                                            .isImage);
                                                    model.message.add(mes);
                                                  } else {
                                                    MessageGp mes = MessageGp(
                                                        MessageGp.fromJson(
                                                                doc.doc.data())
                                                            .nom,
                                                        MessageGp.fromJson(
                                                                doc.doc.data())
                                                            .email,
                                                        MessageGp.fromJson(
                                                                doc.doc.data())
                                                            .message,
                                                        false,
                                                        MessageGp.fromJson(
                                                                doc.doc.data())
                                                            .isImage);
                                                    model.message.add(mes);
                                                  }
                                                  messages = model.message;
                                                }
                                                return ListViewMessageGroupe(
                                                    messages);
                                              } else
                                                return Center(
                                                    child:
                                                        CircularProgressIndicator());
                                            });
                                      }
                                    })
                                : Center(
                                    child: Image.asset(
                                    model.file.path,
                                    height: 700,
                                  ))))
                // list des messages
              ],
            ),
          ),
          bottomSheet: BottomSheetGroup(widget.groupe.nom),
        ));
  }
}

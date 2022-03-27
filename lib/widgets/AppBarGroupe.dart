import 'package:chat/GeneratedRoutes.dart';
import 'package:chat/Utils/DataBaseHelper.dart';
import 'package:chat/models/Contact.dart';
import 'package:chat/models/Groupe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppBarGroupe extends StatelessWidget {
  Groupe groupe;
  String email;
  List<Groupe> allgp = [];
  AppBarGroupe(this.groupe);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: SafeArea(
            child: AppBar(
          backgroundColor: Colors.white.withOpacity(0.4),
          elevation: 0.0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              size: 25,
              color: Colors.blue,
            ),
          ),
          title: Row(children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(groupe.nom,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                FutureBuilder<List<Contact>>(
                    future: DataBaseHelper().getUser(),
                    builder: (context, asyncsnapshot) {
                      if (asyncsnapshot.hasError)
                        return Text("Aucun message");
                      else if (asyncsnapshot.connectionState ==
                          ConnectionState.waiting)
                        return Center(child: CircularProgressIndicator());
                      else
                        return StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("users")
                                .doc(asyncsnapshot.data[0].email)
                                .collection("groupes")
                                .doc(groupe.nom)
                                .collection("member")
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text("Aucun message");
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting)
                                return Center(
                                    child: CircularProgressIndicator());
                              else if (snapshot.hasData) {
                                List<Groupe> allgroup = [];
                                for (var doc in snapshot.data.docChanges) {
                                  allgroup
                                      .add(Groupe.fromMembers(doc.doc.data()));
                                }
                                allgp = allgroup;
                                email = asyncsnapshot.data[0].email;

                                return Container(
                                    child: email ==
                                            allgroup[allgroup.length - 1]
                                                .emailMember
                                        ? Text(
                                            "membres: " +
                                                allgroup[0].nomMemeber +
                                                ", ...",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
                                          )
                                        : Text(
                                            "vous avez quitté ...",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
                                          ));
                              } else
                                return Center(child: Text("Aucun message"));
                            });
                    })
              ],
            ),
          ]),
          actions: [
            SizedBox(width: 15),
            Icon(
              Icons.videocam,
              size: 30,
              color: Colors.blue,
            )
          ],
        )),
        onTap: () {
          if (email == allgp[allgp.length - 1].emailMember) {
            List<String> list = [];
            list.add(email);
            list.add(groupe.nom);
            for (int i = 0; i < allgp.length - 1; i++)
              list.add(allgp[i].emailMember);
            print(email);
            Navigator.pushNamed(context, GeneratedRoutes.quit, arguments: list);
          }
        });
  }
}

import 'package:chat/Networking/Networking.dart';
import 'package:chat/Providers/LoginProviders.dart';
import 'package:chat/Utils/DataBaseHelper.dart';
import 'package:chat/models/Contact.dart';
import 'package:chat/models/Groupe.dart';
import 'package:chat/widgets/OneRowMember.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../GeneratedRoutes.dart';

class CreateGroup extends StatefulWidget {
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  DataBaseHelper helper = DataBaseHelper();
  String nomGroupe;
  String email;

  @override
  Widget build(BuildContext context) {
    helper.getUser().then((value) {
      if (value.length == 0) {
      } else {
        email = value[0].email;
      }
    });
    return Scaffold(
        body: ChangeNotifierProvider(
            create: (context) => LoginProviders(),
            child: Consumer<LoginProviders>(
              builder: (context, model, _) {
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 60.0, left: 8.0, right: 8.0),
                          child: Row(children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, GeneratedRoutes.groupe);
                              },
                              child: Text(
                                "Annuler",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 18),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 30.0),
                                child: Text("Nouveau groupe",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold))),
                            Padding(
                                padding: const EdgeInsets.only(left: 40.0),
                                child: GestureDetector(
                                    onTap: () async {
                                    
                                      if (model.listMember.length > 1) {
                                         final int i = await Networking.createGroup(email, nomGroupe);
                                         if(i == 1){
                                           final int j = await Networking.insertMember(email, nomGroupe, model.listMember);
                                           if(j == 1){
                                             final int k = await Networking.createGroupForOthers(model.listMember, email, nomGroupe);
                                             if(k == 1)
                                               {
                                                 final int l = await Networking.insertMemberForOthers(email, nomGroupe, model.listMember);
                                                   if(l == 1){
                                                      Groupe groupe = Groupe(nomGroupe);
                                                      Navigator.pushNamed(context, GeneratedRoutes.homeGroup,
                                                      arguments: groupe);
                                                   }
                                               }
                                              
                                           }
                                         }
                                      }
                                    },
                                    child: Text("Créer",
                                        style: TextStyle(
                                            color: model.listMember.length < 2
                                                ? Colors.grey
                                                : Colors.blue,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold))))
                          ])),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            width: double.infinity,
                            height: 40,
                            child: TextFormField(
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                  hintText: "Nom du groupe (facultatif)",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 20),
                                  border: InputBorder.none),
                              onChanged: (value) {
                                nomGroupe = value;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
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
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Colors.black,
                                  ),
                                  hintText: "Recherche",
                                  border: InputBorder.none),
                              onChanged: (value) {
                                model.chnageState();
                              },
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                              padding: const EdgeInsets.only(right: 274.0),
                              child: Container(
                                  child: Text("SUGGESTIONS",
                                      style: TextStyle(color: Colors.grey)))),
                        ],
                      ),
                      Expanded(
                          child: FutureBuilder<List<Contact>>(
                              future: DataBaseHelper().getUser(),
                              builder: (context, asyncsnapshot) {
                                if (asyncsnapshot.hasError)
                                  return Text("Some error");
                                else if (asyncsnapshot.connectionState ==
                                    ConnectionState.waiting)
                                  return Center(
                                      child: CircularProgressIndicator());
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
                                              child:
                                                  CircularProgressIndicator());
                                        else if (snapshot.hasData) {
                                          List<Contact> allContact = [];
                                          for (var doc
                                              in snapshot.data.docChanges) {
                                            if (Contact.fromJson(doc.doc.data())
                                                    .email !=
                                                asyncsnapshot.data[0].email)
                                              allContact.add(Contact.fromJson(
                                                  doc.doc.data()));
                                            Contact.fromJson(doc.doc.data())
                                                .isSelected = false;
                                          }
                                          if (model.listMember.length > 0)
                                            for (int i = 0;
                                                i < model.listMember.length;
                                                i++) {
                                              allContact[model
                                                          .listMember[i].indice]
                                                      .isSelected =
                                                  model
                                                      .listMember[i].isSelected;
                                            }

                                          return ListView.builder(
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return GestureDetector(
                                                  onTap: () {},
                                                  child: OneRowMember(
                                                      allContact[index],
                                                      index,
                                                      model));
                                            },
                                            itemCount: allContact.length,
                                          );
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
                    ]));
              },
            )));
  }
}

import 'package:chat/Networking/Networking.dart';
import 'package:chat/Providers/LoginProviders.dart';
import 'package:chat/Utils/DataBaseHelper.dart';
import 'package:chat/models/Contact.dart';
import 'package:chat/models/Groupe.dart';
import 'package:chat/widgets/ListViewAllGroup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat/widgets/AppBarMessenger.dart';
import 'package:chat/widgets/CustomTextField.dart';
import 'package:chat/widgets/ListViewAllContact.dart';
import 'package:provider/provider.dart';

class HomeMessage extends StatefulWidget {
  @override
  _HomeMessageState createState() => _HomeMessageState();
}

class _HomeMessageState extends State<HomeMessage> with WidgetsBindingObserver {
  DataBaseHelper helper = DataBaseHelper();
  String email;
  String optionVu;
  static List<Widget> _widegetOption = <Widget>[
    Expanded(
        child: FutureBuilder<List<Contact>>(
            future: DataBaseHelper().getUser(),
            builder: (context, asyncsnapshot) {
              if (asyncsnapshot.hasError)
                return Text("Some error");
              else if (asyncsnapshot.connectionState == ConnectionState.waiting)
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
                        return Center(child: CircularProgressIndicator());
                      else if (snapshot.hasData) {
                        List<Contact> allContact = [];
                        for (var doc in snapshot.data.docChanges) {
                          if (Contact.fromJson(doc.doc.data()).email !=
                              asyncsnapshot.data[0].email)
                            allContact.add(Contact.fromJson(doc.doc.data()));
                        }
                        return ListViewAllContact(allContact,asyncsnapshot.data[0].optionVu);
                      } else
                        return Center(
                            child: Icon(
                          Icons.wifi_off_rounded,
                          color: Colors.pinkAccent,
                        ));
                    });
            })
        // voir definition
        ),
    Expanded(
        child: FutureBuilder<List<Contact>>(
            future: DataBaseHelper().getUser(),
            builder: (context, asyncsnapshot) {
              if (asyncsnapshot.hasError)
                return Text("Aucun message");
              else if (asyncsnapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              else
                return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(asyncsnapshot.data[0].email)
                        .collection("message")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("Aucun message");
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting)
                        return Center(child: CircularProgressIndicator());
                      else if (snapshot.hasData) {
                        List<Contact> allMessage = [];
                        for (var doc in snapshot.data.docChanges) {
                          allMessage.add(Contact.fromFirestore(doc.doc.data()));
                        }
                        return ListViewAllContact(allMessage,asyncsnapshot.data[0].optionVu);
                      } else
                        return Center(child: Text("Aucun message"));
                    });
            })
        // voir definition
        ),
        Expanded(
        child: FutureBuilder<List<Contact>>(
            future: DataBaseHelper().getUser(),
            builder: (context, asyncsnapshot) {
              if (asyncsnapshot.hasError)
                return Text("Aucun message");
              else if (asyncsnapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              else
                return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(asyncsnapshot.data[0].email)
                        .collection("groupes")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("Aucun message");
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting)
                        return Center(child: CircularProgressIndicator());
                      else if (snapshot.hasData) {
                        List<Groupe> allgroup = [];
                        for (var doc in snapshot.data.docChanges) {
                          allgroup.add(Groupe.fromFirestore(doc.doc.data()));
                        }
                        return ListViewAllGroup(allgroup);
                      } else
                        return Center(child: Text("Aucun message"));
                    });
            })
        // voir definition
        )
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    helper.getUser().then((value) {
      email = value[0].email;
      optionVu = value[0].optionVu;
      Networking.updateStatus(email, "Online");
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed)
      helper.getUser().then((value) {
        email = value[0].email;
        Networking.updateStatus(email, "Online");
      });
    else
      helper.getUser().then((value) {
        email = value[0].email;
        Networking.updateStatus(email, "Offline");
      });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => LoginProviders(),
        child: Consumer<LoginProviders>(builder: (context, model, _) {
          return Scaffold(
              backgroundColor: Colors.white,
              bottomNavigationBar: BottomNavigationBar(
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline_sharp),
                      label: "Contacts",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.chat_bubble_outline_rounded),
                      label: "Messages",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.people_rounded),
                      label: "Groupes",
                    )
                  ],
                  currentIndex: model.index,
                  backgroundColor: Colors.white,
                  onTap: (int index) {
                    model.changeIntent(index);
                  }),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    AppBarMessenger(),
                    SizedBox(
                      height: 30,
                    ),
                    CustomTextField(model), // voir definition
                    SizedBox(
                      height: 10,
                    ),
                    model.textSearch == null
                        ? _widegetOption.elementAt(model.index)
                        : Expanded(
                            child: model.contactSearch != null
                                ? ListViewAllContact(model.contactSearch,optionVu)
                                : Center(child: Text("Contact inexistant!")))
                  ],
                ),
              ));
        }));
  }
}

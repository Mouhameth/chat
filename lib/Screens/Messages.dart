import 'package:chat/Networking/Networking.dart';
import 'package:chat/Providers/LoginProviders.dart';
import 'package:chat/Utils/DataBaseHelper.dart';
import 'package:chat/models/Contact.dart';
import 'package:chat/models/Message.dart';
import 'package:chat/widgets/AppBarMessage.dart';
import 'package:chat/widgets/BottomSheet.dart';
import 'package:chat/widgets/ListViewMessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserMessage extends StatefulWidget {
  Contact contact;
  String email;
  UserMessage(this.contact);
  @override
  _UserMessageState createState() => _UserMessageState();
}

class _UserMessageState extends State<UserMessage> {
  List<Message> messages = [];
  DataBaseHelper helper = DataBaseHelper();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => LoginProviders(),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                AppBarMessage(widget.contact),
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
                                  else
                                    return StreamBuilder<QuerySnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(asyncsnapshot.data[0].email)
                                            .collection(widget.contact.email)
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
                                          
                                            for (var doc
                                                in snapshot.data.docChanges) {
                                              if (Message.fromJson(
                                                          doc.doc.data())
                                                      .emetteur ==
                                                  asyncsnapshot.data[0].email) {
                                                Message mes = Message(
                                                    Message.fromJson(
                                                            doc.doc.data())
                                                        .message,
                                                    Message.fromJson(
                                                            doc.doc.data())
                                                        .isImage,
                                                    true,
                                                    Message.fromJson(
                                                            doc.doc.data())
                                                        .id,
                                                    Message.fromJson(
                                                            doc.doc.data())
                                                        .vu);
                                                model.messages.add(mes);
                                              } else {
                                                Message mes = Message(
                                                    Message.fromJson(
                                                            doc.doc.data())
                                                        .message,
                                                    Message.fromJson(
                                                            doc.doc.data())
                                                        .isImage,
                                                    false,
                                                    Message.fromJson(
                                                            doc.doc.data())
                                                        .id,
                                                    Message.fromJson(
                                                            doc.doc.data())
                                                        .vu);
                                                model.messages.add(mes);
                                                if (Message.fromJson(
                                                                doc.doc.data())
                                                            .vu ==
                                                        'false' ||
                                                    asyncsnapshot
                                                            .data[0].email !=
                                                        null)
                                                  Networking.updateVu(
                                                      widget.contact.email,
                                                      asyncsnapshot
                                                          .data[0].email,
                                                      Message.fromJson(
                                                              doc.doc.data())
                                                          .id);
                                                
                                              }
                                              messages = model.messages;
                                            }
                                            return ListViewMessagae(messages,
                                                widget.contact.urlImage);
                                          } else
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                        });
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
          bottomSheet: GetBottomSheet(
              widget.contact.email,
              widget.contact.userName,
              widget.contact.urlImage,
              widget.contact.statut),
        ));
  }
}

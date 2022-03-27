import 'dart:io';

import 'package:chat/Networking/Networking.dart';
import 'package:chat/Providers/LoginProviders.dart';
import 'package:chat/Utils/DataBaseHelper.dart';
import 'package:chat/models/Contact.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GetBottomSheet extends StatefulWidget {
  String email;
  String userName;
  String urlImage;
  String statut;
  GetBottomSheet(this.email, this.userName, this.urlImage, this.statut);
  @override
  _GetBottomSheetState createState() => _GetBottomSheetState();
}

class _GetBottomSheetState extends State<GetBottomSheet> {
  TextEditingController _messageController = TextEditingController();
  DataBaseHelper helper = DataBaseHelper();
  bool isImage = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Contact>>(
      future: DataBaseHelper().getUser(),
      builder: (context, snapashot) {
        if (snapashot.hasData) {
          String email = snapashot.data[0].email;
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
                          SizedBox(width: 15.0),
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
                          SizedBox(width: 10.0),
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
                                final int i = await Networking.envoyerMessage(
                                    email,
                                    widget.email,
                                    _messageController.text,
                                    isImage,
                                    null);
                                if (i == 1) {
                                  
                                    final int ins =
                                        await Networking.lastMessage(
                                            email,
                                            widget.email,
                                            widget.userName,
                                            widget.urlImage,
                                            _messageController.text,
                                            widget.statut);

                                    if (ins == 1) {
                                      final int j =
                                          await Networking.envoyerMessage(
                                              widget.email,
                                              email,
                                              _messageController.text,
                                              isImage,
                                              null);
                                      if (j == 1) {
                                        final int insert =
                                            await Networking.lastMessageExp(
                                                widget.email,
                                                email,
                                                widget.userName,
                                                widget.urlImage,
                                                _messageController.text,
                                                widget.statut);
                                        if (insert == 1) {
                                          model.send = 0;
                                          _messageController.clear();
                                          model.chnageState();
                                          model.messages = [];
                                        }
                                      }
                                    }
                                  
                                }
                              } else if (model.send == 1 && isImage == true) {
                                final int i = await Networking.envoyerMessage(
                                    email,
                                    widget.email,
                                    model.file.path,
                                    isImage,
                                    File(model.file.path));
                                if (i == 1) {
                                  print("ok");
                                  final int ins = await Networking.lastMessage(
                                      email,
                                      widget.email,
                                      widget.userName,
                                      widget.urlImage,
                                      "image",
                                      widget.statut);

                                  if (ins == 1) {
                                    final int j =
                                        await Networking.envoyerMessage(
                                            widget.email,
                                            email,
                                            model.file.path,
                                            isImage,
                                            File(model.file.path));
                                    if (j == 1) {
                                      final int insert =
                                          await Networking.lastMessageExp(
                                              widget.email,
                                              email,
                                              widget.userName,
                                              widget.urlImage,
                                              "image",
                                              widget.statut);
                                      if (insert == 1) {
                                        model.send = 0;
                                        _messageController.clear();
                                        model.file = null;
                                        model.messages = [];
                                        model.chnageState();
                                      }
                                    }
                                  }
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

import 'package:chat/models/Contact.dart';
import 'package:flutter/material.dart';
import 'package:chat/widgets/CircularImageUser.dart';

class OneRowContactMessage extends StatelessWidget {
  Contact contact;
  String optionVu;
  OneRowContactMessage(this.contact,this.optionVu);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Container(
            child: Stack(
              children: [
                contact.statut == 'Online'
                    ? Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(width: 2, color: Colors.blueAccent)),
                      )
                    : Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 2, color: Colors.white)),
                      ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0, top: 5, left: 5),
                  child: contact.urlImage != null
                      ? CircularImageUser(
                          urlImage: contact.urlImage, radius: 50)
                      : CircleAvatar(
                          radius: 30,
                          child: Icon(
                            Icons.person_rounded,
                            size: 30,
                          ),
                        ),
                ),
                contact.statut == 'Online'
                    ? Positioned(
                        bottom: 5,
                        left: 45,
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                              color: Colors.lightGreen,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(width: 3, color: Colors.white)),
                        ))
                    : Center(child: Text("")),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(
                  contact.userName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ]),
              SizedBox(
                height: 5,
              ),
              optionVu == 'false'?
              Container(
               child:contact.lu != 'false'
                  ? Container(
                      width: MediaQuery.of(context).size.width - 115,
                      child: contact.lastmessage != "image"
                          ? Container(
                              child: contact.lastmessage != null
                                  ? Text(
                                      contact.lastmessage,
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.black),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    )
                                  : Text(""))
                          : Padding(
                              padding: const EdgeInsets.only(right: 252),
                              child: Icon(
                                Icons.image,
                                color: Colors.blueAccent,
                              )),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width - 115,
                      child: contact.lastmessage != "image"
                          ? Container(
                              child: contact.lastmessage != null
                                  ? Text(
                                      contact.lastmessage,
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    )
                                  : Text(""))
                          : Padding(
                              padding: const EdgeInsets.only(right: 252),
                              child: Icon(
                                Icons.image,
                                color: Colors.blueAccent,
                              )),
                    )): Text("")

            ],
          ),
          contact.lu == 'false'
              ? Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                      border: Border.all(width: 3, color: Colors.white)),
                )
              : Text("")
        ],
      ),
    );
  }
}

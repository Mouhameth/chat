import 'package:chat/Providers/LoginProviders.dart';
import 'package:chat/models/Contact.dart';
import 'package:flutter/material.dart';
import 'CircularImageUser.dart';

class OneRowMember extends StatelessWidget {
  Contact contact;
  int index;
  LoginProviders model;
  int check = 0;
  OneRowMember(this.contact, this.index, this.model);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(children: [
          Container(
            child: Stack(
              children: [
                Container(
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
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: Text(
                contact.userName,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 20),
              child: Column(children: [
                Row(children: [
                  GestureDetector(
                    onTap: () {
                      if (contact.isSelected == false) {
                        model.listMember.add(contact);
                        model.select(index);
                      } else {
                        for (int i = 0; i < model.listMember.length; i++) {
                          if (model.listMember[i].indice == index) {
                            model.listMember.removeAt(i);
                            model.indice--;
                            model.chnageState();
                          }
                        }
                      }
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: contact.isSelected
                                ? Colors.blue
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10.0),
                            border: contact.isSelected
                                ? null
                                : Border.all(color: Colors.grey, width: 2.0)),
                        width: 20,
                        height: 20,
                        child: contact.isSelected
                            ? Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 15,
                              )
                            : null),
                  )
                ])
              ]))
        ]));
  }
}

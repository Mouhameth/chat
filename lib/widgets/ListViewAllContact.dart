import 'package:chat/GeneratedRoutes.dart';
import 'package:chat/models/Contact.dart';
import 'package:flutter/material.dart';
import 'OneRowContactMessage.dart';

class ListViewAllContact extends StatelessWidget {
  List<Contact> allContact;
  String optionVu;
  ListViewAllContact(this.allContact,this.optionVu);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, GeneratedRoutes.message,
                  arguments: allContact[index]);
            },
            child: OneRowContactMessage(allContact[index],optionVu));
      },
      itemCount: allContact.length,
    );
  }
}

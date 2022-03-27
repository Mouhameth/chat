import 'package:chat/models/Contact.dart';
import 'package:flutter/material.dart';

import 'CircularImageUser.dart';

class OneMessage extends StatelessWidget {
  Contact contact;
  OneMessage(this.contact);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: CircularImageUser(urlImage: contact.urlImage, radius: 60),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contact.userName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 115,
                child: Text(
                  contact.statut,
                  style: TextStyle(fontSize: 10, color: Colors.blue),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
import 'package:chat/models/Contact.dart';
import 'package:flutter/material.dart';

class AppBarMessage extends StatelessWidget {
  Contact contact;
  AppBarMessage(this.contact);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: contact.urlImage != null
                  ? DecorationImage(
                      image: NetworkImage(contact.urlImage), fit: BoxFit.cover)
                  : CircleAvatar(
                      radius: 30,
                      child: Icon(
                        Icons.person_rounded,
                        size: 30,
                      ),
                    )),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(contact.userName,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            SizedBox(height: 5),
            contact.statut == 'Online'
                ? Text("Active now",
                    style: TextStyle(fontSize: 12, color: Colors.grey))
                : Text("", style: TextStyle(fontSize: 12, color: Colors.grey))
          ],
        ),
      ]),
      actions: [
        Icon(
          Icons.phone,
          size: 30,
          color: Colors.blue,
        ),
        SizedBox(width: 15),
        Icon(
          Icons.videocam,
          size: 30,
          color: Colors.blue,
        )
      ],
    ));
  }
}

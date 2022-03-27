import 'package:chat/models/Groupe.dart';
import 'package:flutter/material.dart';

class OneRowGroup extends StatelessWidget {
  Groupe groupe;
  OneRowGroup(this.groupe);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Container(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15.0, top: 5, left: 5),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.people_rounded,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(
                  "groupe : " + groupe.nom,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ])
            ],
          )
        ],
      ),
    );
  }
}

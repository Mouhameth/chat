import 'package:chat/models/Message.dart';
import 'package:chat/models/messageGp.dart';
import 'package:chat/widgets/messageGroupe.dart';
import 'package:flutter/material.dart';

class ListViewMessageGroupe extends StatelessWidget {
List<MessageGp> message;
ListViewMessageGroupe(this.message);
  @override
  Widget build(BuildContext context) {
    return  ListView.builder(
      itemBuilder: (BuildContext context, int index) =>
          Container(
                  child: MessageGroup(
                  nom: message[index].nom,
                  message: message[index].message,
                  isMe: message[index].isMe,
                  isImage: message[index].isImage,
                  
                )),
      itemCount: message.length,
      physics: BouncingScrollPhysics(),
    );
  }
}
import 'package:chat/models/Message.dart';
import 'package:chat/widgets/Memessage.dart';
import 'package:flutter/material.dart';

class ListViewMessagae extends StatelessWidget {
  List<Message> message;
  String url;
  ListViewMessagae(this.message, this.url);
  String vu;
  @override
  Widget build(BuildContext context) {
    if (message.length > 0) vu = message[message.length - 1].vu;
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) =>
          index != message.length - 1
              ? Container(
                  child: Memessage(
                  isMe: message[index].isMe,
                  url: url,
                  message: message[index].message,
                  isImage: message[index].isImage,
                  vu: null,
                ))
              : Container(
                  child: Memessage(
                  isMe: message[index].isMe,
                  url: url,
                  message: message[index].message,
                  isImage: message[index].isImage,
                  vu: vu,
                )),
      itemCount: message.length,
      physics: BouncingScrollPhysics(),
    );
  }
}

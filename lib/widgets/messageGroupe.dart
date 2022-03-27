import 'package:flutter/material.dart';

class MessageGroup extends StatelessWidget {
  String nom;
  String message;
  bool isMe;
  String isImage;
  MessageGroup(
      {@required this.nom,
      @required this.message,
      @required this.isMe,
      @required this.isImage});
  @override
  Widget build(BuildContext context) {
    if (isMe)
      return Padding(
        padding: const EdgeInsets.only(right: 5, top: 5.0, bottom: 5.0),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Flexible(
                child: isImage != 'true'
                    ? Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(5)),
                            color: Colors.blue.withOpacity(0.8)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            message,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                            maxLines: message.length,
                          ),
                        ))
                    : Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.blue.withOpacity(0.8)),
                        child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Expanded(
                                child: Image.network(
                              message,
                              width: 250,
                            )))),
              ),
            ],
          ),
        ]),
      );
    else {
      return Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  child: Text(
                nom,
                style: TextStyle(color: Colors.black, fontSize: 10),
              )),
              isImage != 'true'
                  ? Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(5))),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          message,
                          style: TextStyle(fontSize: 15),
                          maxLines: message.length,
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.grey.withOpacity(0.8)),
                      child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Expanded(
                              child: Image.network(
                            message,
                            width: 250,
                          ))))
            ],
          ));
    }
  }
}

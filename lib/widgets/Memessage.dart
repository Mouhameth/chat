import 'package:flutter/material.dart';

class Memessage extends StatelessWidget {
  bool isMe;
  String url;
  String message;
  String isImage;
  String vu;
  Memessage(
      {@required this.isMe,
      @required this.url,
      @required this.message,
      @required this.isImage,
      @required this.vu});

  @override
  Widget build(BuildContext context) {
    print(isImage);
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
          vu != null
              ? Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Padding(
                      padding: const EdgeInsets.only(
                          right: 4, top: 2.0, bottom: 2.0),
                      child: vu == 'true'
                          ? Icon(
                              Icons.done_all,
                              color: Colors.blue,
                              size: 18,
                            )
                          : Icon(
                              Icons.done_all,
                              color: Colors.grey,
                              size: 18,
                            ))
                ])
              : Text("")
        ]),
      );
    else {
      return Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(url), fit: BoxFit.cover),
                ),
              ),
              SizedBox(width: 20),
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

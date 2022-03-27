import 'package:chat/GeneratedRoutes.dart';
import 'package:chat/Providers/LoginProviders.dart';
import 'package:chat/Utils/DataBaseHelper.dart';
import 'package:chat/models/Contact.dart';
import 'package:chat/widgets/CircularImageUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  Contact contact;
  Profile(this.contact);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 60.0, left: 15.0),
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 25,
                      color: Colors.blue,
                    )))
          ],
        ),
        SizedBox(height: 80),
        CircularImageUser(urlImage: widget.contact.urlImage, radius: 180),
        SizedBox(height: 40),
        Text(
          widget.contact.userName,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 30),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "option lu : ",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Container(
              child: ChangeNotifierProvider(
                  create: (context) => LoginProviders(),
                  child: Consumer<LoginProviders>(builder: (context, model, _) {
                    return FutureBuilder<List<Contact>>(
                        future: DataBaseHelper().getUser(),
                        builder: (context, asyncsnapshot) {
                          if (asyncsnapshot.hasError)
                            return Text("Aucun message");
                          else if (asyncsnapshot.connectionState ==
                              ConnectionState.waiting)
                            return Center(child: CircularProgressIndicator());
                          else
                            return GestureDetector(
                                onTap: () async {
                                  DataBaseHelper helper = DataBaseHelper();
                                  if (asyncsnapshot.data[0].optionVu == "false") {
                                    Contact contact =
                                        Contact(widget.contact.email, "true",asyncsnapshot.data[0].userName);
                                    final int i = await helper.update(contact);
                                    if (i != 0)
                                       model.chnageState();
                                  } else {
                                    Contact contact =
                                        Contact(widget.contact.email, "false",asyncsnapshot.data[0].userName);
                                    final int i = await helper.update(contact);
                                    if (i != 0) 
                                      model.chnageState();
                                  }
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: asyncsnapshot.data[0].optionVu ==
                                                'true'
                                            ? Colors.blue
                                            : Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(
                                            color: Colors.grey, width: 2.0)),
                                    width: 20,
                                    height: 20,
                                    child:
                                        asyncsnapshot.data[0].optionVu == 'true'
                                            ? Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 15,
                                              )
                                            : null));
                        });
                  })))
        ]),
        SizedBox(height: 40),
        GestureDetector(
            onTap: () async {
              DataBaseHelper helper = DataBaseHelper();
              final int i = await helper.delete(widget.contact.email);
              if (i != 0) {
                Navigator.pushNamed(context, GeneratedRoutes.signIn);
              }
            },
            child: Icon(
              Icons.logout,
              color: Colors.blue,
              size: 50,
            ))
      ],
    ));
  }
}

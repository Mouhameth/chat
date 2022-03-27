import 'package:chat/Providers/LoginProviders.dart';
import 'package:chat/models/Contact.dart';
import 'package:chat/widgets/OneRowMember.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../GeneratedRoutes.dart';

class ListSelectMember extends StatelessWidget {
  List<Contact> allContact;
  ListSelectMember(this.allContact);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginProviders(),
      child: Consumer<LoginProviders>(builder: (context, model, _) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
                onTap: () {}, child: OneRowMember(allContact[index], index,model));
          },
          itemCount: allContact.length,
        );
      }),
    );
  }
}

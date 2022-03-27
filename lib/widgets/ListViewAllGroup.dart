import 'package:chat/models/Groupe.dart';
import 'package:chat/widgets/OneRowGroup.dart';
import 'package:flutter/material.dart';
import '../GeneratedRoutes.dart';

class ListViewAllGroup extends StatelessWidget {
  List<Groupe> allGroup;
  ListViewAllGroup(this.allGroup);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, GeneratedRoutes.homeGroup,
                  arguments: allGroup[index]);
            },
            child: OneRowGroup(allGroup[index]));
      },
      itemCount: allGroup.length,
    );
  }
}

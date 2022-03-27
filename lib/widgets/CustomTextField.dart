import 'package:chat/Providers/LoginProviders.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  LoginProviders search;
  CustomTextField(this.search);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(25)),
      child: TextFormField(
        cursorColor: Colors.black.withOpacity(0.2),
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            hintText: "Recherche",
            border: InputBorder.none),
        onChanged: (value) {
          return search.search(value);
        },
      ),
    );
  }
}

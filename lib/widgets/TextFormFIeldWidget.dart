import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  String label;
  Icon icon;
  FormFieldValidator<String> validator;
  TextEditingController _controller;
  bool obscure;

  TextFormFieldWidget(this.label, this.icon,this._controller,this.obscure, this.validator);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: TextFormField(
        validator: validator,
        controller: _controller,
        obscureText:obscure,
        decoration: new InputDecoration(
            border: new OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(30.0),
              ),
            ),
            filled: true,
            hintStyle: new TextStyle(color: Colors.black),
            hintText: label,
            prefixIcon: icon,
            fillColor: Colors.white70),
      ),
    );
  }
}

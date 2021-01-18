import 'package:flutter/material.dart';

TextStyle loginPageStyle() {
  return const TextStyle(
    fontSize: 18.0,
    color: Colors.white,
  );
}

InputDecoration textFieldStyle({String hintext}) {
  return InputDecoration(
    hintText: hintext,
    hintStyle: TextStyle(color: Colors.grey),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey,
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey,
      ),
    ),
  );
}

TextStyle buttonStyle() {
  return const TextStyle(
    fontSize: 20.0,
    color: Colors.white,
  );
}

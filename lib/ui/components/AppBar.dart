import 'package:flutter/material.dart';

Widget appBar({
  @required String title,
  List<Widget> actions
}) {
  return AppBar(
    title: Text(title,
    style: TextStyle(
      fontWeight: FontWeight.bold
    ),),
    centerTitle: true,
    actions: actions,
  );
}

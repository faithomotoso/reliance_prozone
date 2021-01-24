import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const EdgeInsetsGeometry bodyPadding = EdgeInsets.all(12);

Future navigate({@required BuildContext context, @required Widget newPage}) {
  return Navigator.push(context, MaterialPageRoute(builder: (_) => newPage));
}

Widget listViewDivider() {
  return Divider(
    color: Colors.blueGrey.withOpacity(0.6),
    height: 20,
  );
}

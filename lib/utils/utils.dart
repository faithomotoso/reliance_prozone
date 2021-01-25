import 'package:dio/dio.dart';
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

BorderRadius get textFieldBorderRadius => BorderRadius.circular(6);

void debugDioError({@required DioError error, @required String functionName}) {
  debugPrint("Dio error at $functionName: ${error.message}, ${error.response}");
}

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const EdgeInsetsGeometry bodyPadding = EdgeInsets.all(12);

Future navigate({@required BuildContext context, @required Widget newPage}) {
  return Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => newPage,
          settings: RouteSettings(name: newPage.runtimeType.toString())));
}

Widget listViewDivider() {
  return Divider(
    color: Colors.blueGrey.withOpacity(0.6),
    height: 20,
  );
}

BorderRadius get appBorderRadius => BorderRadius.circular(6);

void debugDioError({@required DioError error, @required String functionName}) {
  // Only print logs in debug mode
  if (kDebugMode)
    debugPrint(
        "Dio error at $functionName: ${error.message}, ${error.response}");
}

void removeKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

void showLoadingIndicator({@required BuildContext context}) {
  showDialog(
      context: context,
      builder: (context) => Center(
            child: Theme(
                data: Theme.of(context).copyWith(accentColor: Colors.white),
                child: WillPopScope(
                    onWillPop: () => Future.value(false),
                    child: CircularProgressIndicator())),
          ),
      barrierDismissible: false);
}

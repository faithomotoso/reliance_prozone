import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:reliance_hmo_test/utils/utils.dart';

void showSnackbar({@required GlobalKey<
    ScaffoldState> scaffoldKey, @required String message,
  Duration duration = const Duration(milliseconds: 1500),
  Color color = Colors.green}) {
  scaffoldKey.currentState.showSnackBar(SnackBar(
    content: Text(message),
    duration: duration,
    backgroundColor: color,
    behavior: SnackBarBehavior.floating,));
}

void showDioErrorSnackbar(
    {@required GlobalKey<ScaffoldState> scaffoldKey,
      @required DioError dioError,
      @required String functionName}) {
  debugDioError(error: dioError, functionName: functionName);
  String message = dioError.message.contains("SocketException")
      ? "Please check your internet connection"
      : "An error occurred. Please try again.";
  showSnackbar(
      scaffoldKey: scaffoldKey, message: message, color: Colors.redAccent);
}
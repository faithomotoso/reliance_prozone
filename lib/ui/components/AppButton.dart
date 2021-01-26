import 'package:flutter/material.dart';

class AppButton extends ElevatedButton {
  final String buttonText;
  final VoidCallback onPressed;
  final BuildContext context;
  final Color buttonColor;
  final Color textColor;
  final bool useOutlineColor;
  final Color outlineColor;

  AppButton(
      {@required this.buttonText,
      @required this.onPressed,
      @required this.context,
      this.buttonColor,
      this.textColor,
      this.useOutlineColor = false,
      this.outlineColor})
      : assert(buttonText != null),
        assert(context != null),
        super(
            onPressed: onPressed,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              return buttonColor ?? Theme.of(context).primaryColor;
            }),
            side: MaterialStateProperty.resolveWith<BorderSide>((states) {
              return BorderSide(
                color: useOutlineColor ? outlineColor : Colors.transparent
              );
            })),
            child: Text(
              buttonText,
              style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ));
}

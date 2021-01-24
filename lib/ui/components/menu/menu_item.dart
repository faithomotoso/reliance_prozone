import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  String name;
  VoidCallback onTap;

  MenuItem({@required this.name, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onTap?.call,
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.grey.withOpacity(0.6))
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ));
  }
}

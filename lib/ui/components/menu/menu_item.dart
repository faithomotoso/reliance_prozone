import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  String name;
  VoidCallback onTap;
  String iconPath;

  MenuItem({@required this.name, @required this.onTap, this.iconPath});

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
            if (iconPath != null)Image.asset(iconPath, height: 50, width: 50,),
            Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ));
  }
}

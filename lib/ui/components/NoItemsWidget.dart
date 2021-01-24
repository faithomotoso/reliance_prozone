import 'package:flutter/material.dart';

class NoItemsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "No Items",
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}

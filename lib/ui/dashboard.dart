import 'package:flutter/material.dart';
import 'package:reliance_hmo_test/ui/components/AppBar.dart';
import 'package:reliance_hmo_test/ui/components/menu/menu_item.dart';
import 'package:reliance_hmo_test/utils/utils.dart';

import 'hmo_providers/hmo_providers_page.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List<MenuItem> menu;

  @override
  void initState() {
    super.initState();
    menu = [
      MenuItem(
          name: "HMO Providers",
          onTap: () {
            navigate(context: context, newPage: HMOProvidersPage());
          })
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "ProZone"),
      body: Padding(
        padding: bodyPadding,
        child: GridView.count(
          crossAxisCount: 2,
          children: menu,
        ),
      ),
    );
  }
}

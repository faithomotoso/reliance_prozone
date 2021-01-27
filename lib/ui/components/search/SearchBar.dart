import 'package:flutter/material.dart';
import 'package:reliance_hmo_test/utils/utils.dart';

import '../TextFieldHeader.dart';

class SearchBar extends StatefulWidget {
  Function onSearch;
  String hint;

  SearchBar({@required this.onSearch, @required this.hint});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: textFieldDecoration(widget.hint ??  "Search"),
            ),
          ),
          SizedBox(width: 10,),
          TextButton(onPressed: () {
            widget.onSearch?.call(searchController.text);
            removeKeyboard(context);
          }, child: Text("Search"))
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:reliance_hmo_test/ui/components/TextFieldHeader.dart';
import 'package:reliance_hmo_test/utils/utils.dart';

abstract class SearchableList<T extends StatefulWidget> extends State<T> {
  final TextEditingController searchController = TextEditingController();
  ValueNotifier<bool> keyboardVisible = ValueNotifier<bool>(false);
  ValueNotifier<bool> isValid = ValueNotifier<bool>(true);

  List get allList;

  // list to be searched, different from allList
  ValueNotifier<List> searchList;

  @override
  void initState() {
    super.initState();

    // listen for keyboard visibility
    KeyboardVisibility.onChange.listen((bool visible) {
      keyboardVisible.value = visible;
    });
    searchList = ValueNotifier<List>(allList);
  } // shown before the dropdown button

  String get headerText;

  /// String to show for the selected value.
  String get selectedValue;

  /// Hint to display
  String get textWhenNull;

  /// String to show when validation is false
  String get validatorMessage;

  Widget header() {
    return Text(
      headerText,
      style: Theme.of(context)
          .textTheme
          .headline6
          .copyWith(fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    // assert(searchList.value.isNotEmpty, "Initialize this list at initState()");
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header(),
        SizedBox(
          height: 10,
        ),
        dropDownButton()
      ],
    );
  }

  Widget dropDownButton() {
    return ValueListenableBuilder(
      valueListenable: isValid,
      builder: (context, isValid, child) {
        return InkWell(
          onTap: () {
            removeKeyboard(context);
            _showSearchableList?.call();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: appBorderRadius,
                    color: Colors.grey.withOpacity(0.1),
                    border: Border.all(
                        color: !isValid
                            ? Theme.of(context).errorColor
                            : Colors.transparent)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      selectedValue ?? textWhenNull,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
              if (!isValid) _validatorWidget()
            ],
          ),
        );
      },
    );
  }

  void _showSearchableList() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return ValueListenableBuilder(
            valueListenable: keyboardVisible,
            builder: (context, keyboardVisible, child) {
              return Material(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.linearToEaseOut,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  height: keyboardVisible
                      ? MediaQuery.of(context).size.height * 0.85
                      : 350,
                  child: _body(),
                ),
              );
            },
          );
        });
  }

  Widget _validatorWidget() {
    return Text(
      validatorMessage ?? "",
      style: Theme.of(context)
          .textTheme
          .bodyText2
          .copyWith(color: Theme.of(context).errorColor, fontSize: 12),
    );
  }

  Widget _body() {
    return Column(
      children: [
        SearchableListSearchBar(
          searchController: searchController,
          onChanged: search,
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: searchList,
            builder: (context, searchList, child) {
              return ListView.separated(
                  separatorBuilder: (context, index) => listViewDivider(),
                  itemCount: searchList.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return itemWidgetToDisplay?.call(searchList[index]);
                  });
            },
          ),
        )
      ],
    );
  }

  void search(String query) {
    // Ensure the searchList.value isn't empty.
    if (query.isEmpty) {
      searchList.value = allList;
    } else {
      searchList.value = searchFunction(query);
    }
  }

  /// Defines the function to search a list.
  /// Return a list meeting the search requirements
  List searchFunction(String query);

  // widget to display in the list
  Widget itemWidgetToDisplay(var item);

  bool validate() {
    // removeKeyboard(context);
    isValid.value = selectedValue != null;

    return selectedValue != null;
  }
}

class SearchableListSearchBar extends StatelessWidget {
  TextEditingController searchController;
  String hintText;
  Function onSearchButtonPressed;

  // For uses with no search button
  Function onChanged;

  SearchableListSearchBar(
      {@required this.searchController,
      this.onSearchButtonPressed,
      this.hintText,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: searchController,
            decoration: textFieldDecoration(hintText ?? "Search"),
            onChanged: onChanged?.call,
          ),
        ),
        if (onSearchButtonPressed != null)
          Row(
            children: [
              const SizedBox(
                width: 6,
              ),
              TextButton(
                onPressed: () {
                  onSearchButtonPressed?.call();
                  // removeKeyboard(context);
                },
                // padding: const EdgeInsets.all(8),
                child: const Text(
                  "Search",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:reliance_hmo_test/business_logic/models/state/NState.dart';
import 'package:reliance_hmo_test/ui/components/SearchableList.dart';

class StatesWidget extends StatefulWidget {
  NState selectedState;
  Function onStateSelected;
  List<NState> states;

  StatesWidget(
      {@required this.selectedState,
      @required this.onStateSelected,
      @required this.states,
      Key key})
      : super(key: key);

  @override
  StatesWidgetState createState() => StatesWidgetState();
}

class StatesWidgetState extends SearchableList<StatesWidget> {
  NState selectedState;

  @override
  void initState() {
    super.initState();
    selectedState = widget.selectedState;
  }

  @override
  List get allList => widget.states;

  @override
  String get headerText => "State";

  @override
  Widget itemWidgetToDisplay(item) {
    NState state = item;
    return ListTile(
      onTap: () {
        widget.onStateSelected?.call(state);
        setState(() {
          selectedState = state;
        });
        Navigator.pop(context);
        validate();
      },
      title: Text(state.name),
    );
  }

  @override
  List searchFunction(String query) {
    List<NState> allStates = allList;
    return allStates
        .where((element) =>
            element.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  String get selectedValue {
    List<NState> allStates = allList;
    return allStates
            .firstWhere((element) => element.id == selectedState?.id,
                orElse: () => null)?.name;
  }

  @override
  String get textWhenNull => "Select State";

  @override
  String get validatorMessage => "Please select a state";
}

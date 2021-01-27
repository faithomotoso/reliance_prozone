import 'package:flutter/material.dart';
import 'package:reliance_hmo_test/business_logic/models/state/NState.dart';
import 'package:reliance_hmo_test/ui/components/SearchableList.dart';

class StatesWidget extends StatefulWidget {
  NState selectedState;
  Function onStateSelected;
  List<NState> states;
  String customHint;
  bool canEdit;

  StatesWidget(
      {@required this.selectedState,
      @required this.onStateSelected,
      @required this.states,
      this.customHint,
        this.canEdit = true,
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
  bool get canEdit => widget.canEdit;

  @override
  List get allList => widget.states;

  @override
  String get headerText => "State";

  @override
  void didUpdateWidget(StatesWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      selectedState = widget.selectedState;
    });
  }

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
            orElse: () => null)
        ?.name;
  }

  @override
  String get textWhenNull => widget.customHint ?? "Select State";

  @override
  String get validatorMessage => "Please select a state";
}

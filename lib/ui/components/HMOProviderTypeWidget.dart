import 'package:flutter/material.dart';
import 'file:///C:/Users/user/AndroidStudioProjects/reliance_hmo_test/lib/business_logic/HMOProviderType.dart';
import 'package:reliance_hmo_test/ui/components/SearchableList.dart';

class HMOProviderTypeWidget extends StatefulWidget {
  HMOProviderType selectedHmoProviderType;
  Function onProviderTypeSelected;
  List<HMOProviderType> providerTypes;
  String customHint;
  bool canEdit;

  HMOProviderTypeWidget({@required this.selectedHmoProviderType,
    @required this.onProviderTypeSelected,
    @required this.providerTypes,
    this.customHint,
    this.canEdit = true,
    Key key})
      : super(key: key);

  @override
  HMOProviderTypeWidgetState createState() => HMOProviderTypeWidgetState();
}

class HMOProviderTypeWidgetState
    extends SearchableList<HMOProviderTypeWidget> {
  HMOProviderType selectedProviderType;

  @override
  void initState() {
    super.initState();
    selectedProviderType = widget.selectedHmoProviderType;
  }


  @override
  void didUpdateWidget(HMOProviderTypeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      selectedProviderType = widget.selectedHmoProviderType;
    });
  }

  @override
  bool get canEdit => widget.canEdit;

  @override
  List get allList => widget.providerTypes;

  @override
  String get headerText => "Type";

  @override
  Widget itemWidgetToDisplay(item) {
    HMOProviderType providerType = item;
    return ListTile(
      onTap: () {
        widget.onProviderTypeSelected?.call(providerType);
        setState(() {
          selectedProviderType = providerType;
        });
        validate();
        Navigator.pop(context);
      },
      title: Text(
        providerType.name
      ),
    );
  }

  @override
  List searchFunction(String query) {
    List<HMOProviderType> types = allList;
    return types.where((element) =>
        element.name.toLowerCase().contains(query.toLowerCase())).toList();
  }

  @override
  String get selectedValue {
    List<HMOProviderType> types = allList;
    return types
        .firstWhere((element) => element.id == selectedProviderType?.id,
        orElse: () => null)
        ?.name;
  }

  @override
  String get textWhenNull => widget.customHint ?? "Select type";

  @override
  String get validatorMessage => "Please select a type";
}

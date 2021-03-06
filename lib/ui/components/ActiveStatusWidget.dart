import 'package:flutter/material.dart';
import 'package:reliance_hmo_test/business_logic/models/ActiveStatus.dart';
import 'package:reliance_hmo_test/ui/components/SearchableList.dart';

class ActiveStatusWidget extends StatefulWidget {
  ActiveStatus activeStatus;
  Function onStatusSelected;
  String customHint;
  bool canEdit;

  ActiveStatusWidget(
      {@required this.activeStatus,
      @required this.onStatusSelected,
      this.customHint,
      this.canEdit = true,
      Key key})
      : super(key: key);

  @override
  ActiveStatusWidgetState createState() => ActiveStatusWidgetState();
}

class ActiveStatusWidgetState extends SearchableList<ActiveStatusWidget> {
  ActiveStatus selectedStatus;

  @override
  void initState() {
    super.initState();

    selectedStatus = widget.activeStatus;
  }

  @override
  bool get canEdit => widget.canEdit;

  @override
  List get allList => ActiveStatus.statusOptions;

  @override
  String get headerText => "Status";

  @override
  Widget itemWidgetToDisplay(item) {
    ActiveStatus status = item;
    return ListTile(
      onTap: () {
        widget.onStatusSelected?.call(status);
        Navigator.pop(context);
        setState(() {
          selectedStatus = status;
        });
        validate();
      },
      title: Text(
        status.activeStatus,
      ),
    );
  }

  @override
  void didUpdateWidget(ActiveStatusWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      selectedStatus = widget.activeStatus;
    });
  }

  @override
  List searchFunction(String query) {
    return allList
        .where((element) => element.activeStatus
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
  }

  @override
  String get selectedValue {
    return allList
        .firstWhere(
            (element) => element.activeStatus.toString().toLowerCase().contains(
                selectedStatus?.activeStatus.toString().toLowerCase()),
            orElse: () => null)
        ?.activeStatus;
  }

  @override
  String get textWhenNull => widget.customHint ?? "Select Status";

  @override
  String get validatorMessage => "Please select a status";
}

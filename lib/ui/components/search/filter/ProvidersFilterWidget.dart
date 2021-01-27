import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reliance_hmo_test/business_logic/models/ActiveStatus.dart';
import 'package:reliance_hmo_test/business_logic/models/image/HMOProviderType.dart';
import 'package:reliance_hmo_test/business_logic/models/state/NState.dart';
import 'package:reliance_hmo_test/business_logic/view_models/AppViewModel.dart';
import 'package:reliance_hmo_test/ui/components/AppButton.dart';
import 'package:reliance_hmo_test/ui/components/AppFutureBuilder.dart';
import 'package:reliance_hmo_test/utils/utils.dart';

import '../../ActiveStatusWidget.dart';
import '../../HMOProviderTypeWidget.dart';
import '../../StatesWidget.dart';

class ProvidersFilterWidget extends StatefulWidget {
  FilterParamsCallback onApplyFilter;

  ProvidersFilterWidget({@required this.onApplyFilter});

  @override
  _ProvidersFilterWidgetState createState() => _ProvidersFilterWidgetState();
}

class _ProvidersFilterWidgetState extends State<ProvidersFilterWidget> {
  HMOProviderType typeFilter;
  ActiveStatus statusFilter;
  NState stateFilter;
  TextEditingController locationController = TextEditingController();

  // For location
  Future statesFuture;
  List<NState> states;

  Future providerTypesFuture;
  List<HMOProviderType> providerTypes;

  Future futureWait;

  void getStates() {
    statesFuture = Provider.of<AppViewModel>(context, listen: false)
        .getAllStates()
        .then((value) {
      if (value is List) states = value;

      return value;
    });
  }

  void getProviderTypes() {
    providerTypesFuture = Provider.of<AppViewModel>(context, listen: false)
        .getAllProviderTypes()
        .then((value) {
      if (value is List) providerTypes = value;
      return value;
    });
  }

  void loadLists() {
    getStates();
    getProviderTypes();
  }

  void assignFutureWait() {
    loadLists();
    futureWait = Future.wait([statesFuture, providerTypesFuture]);
  }

  @override
  void initState() {
    super.initState();
    assignFutureWait();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(CupertinoIcons.line_horizontal_3_decrease),
        onPressed: () {
          showFilterDialog();
        });
  }

  void showFilterDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, stState) {
            return Align(
              child: AppFutureBuilder(
                future: futureWait,
                onReload: () {
                  setState(() {
                    assignFutureWait();
                  });
                },
                onData: (data) {
                  return Material(
                    color: Colors.transparent,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.7,
                      padding: bodyPadding,
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: appBorderRadius),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Filter",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              AppButton(
                                  buttonText: "Clear Filter",
                                  onPressed: () {
                                    stState(() {
                                      clearFilter();
                                    });
                                  },
                                  context: context)
                            ],
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Theme(
                            data: Theme.of(context).copyWith(
                                textTheme: Theme.of(context).textTheme.copyWith(
                                    headline6: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(fontSize: 14))),
                            child: Expanded(
                              child: ListView(
                                children: [
                                  HMOProviderTypeWidget(
                                      selectedHmoProviderType: typeFilter,
                                      customHint: "filter by Type",
                                      onProviderTypeSelected: (type) {
                                        stState(() {
                                          typeFilter = type;
                                        });
                                      },
                                      providerTypes: providerTypes),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ActiveStatusWidget(
                                      activeStatus: statusFilter,
                                      customHint: "filter by Status",
                                      onStatusSelected: (status) {
                                        stState(() {
                                          statusFilter = status;
                                        });
                                      }),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  StatesWidget(
                                    selectedState: stateFilter,
                                    customHint: "filter by State",
                                    onStateSelected: (state) {
                                      stState(() {
                                        stateFilter = state;
                                      });
                                    },
                                    states: states,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Center(
                            child: AppButton(
                                buttonText: "Apply Filter",
                                onPressed: () {
                                  widget.onApplyFilter?.call(
                                      typeFilter, statusFilter, stateFilter);
                                },
                                context: context),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          });
        });
  }

  void clearFilter() {
    typeFilter = null;
    statusFilter = null;
    stateFilter = null;
    widget.onApplyFilter?.call(typeFilter, statusFilter, stateFilter);
  }
}

typedef FilterParamsCallback(HMOProviderType providerTypeFilter,
    ActiveStatus activeStatusFilter, NState stateFilter);

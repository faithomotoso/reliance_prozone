import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reliance_hmo_test/business_logic/models/ActiveStatus.dart';
import 'package:reliance_hmo_test/business_logic/models/hmo_provider/HMOProvider.dart';
import 'package:reliance_hmo_test/business_logic/models/image/HMOProviderType.dart';
import 'package:reliance_hmo_test/business_logic/view_models/AppViewModel.dart';
import 'package:reliance_hmo_test/ui/components/AppBar.dart';
import 'package:reliance_hmo_test/ui/components/AppFutureBuilder.dart';
import 'package:reliance_hmo_test/ui/components/HMOProviderTile.dart';
import 'package:reliance_hmo_test/ui/components/NoItemsWidget.dart';
import 'package:reliance_hmo_test/ui/components/search/SearchBar.dart';
import 'package:reliance_hmo_test/ui/components/search/filter/ProvidersFilterWidget.dart';
import 'package:reliance_hmo_test/ui/hmo_providers/add_edit_hmo_provider.dart';
import 'package:reliance_hmo_test/utils/utils.dart';

class HMOProvidersPage extends StatefulWidget {
  @override
  _HMOProvidersPageState createState() => _HMOProvidersPageState();
}

class _HMOProvidersPageState extends State<HMOProvidersPage> {
  AppViewModel appViewModel;
  Future providersFuture;
  ValueNotifier<bool> showFab = ValueNotifier<bool>(false);
  String nameSearchParam = '';

  HMOProviderType providerTypeFilter;
  ActiveStatus activeStatusFilter;

  void getProviders() {
    showFab.value = false;
    providersFuture = Provider.of<AppViewModel>(context, listen: false)
        .getAllProviders(
            nameSearchParam: nameSearchParam,
            statusFilter: activeStatusFilter,
            typeFilter: providerTypeFilter)
        .then((value) {
      showFab.value = true;
      return value;
    });
  }

  @override
  void initState() {
    super.initState();
    getProviders();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (appViewModel == null) appViewModel = Provider.of<AppViewModel>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Providers", actions: [filterWidget()]),
      floatingActionButton: fab(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
                hint: "Search by name",
                onSearch: (query) {
                  setState(() {
                    nameSearchParam = query;
                    getProviders();
                  });
                }),
          ),
          Expanded(
            child: AppFutureBuilder(
              future: providersFuture,
              onReload: () {
                setState(() {
                  getProviders();
                });
              },
              onData: (data) {
                // List<HMOProvider> hmoProviders = data;

                return appViewModel.allProviders.isNotEmpty
                    ? ListView.separated(
                        separatorBuilder: (context, index) => listViewDivider(),
                        itemCount: appViewModel.allProviders.length,
                        physics: BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(
                          top: 12,
                          bottom: 60,
                        ),
                        itemBuilder: (context, index) {
                          HMOProvider hmoProvider =
                              appViewModel.allProviders[index];
                          return HMOProviderTile(
                            hmoProvider: hmoProvider,
                            onTap: () {
                              navigate(
                                      context: context,
                                      newPage: AddEditHMOProvider(
                                          hmoProvider: hmoProvider))
                                  .then((value) {
                                handleLoadOnPop();
                              });
                            },
                          );
                        },
                      )
                    : NoItemsWidget();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget fab() {
    return ValueListenableBuilder(
      valueListenable: showFab,
      builder: (context, showFab, child) {
        if (!showFab) return SizedBox();
        return FloatingActionButton(
          onPressed: () {
            navigate(context: context, newPage: AddEditHMOProvider())
                .then((value) {
              handleLoadOnPop();
            });
          },
          tooltip: "Add Provider",
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        );
      },
    );
  }

  void handleLoadOnPop() {
    if (appViewModel.loadOnPop) {
      setState(() {
        getProviders();
      });
      appViewModel.loadOnPop = false;
    }
  }

  Widget noProvidersWidget() {
    return Center(
      child: Text(
        "No Providers\nCreate a Provider",
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget filterWidget() {
    return ProvidersFilterWidget(onApplyFilter: (filterType, filterStatus) {
      Navigator.pop(context);
      setState(() {
        providerTypeFilter = filterType;
        activeStatusFilter = filterStatus;
        getProviders();
      });
    });
  }
}

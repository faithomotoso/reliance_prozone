import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reliance_hmo_test/business_logic/models/hmo_provider/HMOProvider.dart';
import 'package:reliance_hmo_test/business_logic/view_models/AppViewModel.dart';
import 'package:reliance_hmo_test/ui/components/AppBar.dart';
import 'package:reliance_hmo_test/ui/components/AppFutureBuilder.dart';
import 'package:reliance_hmo_test/ui/components/HMOProviderTile.dart';
import 'package:reliance_hmo_test/ui/components/NoItemsWidget.dart';
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

  void getProviders() {
    showFab.value = false;
    providersFuture = Provider.of<AppViewModel>(context, listen: false)
        .getAllProviders()
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
    if (appViewModel == null)
      appViewModel = Provider.of<AppViewModel>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Providers"),
      floatingActionButton: fab(),
      body: AppFutureBuilder(
        future: providersFuture,
        onReload: () {
          setState(() {
            getProviders();
          });
        },
        onData: (data) {
          List<HMOProvider> hmoProviders = data;

          return hmoProviders.isNotEmpty
              ? ListView.separated(
                  separatorBuilder: (context, index) => listViewDivider(),
                  itemCount: hmoProviders.length,
                  physics: BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(
                    top: 12,
                    bottom: 30,
                  ),
                  itemBuilder: (context, index) {
                    HMOProvider hmoProvider = hmoProviders[index];
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
      child: Text("No Providers\nCreate a Provider",
      textAlign: TextAlign.center,),
    );
  }
}

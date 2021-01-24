import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reliance_hmo_test/business_logic/models/hmo_provider/HMOProvider.dart';
import 'package:reliance_hmo_test/business_logic/view_models/AppViewModel.dart';
import 'package:reliance_hmo_test/ui/components/AppBar.dart';
import 'package:reliance_hmo_test/ui/components/AppFutureBuilder.dart';
import 'package:reliance_hmo_test/ui/components/HMOProviderTile.dart';
import 'package:reliance_hmo_test/ui/components/NoItemsWidget.dart';
import 'package:reliance_hmo_test/utils/utils.dart';

class HMOProvidersPage extends StatefulWidget {
  @override
  _HMOProvidersPageState createState() => _HMOProvidersPageState();
}

class _HMOProvidersPageState extends State<HMOProvidersPage> {
  AppViewModel appViewModel;
  Future providersFuture;

  void getProviders() {
    providersFuture =
        Provider.of<AppViewModel>(context, listen: false).getAllProviders();
  }


  @override
  void initState() {
    super.initState();
    getProviders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Providers"),
      body: AppFutureBuilder(
        future: providersFuture,
        onReload: () {
          setState(() {
            getProviders();
          });
        },
        onData: (data) {
          List<HMOProvider> hmoProviders = data;

          return hmoProviders.isNotEmpty ? ListView.separated(
            separatorBuilder: (context, index) => listViewDivider(),
            itemCount: hmoProviders.length,
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: 12, bottom: 12,),
            itemBuilder: (context, index) {
              HMOProvider hmoProvider = hmoProviders[index];
              return HMOProviderTile(hmoProvider: hmoProvider);
            },
          ) : NoItemsWidget();
        },
      ),
    );
  }
}

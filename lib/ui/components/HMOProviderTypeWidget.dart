import 'package:flutter/material.dart';
import 'package:reliance_hmo_test/business_logic/models/image/HMOProviderType.dart';

class HMOProviderTypeWidget extends StatefulWidget {
  HMOProviderType selectedHmoProviderType;
  Function onProviderTypeSelected;
  List<HMOProviderType> providerTypes;

  @override
  _HMOProviderTypeWidgetState createState() => _HMOProviderTypeWidgetState();
}

class _HMOProviderTypeWidgetState extends State<HMOProviderTypeWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

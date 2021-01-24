import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:reliance_hmo_test/business_logic/models/hmo_provider/HMOProvider.dart';
import 'package:reliance_hmo_test/services/api/AppApi.dart';

class AppViewModel extends ChangeNotifier {

  Future getAllProviders() async {
    try {
      Response response = await AppApi.getAllProviders();
      List data = response.data;
      List<HMOProvider> providers = List<HMOProvider>.from(data.map((e) => HMOProvider.fromJson(e)));
      return providers;
    } on DioError catch (e) {

    }
  }
}
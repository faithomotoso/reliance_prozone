import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:reliance_hmo_test/business_logic/models/hmo_provider/HMOProvider.dart';
import 'package:reliance_hmo_test/business_logic/models/image/HMOProviderType.dart';
import 'package:reliance_hmo_test/business_logic/models/state/NState.dart';
import 'package:reliance_hmo_test/services/api/AppApi.dart';
import 'package:reliance_hmo_test/utils/utils.dart';

class AppViewModel extends ChangeNotifier {
  Future getAllProviders() async {
    try {
      Response response = await AppApi.getAllProviders();
      List data = response.data;
      List<HMOProvider> providers =
          List<HMOProvider>.from(data.map((e) => HMOProvider.fromJson(e)));
      return providers;
    } on DioError catch (e) {
      debugDioError(error: e, functionName: "getAllProviders");
      return Future.error(e);
    }
  }

  Future getAllStates() async {
    try {
      Response response = await AppApi.getAllStates();
      List data = response.data;
      List<NState> states =
          List<NState>.from(data.map((e) => NState.fromJson(e)));
      return states;
    } on DioError catch (e) {
      debugDioError(error: e, functionName: "getAllStates");
      return Future.error(e);
    }
  }

  Future getAllProviderTypes() async {
    try {
      Response response = await AppApi.getAllProviderTypes();
      List data = response.data;
      List<HMOProviderType> types = List<HMOProviderType>.from(
          data.map((e) => HMOProviderType.fromJson(e)));
      return types;
    } on DioError catch (e) {
      debugDioError(error: e, functionName: "getAllProviderTypes");
      return Future.error(e);
    }
  }
}

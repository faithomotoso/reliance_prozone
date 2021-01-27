import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:reliance_hmo_test/business_logic/models/ActiveStatus.dart';
import 'package:reliance_hmo_test/business_logic/models/hmo_provider/HMOProvider.dart';
import 'package:reliance_hmo_test/business_logic/models/image/HMOProviderImage.dart';
import 'package:reliance_hmo_test/business_logic/models/image/HMOProviderType.dart';
import 'package:reliance_hmo_test/business_logic/models/state/NState.dart';
import 'package:reliance_hmo_test/services/api/AppApi.dart';
import 'package:reliance_hmo_test/ui/components/image_view/ProviderImagesManager.dart';
import 'package:reliance_hmo_test/ui/hmo_providers/hmo_providers_page.dart';
import 'package:reliance_hmo_test/utils/dialogs.dart';
import 'package:reliance_hmo_test/utils/snackbar.dart';
import 'package:reliance_hmo_test/utils/utils.dart';

class AppViewModel extends ChangeNotifier {
  bool loadOnPop = false;
  List<HMOProvider> allProviders;

  Future getAllProviders(
      {String nameSearchParam,
      HMOProviderType typeFilter,
      ActiveStatus statusFilter,
      NState stateFilter}) async {
    try {
      Response response = await AppApi.getAllProviders(
          nameSearchParam: nameSearchParam,
          typeFilterId: typeFilter?.id,
          statusFilter: statusFilter?.activeStatus,
      stateFilterId: stateFilter?.id);
      List data = response.data;
      allProviders =
          List<HMOProvider>.from(data.map((e) => HMOProvider.fromJson(e)));
      notifyListeners();
      // return providers;
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

  // Create or update a provider
  Future saveProvider({
    @required BuildContext context,
    @required GlobalKey<ScaffoldState> scaffoldKey,
    HMOProvider hmoProvider,
    String providerName,
    String providerDescription,
    String providerAddress,
    ActiveStatus selectedActiveStatus,
    HMOProviderType selectedProviderType,
    num rating,
    NState selectedState,
  }) async {
    showLoadingIndicator(context: context);

    try {
      hmoProvider == null
          ? await AppApi.createProvider(
              providerName: providerName,
              providerDescription: providerDescription,
              providerAddress: providerAddress,
              selectedActiveStatus: selectedActiveStatus,
              selectedProviderType: selectedProviderType,
              selectedState: selectedState,
              rating: rating)
          : await AppApi.updateProvider(
              hmoProvider: hmoProvider,
              providerName: providerName,
              providerDescription: providerDescription,
              providerAddress: providerAddress,
              selectedActiveStatus: selectedActiveStatus,
              selectedProviderType: selectedProviderType,
              selectedState: selectedState,
              rating: rating);

      Navigator.pop(context);

      loadOnPop = true;
      notifyListeners();

      showOkDialog(
          context: context,
          message: "Provider Saved",
          onOkButtonPressed: () {
            hmoProvider == null
                ? Navigator.popUntil(
                    context,
                    ModalRoute.withName(
                        HMOProvidersPage().runtimeType.toString()))
                : Navigator.pop(context);
          });
    } on DioError catch (e) {
      Navigator.pop(context);
      showDioErrorSnackbar(
          scaffoldKey: scaffoldKey, dioError: e, functionName: "saveProvider");
    }
  }

  Future uploadProviderImages(
      {@required HMOProvider hmoProvider,
      @required List<Asset> images,
      @required BuildContext context,
      @required GlobalKey<ScaffoldState> scaffoldKey}) async {
    showLoadingIndicator(context: context);

    try {
      Response response = await AppApi.uploadProviderImages(
          providerId: hmoProvider.id, images: images);

      // update the hmoProvider with new images
      List<HMOProviderImage> newImages = List<HMOProviderImage>.from(
          response.data.map((e) => HMOProviderImage.fromJson(e)));

      // await Future.delayed(Duration(seconds: 3));
      allProviders[allProviders
              .indexWhere((element) => element.id == hmoProvider.id)]
          .images
          .addAll(newImages);
      notifyListeners();

      Navigator.pop(context);

      showOkDialog(
          context: context,
          message: "Images uploaded successfully",
          onOkButtonPressed: () {
            Navigator.popUntil(
                context,
                ModalRoute.withName(
                    ProviderImagesManager(hmoProvider: hmoProvider)
                        .runtimeType
                        .toString()));
          });
    } on DioError catch (e) {
      Navigator.pop(context);
      showDioErrorSnackbar(
          scaffoldKey: scaffoldKey, dioError: e, functionName: "uploadImages");
    }
  }
}

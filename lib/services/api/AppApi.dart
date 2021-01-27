import 'dart:async';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:reliance_hmo_test/business_logic/models/ActiveStatus.dart';
import 'package:reliance_hmo_test/business_logic/models/hmo_provider/HMOProvider.dart';
import 'package:reliance_hmo_test/business_logic/models/image/HMOProviderType.dart';
import 'package:reliance_hmo_test/business_logic/models/state/NState.dart';
import 'package:reliance_hmo_test/services/api/AuthToken.dart';

class AppApi {
  static final Dio _dio = Dio(BaseOptions(
      baseUrl: "https://pro-zone.herokuapp.com",
      contentType: "application/json",
      headers: {"Authorization": "Bearer ${AuthToken.token}"}));

  static Future getAllProviders(
      {@required String nameSearchParam,
      String typeFilterId,
      String statusFilter,
      String stateFilterId}) {
    Map<String, dynamic> queryParameters = {};

    if (nameSearchParam.isNotEmpty)
      queryParameters["name_contains"] = nameSearchParam;

    if (typeFilterId != null)
      queryParameters["provider_type.id"] = typeFilterId;

    if (statusFilter != null)
      queryParameters["active_status_contains"] = statusFilter;

    if (stateFilterId != null)
      queryParameters["state.id"] = stateFilterId;

    return _dio.get("/providers?_sort=id", queryParameters: queryParameters);
  }

  static Future getAllStates() {
    return _dio.get("/states");
  }

  static Future getAllProviderTypes() {
    return _dio.get("/provider-types");
  }

  static Future createProvider({
    @required String providerName,
    @required String providerDescription,
    @required String providerAddress,
    @required ActiveStatus selectedActiveStatus,
    @required HMOProviderType selectedProviderType,
    @required NState selectedState,
    @required num rating,
  }) {
    return _dio.post("/providers", data: {
      "name": providerName,
      "description": providerDescription,
      "address": providerAddress,
      "rating": rating,
      "active_status": selectedActiveStatus.activeStatus,
      "provider_type": selectedProviderType.id,
      "state": selectedState.id
    });
  }

  static Future updateProvider({
    @required HMOProvider hmoProvider,
    @required String providerName,
    @required String providerDescription,
    @required String providerAddress,
    @required ActiveStatus selectedActiveStatus,
    @required HMOProviderType selectedProviderType,
    @required NState selectedState,
    @required num rating,
  }) {
    Map<String, dynamic> data = {};

    // Only update fields that are updated

    if (hmoProvider.name != providerName) data["name"] = providerName;

    if (hmoProvider.description != providerDescription)
      data["description"] = providerDescription;

    if (hmoProvider.address != providerAddress)
      data["address"] = providerAddress;

    if (hmoProvider.activeStatus.activeStatus !=
        selectedActiveStatus.activeStatus)
      data["active_status"] = selectedActiveStatus.activeStatus;

    if (hmoProvider.providerType.id != selectedProviderType.id)
      data["provider_type"] = selectedProviderType.id;

    if (hmoProvider.state.id != selectedState.id)
      data["state"] = selectedState.id;

    if (hmoProvider.rating != rating) data["rating"] = rating;

    return _dio.put("/providers/${hmoProvider.id}", data: data);
  }

  static Future uploadProviderImages(
      {@required String providerId, @required List<Asset> images}) async {
    List<MultipartFile> files = await _getMultipartFiles(images);

    FormData formData = FormData.fromMap({
      "ref": "provider",
      "refId": providerId,
      "field": "images",
    })
      ..files.addAll(files.map((e) => MapEntry("files", e)).toList());

    return _dio.post("/upload", data: formData);
  }

  static Future<List<MultipartFile>> _getMultipartFiles(
      List<Asset> images) async {
    List<MultipartFile> files = [];
    for (Asset asset in images) {
      ByteData byteData = await asset.getByteData();
      List<int> imageData = byteData.buffer.asUint8List();
      files.add(MultipartFile.fromBytes(imageData, filename: asset.name));
    }
    return files;
  }
}

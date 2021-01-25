import 'dart:async';
import 'package:dio/dio.dart';
import 'package:reliance_hmo_test/services/api/AuthToken.dart';

class AppApi {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://pro-zone.herokuapp.com",
      contentType: "application/json",
      headers: {
        "Authorization": "Bearer ${AuthToken.token}"
      }
    )
  );

  static Future getAllProviders() {
    return _dio.get("/providers");
  }

  static Future getAllStates() {
    return _dio.get("/states");
  }

  static Future getAllProviderTypes() {
    return _dio.get("/provider-types");
  }
}
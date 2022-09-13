import 'dart:convert';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_utils.dart';
import 'dart:async';
import 'dart:io';

HTTPManager httpManager = HTTPManager();

class HTTPManager {
  BaseOptions baseOptions = BaseOptions(
    baseUrl: ApiName.baseUrl,
    connectTimeout: 90000,
    receiveTimeout: 90000,
    contentType: Headers.jsonContentType,
    responseType: ResponseType.json,
  );



  /// ### Defines for call post type api.
  ///
  /// * [String] pass url for api.
  ///
  /// * [Map] pass Map<String, dynamic> json for request param.
  ///
  /// * [Options] pass header option value.
  ///
  /// * Return [dynamic] Future<dynamic> value will be return based on response.
  Future<dynamic> post({
    String url,
   dynamic param,
    Options options,
  }) async {
    try {

      baseOptions.baseUrl = ApiName.baseUrl;
      var optionsMain = Options(headers: {
        "token":ApiName.userToken,
        "contentType": "application/json"
        // contentType
      });

      debugPrint("url => $url");
      debugPrint("baseOptions.baseUrl => ${baseOptions.baseUrl}");
      debugPrint("param => $param");

      Dio dio = Dio(baseOptions);
      if (!kIsWeb) {
        (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
            (HttpClient client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        };
      }
      final response = await dio.post(
        url,
        data: param,
        options: optionsMain,
      );
      if(response != null) {
        debugPrint("Response => ${response.data.toString()}");
      }
      dynamic res = json.decode(response.data);
      return res;
    } on DioError catch (error) {

      return dioErrorHandle(error);
    }
  }

  Map<String, dynamic> dioErrorHandle(DioError error) {
    debugPrint(error.toString());
    switch (error.type) {
      case DioErrorType.response:
        debugPrint("error => ${error.response?.data.toString()}");
        return error.response?.data;
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        return {"success": false, "code": "request_time_out"};

      default:
        return {"success": false, "code": "connect_to_server_fail"};
    }
  }



}
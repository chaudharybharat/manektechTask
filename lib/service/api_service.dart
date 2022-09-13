import 'dart:async';
import 'package:manektechtask/service/api_utils.dart';
import '../model/product_list_main_res.dart';
import '../util/CommonKey.dart';
import '../util/common_method.dart';
import 'http_manager.dart';

class ApiService {
  ///Singleton factory
  static final ApiService instance = ApiService();

  /// ### Defines for call ProductList api.
  ///
  /// * [Map] pass Map<String, dynamic> json for request param.
  ///
  /// * Return [ProductListMainRes] Future<ProductListMainRes> value will be return based on response.
  Future<ProductListMainRes> callProductListApi({ Map<String, dynamic> param}) async {
    try {
      final result = await httpManager.post(
        url: ApiName.productList,
      );
      ProductListMainRes response =
      ProductListMainRes.fromJson(result);
      return response;
    } catch (error, stacktrace) {
      if (error
          .toString()
          .isNotEmpty) {
        CommonMethod.instance.toastMessage(StaticMessages.commonErrorMessage);
      } else {
        CommonMethod.instance.toastMessage(StaticMessages.internetNotAvailable);
      }
      return ProductListMainRes();
    }
  }

}

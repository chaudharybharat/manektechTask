import '../model/product_list_main_res.dart';
import '../service/api_service.dart';

class Repository {

  /// ### Defines for call product list api.
  ///
  /// * [Map] pass Map<String, dynamic> json for request param.
  ///
  /// * Return [ProductListMainRes] Future<ProductListMainRes> value will be return based on response.
  Future<ProductListMainRes> callProductListApi(
      { Map<String, dynamic> param}) async {
    try {
      return await ApiService.instance.callProductListApi(
          param: param,);
    } catch (e) {
      return ProductListMainRes();
    }
  }
}




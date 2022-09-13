import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:manektechtask/repository/repository.dart';
import '../../model/product_list_main_res.dart';
import '../../util/CommonKey.dart';
import 'bloc.dart';

class ProductListBloc
    extends Bloc<PriceListEvent, ProductListState> {
  ProductListBloc() : super(InitialProductListState());
  final Repository _repository = Repository();

  @override
  Stream<ProductListState> mapEventToState(event) {
    if (event is OnProductListEvent) {

      return _onProductListEventLogic(event);
    }
    return _onCommonFailEventLogic();
  }

  Stream<ProductListState> _onProductListEventLogic(OnProductListEvent event, 
    ) async* {
    yield OnProductListLoadingState();

    final ProductListMainRes result = await _repository.callProductListApi(param: event.param);
    if (result.status.toString() == "200") {
      try {
        //Notify loading to UI.
        yield OnProductListSuccessState(productListMainRes:  result);
      } catch (error, stacktrace) {
        //Notify loading to UI.
        yield OnProductListFailState(message: error.toString());
      }
    } else {
      //Notify loading to UI.
      yield OnProductListFailState(message: "fail api");
    }
  }


  Stream<ProductListState> _onCommonFailEventLogic() async* {
    yield OnProductListFailState(message: StaticMessages.commonErrorMessage);
  }



}

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../model/product_list_main_res.dart';

@immutable
abstract class ProductListState extends Equatable {}

class InitialProductListState extends ProductListState {
  @override
  List<Object> get props => [];
}

class OnProductListLoadingState extends ProductListState {
  @override
  List<Object> get props => [];
}

class OnProductListSuccessState extends ProductListState {
  final ProductListMainRes productListMainRes;

  OnProductListSuccessState({
     this.productListMainRes,
  });

  @override
  List<Object> get props => [productListMainRes];
}

class OnProductListFailState extends ProductListState {
  final String message;

  OnProductListFailState({ this.message});

  @override
  List<Object> get props => [message];
}


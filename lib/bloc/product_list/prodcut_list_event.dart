import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class PriceListEvent extends Equatable {}

class OnProductListEvent extends PriceListEvent {
  final Map<String, dynamic> param;
  OnProductListEvent({this.param});
  @override
  List<Object> get props => [param];

}

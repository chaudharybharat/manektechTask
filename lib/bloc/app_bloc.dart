///******************************************************************************
/// Copyright (C) 2021 Savvient Technologies Pty Ltd. All Rights Reserved.
///
/// This file is part of the Gymismo Project.
///
/// Any code files that form part of the Gymismo Project cannot be copied and/or distributed without the express written permission of Savvient Technologies Pty Ltd.
///
/// Note: Copyright will be assigned as instructed by the Client that commissioned the Gymismo Project upon payment in full of all amounts due. This file is developed by Savvient Technologies Pty Ltd as part of code standards trial/ context_menus by the Client
///******************************************************************************/
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manektechtask/bloc/product_list/product_list_bloc.dart';


class AppBloc {
  static final productListBloc = ProductListBloc();
  static final List<BlocProvider> providers = [
    BlocProvider<ProductListBloc>(
      create: (context) => productListBloc,
    ),

  ];
  static void dispose() {
    productListBloc.close();
  }

  ///Singleton factory
  static final AppBloc _instance = AppBloc._internal();

  factory AppBloc() {
    return _instance;
  }

  AppBloc._internal();
}

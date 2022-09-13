import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manektechtask/bloc/app_bloc.dart';
import 'package:manektechtask/model/cart_model.dart';
import 'package:manektechtask/model/product_list_main_res.dart';
import 'package:manektechtask/screen/my_cart_screen.dart';
import 'package:manektechtask/util/common_method.dart';
import 'package:shimmer/shimmer.dart';

import '../bloc/product_list/prodcut_list_event.dart';
import '../bloc/product_list/product_list_bloc.dart';
import '../bloc/product_list/product_list_state.dart';
import '../db/database_service.dart';
import '../model/prodcut_req.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({Key key}) : super(key: key);

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final List<ProductList> _productList = [];

  @override
  void initState() {
    _callProductList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductListBloc, ProductListState>(
        listener: (context, state) {
      _blockListenerHandler(state: state, context: context);
    }, builder: (context, state) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: _appBarWidget(),
        body: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          // Generate 100 widgets that display their index in the List.
          children: List.generate(_productList.length, (index) {
            return Card(
              color: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: CachedNetworkImage(
                        imageUrl: _productList[index].featuredImage ?? "",
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                )),
                          );
                        },
                        placeholder: (context, url) {
                          return Shimmer.fromColors(
                            baseColor: Theme.of(context).hoverColor,
                            highlightColor: Theme.of(context).highlightColor,
                            enabled: true,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                              ),
                              child: Image.network(
                                url,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.fill,
                              ),
                            ),
                          );
                        },
                        errorWidget: (context, url, error) {
                          return Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.all(10),
                      color: Colors.grey[100],
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            _productList[index].title ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                          GestureDetector(
                              onTap: () async {
                                CartModel cartModel = await _databaseService
                                    .getProductCart(_productList[index].id);
                                if (cartModel == null) {
                                  _addToCart(CartModel(
                                      id: _productList[index].id,
                                      price: _productList[index].price,
                                      featuredImage:
                                          _productList[index].featuredImage,
                                      description:
                                          _productList[index].description,
                                      title: _productList[index].title,
                                      quantity: 1));
                                } else {
                                  _addToCart(CartModel(
                                      id: _productList[index].id,
                                      price: _productList[index].price,
                                      featuredImage:
                                          _productList[index].featuredImage,
                                      description:
                                          _productList[index].description,
                                      title: _productList[index].title,
                                      quantity: cartModel.quantity + 1));
                                }
                              },
                              child: const Icon(
                                Icons.shopping_cart,
                                color: Colors.grey,
                              ))
                        ],
                      ))
                ],
              ),
            );
          }),
        ),
      );
    });
  }

  /// ### Defines for do logic for bloc listener.
  ///
  /// * [ProductListState] pass product list state from listener.
  ///
  /// * [BuildContext] pass BuildContext of current class.
  ///
  /// * Return nil or empty.
  void _blockListenerHandler({ProductListState state, BuildContext context}) {
    if (state is OnProductListLoadingState) {}
    if (state is OnProductListSuccessState) {
      if (state.productListMainRes != null) {
        List<ProductList> productDataList = state.productListMainRes.data;
        if (productDataList != null && productDataList.isNotEmpty) {
          _productList.clear();
          _productList.addAll(productDataList);
        }
      }
    }
    if (state is OnProductListFailState) {}
  }

  /// ### Defines for show appbar widget.
  ///
  /// * Return [AppBar] Widget type for PreferredSizeWidget [Widget] class type.
  PreferredSizeWidget _appBarWidget() {
    return AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Shopping Mall"),
        centerTitle: true,
        actions: [
          GestureDetector(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyCartScreen()),
                );
              },
              child: const Icon(
                Icons.shopping_cart,
                color: Colors.white,
              )),
          const SizedBox(
            width: 15,
          )
        ]);
  }

  /// ### Defines for call iap product price  list api.
  ///
  ///* Return nil or empty.
  void _callProductList() async {
    ProductReq productReq = ProductReq();
    productReq.page = "1";
    productReq.perPage = "15";
    AppBloc.productListBloc.add(OnProductListEvent(param: productReq.toJson()));
  }

  /// ### Defines for call iap product price  list api.
  ///
  ///* Return nil or empty.
  void _addToCart(CartModel cartModel) async {
    await _databaseService.insertProduct(cartModel).then((value) {
      if (value != null && value != -1) {
        CommonMethod.instance.toastMessage("added to cart");
      }
    });
  }
}

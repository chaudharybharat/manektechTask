import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../db/database_service.dart';
import '../model/cart_model.dart';

class MyCartScreen extends StatefulWidget {
  const MyCartScreen({Key key}) : super(key: key);

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  final List<CartModel> _productCartList = [];
  final DatabaseService _databaseService = DatabaseService();
  double _grandTotal = 0.0;

  @override
  void initState() {
    _initSetup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBarWidget(),
      body: Column(children: [_cartListBuilderWidget(), _bottomWidget()]),
    );
  }

  /// ### Defines for initial setup and do logic when screen load.
  ///
  /// * Return nil or empty.
  void _initSetup() async {
    _databaseService.productCart().then((value) {
      _productCartList.addAll(value);
      for (int i = 0; i < _productCartList.length; i++) {
        if (_productCartList[i].price != null &&
            _productCartList[i].price.toString().isNotEmpty) {
          _grandTotal = _grandTotal +
              int.parse(_productCartList[i].price) *
                  _productCartList[i].quantity;
        }
      }
      setState(() {});
    });
  }

  /// ### Defines for show appbar widget.
  ///
  /// * Return [AppBar] Widget type for PreferredSizeWidget [Widget] class type.
  PreferredSizeWidget _appBarWidget() {
    return AppBar(
        backgroundColor: Colors.blue,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_sharp,
            color: Colors.white,
          ),
        ),
        title: const Text("My Cart"),
        centerTitle: true,
        actions: const [
          Icon(
            Icons.shopping_cart,
            color: Colors.white,
          ),
          SizedBox(
            width: 15,
          )
        ]);
  }

  /// ### Defines for show label text and value  widget.
  ///
  /// * [String] pass label string.
  ///
  /// * [String] pass value string.
  ///
  /// * Return [AppBar] Widget type for PreferredSizeWidget [Widget] class type.
  Widget _labelValueWidget(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14),
        )
      ],
    );
  }

  /// ### Defines for show cart list builder  widget.
  ///
  /// * Return [ListView] Widget type ListView.builder [Widget] class type.
  Widget _cartListBuilderWidget() {
    return Expanded(
      child: _productCartList.isEmpty
          ? const Center(
              child: Text(
              "Empty cart !",
              style: TextStyle(fontSize: 16),
            ))
          : ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: _productCartList.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  //   color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 100,
                        alignment: Alignment.center,
                        child: CachedNetworkImage(
                          imageUrl: _productCartList[index].featuredImage ?? "",
                          imageBuilder: (context, imageProvider) {
                            return Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    topLeft: Radius.circular(10)),
                                color: Colors.black,
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                ),
                              ),
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
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          color: Colors.grey[100],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    _productCartList[index].title,
                                    style: const TextStyle(fontSize: 18),
                                  )),
                                  GestureDetector(
                                      onTap: () {
                                        if (_productCartList[index].quantity ==
                                            1) {
                                          _deleteCartProductConfirmDialog(
                                              context, index);
                                        } else {
                                          CartModel cartModelUpdate =
                                              _productCartList[index];
                                          cartModelUpdate.quantity--;
                                          _productCartList[index] =
                                              cartModelUpdate;
                                          _databaseService
                                              .updateCart(cartModelUpdate);
                                          int totalPrice = int.parse(
                                              _productCartList[index].price);
                                          _grandTotal =
                                              _grandTotal - totalPrice;
                                          setState(() {});
                                        }
                                      },
                                      child: const Icon(
                                        Icons.delete,
                                      ))
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              _labelValueWidget(
                                  "Price","\$"+ _productCartList[index].price),
                              const SizedBox(
                                height: 10,
                              ),
                              _labelValueWidget("Quantity",
                                  _productCartList[index].quantity.toString()),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }),
    );
  }

  /// ### Defines for show text widget.
  ///
  /// * [String] pass value string.
  ///
  /// * Return [Text] Widget type Text [Widget] class type.
  Widget _textWidget(String value) {
    return Text(
      value,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    );
  }

  /// ### Defines for show bottom widget total item and grand total.
  ///
  /// * Return [Align] Widget type Align [Widget] class type.
  _bottomWidget() {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(14),
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _textWidget("${"Total items: "}${_productCartList.length}"),
            _textWidget("${"Grand Total: "}${_grandTotal ?? 0}"),
          ],
        ),
      ),
    );
  }

  /// ### Defines for delete cart item confirm dialog.
  ///
  /// * [BuildContext] pass BuildContext of current class.
  ///
  /// * Return nil or empty.
  _deleteCartProductConfirmDialog(BuildContext context, int index) {
    // set up the button
    Widget okButton = GestureDetector(
      child: const Text("Delete"),
      onTap: () {
        _databaseService.deleteCart(_productCartList[index].id);
        int totalPrice = int.parse(_productCartList[index].price) *
            _productCartList[index].quantity;
        _grandTotal = _grandTotal - totalPrice;
        _productCartList.removeAt(index);
        setState(() {});
        Navigator.of(context).pop();
      },
    );
    Widget cancelButton = GestureDetector(
      child: const Text("Cancel"),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirm"),
      content: const Text("Do you want to delete product item from cart"),
      actions: [okButton, cancelButton],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

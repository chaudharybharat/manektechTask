import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';


class CommonMethod{
  /// Cached instance of [CommonMethod];
   static CommonMethod _instance;

  /// Returns an instance using the default [FirebaseApp].
  static CommonMethod get instance {
    _instance ??= CommonMethod();
    return _instance;
  }
  /// ### Defines for show message in toast, which is Flutter toast third party library.
  ///
  /// * [String] pass message for show in toast.
  ///
  /// * Return nil or empty.
  void toastMessage(String message) async {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 4,
        backgroundColor: Colors.black,
      );
    }


}
import 'package:flutter/material.dart';
import 'package:store_app/models/viewedRecently_model.dart';
import 'package:uuid/uuid.dart';

class ViewedRecentlyProvider with ChangeNotifier {
  final Map<String, ViewedRecentlymodel> ViewedRecentlyitems = {};
  Map<String, ViewedRecentlymodel> get getViewedRecentlyitems {
    return ViewedRecentlyitems;
  }

  void addProductToHistory({required String productid}) {
    ViewedRecentlyitems.putIfAbsent(
        productid,
        () => ViewedRecentlymodel(
              cartid: Uuid().v4(),
              productid: productid,
            ));
    notifyListeners();
  }
}

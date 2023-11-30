import 'package:flutter/material.dart';

class cartmodel with ChangeNotifier {
  String cartid, productid;
  final int quantity;

  cartmodel(
      {required this.cartid, required this.productid, required this.quantity});
}

import 'package:flutter/material.dart';

class CartModel with ChangeNotifier {
  String cartid, productid;
  final int quantity;

  CartModel(
      {required this.cartid, required this.productid, required this.quantity});
}

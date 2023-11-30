import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel with ChangeNotifier {
  final String userId,
      orderid,
      productTitle,
      productPrice,
      username,
      productid,
      productImage,
      totalprice,
      productQuantity;
  Timestamp? ordertime;

  OrderModel({
    required this.totalprice,
    required this.orderid,
    required this.userId,
    required this.productTitle,
    required this.productPrice,
    required this.username,
    required this.productid,
    required this.productImage,
    required this.productQuantity,
    required this.ordertime,
  });
}

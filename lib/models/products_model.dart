import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel with ChangeNotifier {
  final String productId,
      productTitle,
      productPrice,
      productCategory,
      productDescription,
      productImage,
      productQuantity;
  Timestamp? createdat;

  ProductModel(
      {required this.productId,
      required this.productTitle,
      required this.productPrice,
      required this.productCategory,
      required this.productDescription,
      required this.productImage,
      required this.productQuantity,
      this.createdat});
  factory ProductModel.fromfirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ProductModel(
        createdat: data["createdAt"],
        productId: data["productId"],
        productTitle: data["productTitle"],
        productPrice: data["productPrice"],
        productCategory: data["productCategory"],
        productDescription: data["productDescription"],
        productImage: data["productImage"],
        productQuantity: data["productQuantity"]);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store_app/models/order_model.dart';

class OrderProvider with ChangeNotifier {
  List<OrderModel> orderslist = [];
  List<OrderModel> get getorders {
    return orderslist;
  }

  Future<List<OrderModel>> fetchorders() async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    var uid = user!.uid;
    try {
      orderslist.clear();
      await FirebaseFirestore.instance
          .collection("orders")
          .get()
          .then((ordersSnapshot) {
        for (var element in ordersSnapshot.docs) {
          orderslist.insert(
              0,
              OrderModel(
                  totalprice: element.get("totalprice").toString(),
                  orderid: element.get("orderid"),
                  userId: element.get("userId"),
                  productTitle: element.get("productTitle"),
                  productPrice: element.get("productPrice").toString(),
                  username: element.get("username"),
                  productid: element.get("productid"),
                  productImage: element.get("productImage"),
                  productQuantity: element.get("productQuantity").toString(),
                  ordertime: element.get("ordertime")));
        }
      });
      return orderslist;
    } catch (e) {
      rethrow;
    }
  }
}

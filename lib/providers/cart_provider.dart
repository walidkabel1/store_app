import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:store_app/models/cart_model.dart';
import 'package:store_app/models/products_model.dart';
import 'package:store_app/providers/product_provider.dart';
import 'package:store_app/services/myapp_methods.dart';
import 'package:uuid/uuid.dart';

class CartProvider with ChangeNotifier {
  final Map<String, cartmodel> cartitems = {};
  Map<String, cartmodel> get getcartitems {
    return cartitems;
  }

  // firebase methods
  final usersDB = FirebaseFirestore.instance.collection("users");
  final auth = FirebaseAuth.instance;

  Future<void> addtocartfirebase(
      {required String productid,
      required int quantity,
      required BuildContext context}) async {
    final User? user = auth.currentUser;
    if (user == null) {
      MyappMethods.ShowErrorOrWarningDialog(
          context: context,
          subtitle: "no user found",
          function: () {
            Navigator.pop(context);
          });
      return;
    }
    final uid = user.uid;
    final cartid = const Uuid().v4();
    try {
      usersDB.doc(uid).update({
        "usercart": FieldValue.arrayUnion([
          {
            "cartid": cartid,
            "productid": productid,
            "quantity": quantity,
          }
        ])
      });
      await fetchcart();
      Fluttertoast.showToast(msg: "item has been added to cart");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchcart() async {
    final User? user = auth.currentUser;
    if (user == null) {
      cartitems.clear();
      return;
    }
    try {
      final userdoc = await usersDB.doc(user.uid).get();
      final data = userdoc.data();
      if (data == null || !data.containsKey("usercart")) {
        return;
      }
      final lenght = userdoc.get("usercart").length;
      for (int index = 0; index < lenght; index++) {
        cartitems.putIfAbsent(
            userdoc.get("usercart")[index]["productid"],
            () => cartmodel(
                cartid: userdoc.get("usercart")[index]["cartid"],
                productid: userdoc.get("usercart")[index]["productid"],
                quantity: userdoc.get("usercart")[index]["quantity"]));
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> clearcartfromfirebase() async {
    final User? user = auth.currentUser;
    try {
      await usersDB.doc(user!.uid).update({"usercart": []});
      cartitems.clear();
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> removeitemfromcartfirebase(
      {required String productid,
      required String cartid,
      required int quantity}) async {
    final User? user = auth.currentUser;
    try {
      await usersDB.doc(user!.uid).update({
        "usercart": FieldValue.arrayRemove([
          {"productid": productid, "cartid": cartid, "quantity": quantity}
        ])
      });
      cartitems.remove(productid);
      await fetchcart();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  bool IsProductInCart({required String productid}) {
    return cartitems.containsKey(productid);
  }

  void addProductToCart({required String productid}) {
    cartitems.putIfAbsent(
        productid,
        () =>
            cartmodel(cartid: Uuid().v4(), productid: productid, quantity: 1));
    notifyListeners();
  }

  void UpdateQuantity({required String productid, required int quantity}) {
    cartitems.update(
        productid,
        (item) => cartmodel(
            cartid: item.cartid, productid: productid, quantity: quantity));
    notifyListeners();
  }

  void deleteproduct({required String productid}) {
    cartitems.remove(productid);
    notifyListeners();
  }

  void clearcart() {
    cartitems.clear();
    notifyListeners();
  }

  double CheckOutPrice({required ProductProvider productprovider}) {
    double totalprice = 0.0;
    cartitems.forEach((key, value) {
      final ProductModel? getcurrentproduct =
          productprovider.FindByProductId(productid: value.productid);
      if (getcurrentproduct == null) {
        totalprice += 0;
      } else {
        totalprice +=
            double.parse(getcurrentproduct.productPrice) * value.quantity;
      }
    });
    return totalprice;
  }

  void addProductTowishlist({required String productid}) {
    cartitems.putIfAbsent(
        productid,
        () =>
            cartmodel(cartid: Uuid().v4(), productid: productid, quantity: 1));
    notifyListeners();
  }
}

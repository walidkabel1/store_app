import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:store_app/models/wishlist_model.dart';
import 'package:store_app/services/myapp_methods.dart';
import 'package:uuid/uuid.dart';

class WishlistProvider with ChangeNotifier {
  final Map<String, wishlistmodel> wishlistitems = {};
  Map<String, wishlistmodel> get getwishlistitems {
    return wishlistitems;
  }

  final usersDB = FirebaseFirestore.instance.collection("users");
  final auth = FirebaseAuth.instance;

  Future<void> addtowishlistfirebase(
      {required String productid, required BuildContext context}) async {
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
    final wishlistid = const Uuid().v4();
    try {
      usersDB.doc(uid).update({
        "userwish": FieldValue.arrayUnion([
          {
            "wishlistid": wishlistid,
            "productid": productid,
          }
        ])
      });
      await fetchwishlist();
      Fluttertoast.showToast(msg: "item has been added to wishlist");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchwishlist() async {
    final User? user = auth.currentUser;
    if (user == null) {
      wishlistitems.clear();
      return;
    }
    try {
      final userdoc = await usersDB.doc(user.uid).get();
      final data = userdoc.data();
      if (data == null || !data.containsKey("userwish")) {
        return;
      }
      final lenght = userdoc.get("userwish").length;
      for (int index = 0; index < lenght; index++) {
        wishlistitems.putIfAbsent(
            userdoc.get("userwish")[index]["productid"],
            () => wishlistmodel(
                  wishlistid: userdoc.get("userwish")[index]["wishlistid"],
                  productid: userdoc.get("userwish")[index]["productid"],
                ));
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> clearwishlistfromfirebase() async {
    final User? user = auth.currentUser;
    try {
      await usersDB.doc(user!.uid).update({"userwish": []});
      wishlistitems.clear();
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> removeitemfromwishlistfirebase({
    required String productid,
    required String wishlistid,
  }) async {
    final User? user = auth.currentUser;
    try {
      await usersDB.doc(user!.uid).update({
        "userwish": FieldValue.arrayRemove([
          {
            "productid": productid,
            "wishlistid": wishlistid,
          }
        ])
      });
      wishlistitems.remove(productid);
      await fetchwishlist();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  bool IsProductInwishlist({required String productid}) {
    return wishlistitems.containsKey(productid);
  }

  void addOrRemoveProducttowishlist({required String productid}) {
    if (wishlistitems.containsKey(productid)) {
      wishlistitems.remove(productid);
    } else {
      wishlistitems.putIfAbsent(
          productid,
          () => wishlistmodel(
                wishlistid: Uuid().v4(),
                productid: productid,
              ));
    }
    notifyListeners();
  }

  void clearwishlist() {
    wishlistitems.clear();
    notifyListeners();
  }
}

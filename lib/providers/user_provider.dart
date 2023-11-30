import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store_app/models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? usermodel;
  UserModel? get getUserModel {
    return usermodel;
  }

  Future<UserModel?> fetchUserInfo() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) {
      return null;
    }
    var uid = user.uid;
    try {
      final userdoc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      final userdocic = userdoc.data();
      usermodel = UserModel(
          userid: userdoc.get("userid"),
          username: userdoc.get("username"),
          userimage: userdoc.get("userimage"),
          useremail: userdoc.get("useremail"),
          createdat: userdoc.get("createdat"),
          usercart:
              userdocic!.containsKey("usercart") ? userdoc.get("usercart") : [],
          userwish:
              userdocic.containsKey("userwish") ? userdoc.get("userwish") : []);
      return usermodel;
    } on FirebaseException catch (e) {
      throw e.message.toString();
    } catch (e) {
      rethrow;
    }
  }
}

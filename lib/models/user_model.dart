import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  final String userid, username, userimage, useremail;
  final Timestamp createdat;
  final List usercart, userwish;

  UserModel(
      {required this.userid,
      required this.username,
      required this.userimage,
      required this.useremail,
      required this.createdat,
      required this.usercart,
      required this.userwish});
}

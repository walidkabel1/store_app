import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';
import 'package:store_app/root_screen.dart';
import 'package:store_app/services/myapp_methods.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({
    super.key,
  });

  Future<void> googleSignIn({required BuildContext context}) async {
    final googleSignin = GoogleSignIn();
    final googleaccount = await GoogleSignIn().signIn();

    if (googleaccount != null) {
      final googleAuth = await googleaccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          final authResults = await FirebaseAuth.instance
              .signInWithCredential(GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          ));
          if (authResults.additionalUserInfo!.isNewUser) {
            await FirebaseFirestore.instance
                .collection("users")
                .doc(authResults.user!.uid)
                .set({
              "userid": authResults.user!.uid,
              "username": authResults.user!.displayName,
              "userimage": authResults.user!.photoURL,
              "useremail": authResults.user!.email,
              "createdat": Timestamp.now(),
              "usercart": [],
              "userwish": [],
            });
          }
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await Navigator.of(context).pushReplacementNamed(rootscreen.route);
          });
        } on FirebaseException catch (error) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            MyappMethods.ShowErrorOrWarningDialog(
                context: context,
                subtitle: "an error occured ${error.message}",
                function: () {});
          });
        } catch (error) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            MyappMethods.ShowErrorOrWarningDialog(
                context: context,
                subtitle: "an error occured $error",
                function: () {});
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(12),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
      ),
      icon: const Icon(
        Ionicons.logo_google,
        color: Colors.red,
      ),
      label: const Text(
        "Sign in with google",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
      ),
      onPressed: () async {
        await googleSignIn(context: context);
      },
    );
  }
}

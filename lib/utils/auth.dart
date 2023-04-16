import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;

class Authentication {
  static void showSnackBar(BuildContext context, {required String content}) {
    final deviceHeight = MediaQuery.of(context).size.height;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      showCloseIcon: true,
      margin: EdgeInsets.only(left: 8, right: 8, bottom: (deviceHeight - 100)),
      content: Text(
        content,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    ));
  }

  static void initializeFirebase({
    required BuildContext context,
  }) {
    Firebase.initializeApp().then((firebaseApp) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get()
            .then((doc) {
          if (doc.exists) {
            final data = doc.data();
            if (data!['role'] == "member") {
              Navigator.pushReplacementNamed(
                context,
                "member/home",
              );
            } else if (data['role'] == "staff") {
              Navigator.pushReplacementNamed(context, "staff/home");
            } else if (data['role'] == "student") {
              Navigator.pushReplacementNamed(context, "student/home");
            } else if (data['role'] == "admin") {
              Navigator.pushReplacementNamed(context, "admin/home");
            }
          }
        });
      }
    });
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn =
          GoogleSignIn(hostedDomain: kDebugMode ? "bxscience.edu" : null);

      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            Authentication.showSnackBar(
              context,
              content: 'The account already exists with a different credential',
            );
          } else if (e.code == 'invalid-credential') {
            Authentication.showSnackBar(
              context,
              content: 'Error occurred while accessing credentials. Try again.',
            );
          }
        } catch (e) {
          Authentication.showSnackBar(
            context,
            content: 'Error occurred using Google Sign In. Try again.',
          );
        }
      }
    }

    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      Authentication.showSnackBar(
        context,
        content: 'Error signing out. Try again.',
      );
    }
  }
}

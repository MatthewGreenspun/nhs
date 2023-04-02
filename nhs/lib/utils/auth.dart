import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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

  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.pushNamed(context, "home");
    }

    return firebaseApp;
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
          GoogleSignIn(hostedDomain: "bxscience.edu");

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

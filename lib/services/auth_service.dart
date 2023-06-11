import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;

enum UserType { notSignedIn, member, staff, student, admin }

class AuthService {
  final _user = FirebaseAuth.instance.currentUser;
  final _fbAuth = FirebaseAuth.instance;
  final _fbDB = FirebaseFirestore.instance;

  Future<UserType> getRole(User newUser) async {
    final doc = await _fbDB.collection("roles").doc(newUser.email).get();
    if (!doc.exists) {
      return UserType.student;
    }
    final role = doc.data()!['role'] as String;
    if (role == "member") {
      return UserType.member;
    } else if (role == "staff") {
      return UserType.staff;
    } else if (role == "admin") {
      return UserType.admin;
    } else {
      return UserType.student;
    }
  }

  Future<UserType> getUserType([User? newUser]) async {
    if (newUser == null && _user == null) return UserType.notSignedIn;
    final user = newUser ?? _user;
    final doc = await _fbDB.collection("users").doc(user!.uid).get();
    if (!doc.exists) {
      if (newUser == null) return UserType.notSignedIn;
      throw getRole(newUser);
    }
    final data = doc.data();
    if (data!['role'] == "member") {
      return UserType.member;
    } else if (data['role'] == "staff") {
      return UserType.staff;
    } else if (data['role'] == "student") {
      return UserType.student;
    } else if (data['role'] == "admin") {
      return UserType.admin;
    } else {
      return UserType.notSignedIn;
    }
  }

  Future<UserType> signInWithGoogle() async {
    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();
      final UserCredential userCredential =
          await _fbAuth.signInWithPopup(authProvider);
      return (await getUserType(userCredential.user));
    }

    final GoogleSignIn googleSignIn =
        GoogleSignIn(hostedDomain: kDebugMode ? null : "bxscience.edu");

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount == null) return UserType.notSignedIn;
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final UserCredential userCredential =
        await _fbAuth.signInWithCredential(credential);
    return (await getUserType(userCredential.user));
  }

  Future<void> signOut() async {
    return _fbAuth.signOut();
  }
}

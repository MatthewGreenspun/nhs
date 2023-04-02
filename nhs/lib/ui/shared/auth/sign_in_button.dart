import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import '../../../utils/auth.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key});
  @override
  GoogleSignInButtonState createState() => GoogleSignInButtonState();
}

class GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              onPressed: () {
                setState(() {
                  _isSigningIn = true;
                });
                Authentication.signInWithGoogle(context: context)
                    .then((User? user) {
                  if (user != null && user.email != null) {
                    if (user.email!.endsWith("@bxscience.edu")) {
                      FirebaseFirestore.instance
                          .doc("users/${user.uid}")
                          .get()
                          .then((doc) {
                        if (!doc.exists) {
                          FirebaseFirestore.instance
                              .doc("roles/${user.email}")
                              .get()
                              .then((doc) {
                            if (!doc.exists) {
                              Navigator.pushNamed(context, "student/home");
                            } else {
                              final data = doc.data();
                              if (data!['role'] == "member") {
                                Navigator.pushNamed(
                                    context, "member/account-setup");
                              } else if (data['role'] == "staff") {
                                Navigator.pushNamed(
                                    context, "staff/account-setup");
                              } else if (data['role'] == "student") {
                                Navigator.pushNamed(
                                    context, "student/account-setup");
                              } else if (data['role'] == "admin") {
                                Navigator.pushNamed(
                                    context, "admin/account-setup");
                              }
                            }
                          });
                        } else {
                          final data = doc.data();
                          if (data!['role'] == "member") {
                            Navigator.pushReplacementNamed(
                                context, "member/home");
                          } else if (data['role'] == "staff") {
                            Navigator.pushReplacementNamed(
                                context, "staff/home");
                          } else if (data['role'] == "student") {
                            Navigator.pushReplacementNamed(
                                context, "student/home");
                          } else if (data['role'] == "admin") {
                            Navigator.pushReplacementNamed(
                                context, "admin/home");
                          }
                        }
                      });
                    } else {
                      Authentication.showSnackBar(context,
                          content: "use your Bronx Science email.");
                    }
                  }
                }).then((value) {
                  setState(() {
                    _isSigningIn = false;
                  });
                });
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      "assets/logos/google.png",
                      height: 35.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

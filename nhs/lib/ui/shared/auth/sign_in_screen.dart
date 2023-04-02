import 'package:flutter/material.dart';
import '../../../utils/auth.dart';
import "./sign_in_button.dart";
import 'package:firebase_core/firebase_core.dart';
import '../../../firebase_options.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'National Honor Society',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Flexible(
                      flex: 1,
                      child: Image.asset(
                        'assets/logos/bronx_science_transparent.png',
                        height: 160,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              FutureBuilder(
                future: Firebase.initializeApp(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Error initializing Firebase');
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return GoogleSignInButton();
                  }
                  return const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.orange,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

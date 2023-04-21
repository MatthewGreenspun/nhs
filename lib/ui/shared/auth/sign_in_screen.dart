import 'package:flutter/material.dart';
import "./sign_in_button.dart";
import "package:google_fonts/google_fonts.dart";

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

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
                    Text('National Honor Society',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.oswald(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                    Flexible(
                      flex: 1,
                      child: Image.asset(
                        'assets/logos/bronx_science_transparent.png',
                        height: 250,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const GoogleSignInButton()
            ],
          ),
        ),
      ),
    );
  }
}

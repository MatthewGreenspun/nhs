import 'package:flutter/material.dart';
import 'package:nhs/services/auth_service.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({super.key});
  @override
  GoogleSignInButtonState createState() => GoogleSignInButtonState();
}

class GoogleSignInButtonState extends State<GoogleSignInButton> {
  final _authService = AuthService();
  bool _isSigningIn = false;

  void navigate(String role, bool isNew) {
    if (context.mounted) {
      Navigator.pushReplacementNamed(
          context, "$role/${isNew ? "account-setup" : "home"}");
    }
  }

  void onPressed() async {
    setState(() {
      _isSigningIn = true;
    });
    try {
      final userType = await _authService.signInWithGoogle();
      if (userType == UserType.member) {
        navigate("member", false);
      } else if (userType == UserType.staff) {
        navigate("staff", false);
      } else if (userType == UserType.student) {
        navigate("student", false);
      } else if (userType == UserType.admin) {
        navigate("admin", false);
      }
    } on Future<UserType> catch (userType) {
      if (await userType == UserType.member) {
        navigate("member", true);
      } else if (await userType == UserType.staff) {
        navigate("staff", true);
      } else if (await userType == UserType.student) {
        navigate("student", true);
      } else if (await userType == UserType.admin) {
        navigate("admin", true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isSigningIn) return const CircularProgressIndicator();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: FilledButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.primary.withAlpha(200)),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8),
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
                    color: Colors.black,
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

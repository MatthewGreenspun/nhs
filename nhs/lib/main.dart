import 'package:flutter/material.dart';
import "package:nhs/ui/member/account_setup/account_setup.dart";
import "./ui/shared/auth/sign_in_screen.dart";
import "./ui/member/home/home.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        routes: {
          "admin/home": (context) => Scaffold(),
          "member/home": (context) => const MemberHome(),
          "member/account-setup": (context) => const MemberAccountSetup(),
          "staff/home": (context) => Scaffold(),
          "student/home": (context) => Scaffold(),
          "sign-in": (context) => const SignInScreen(),
        },
        home: const SignInScreen());
  }
}

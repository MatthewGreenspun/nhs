import 'package:flutter/material.dart';
import "package:provider/provider.dart";
import "./ui/member/account_setup/account_setup.dart";
import "./ui/shared/auth/sign_in_screen.dart";
import "./ui/member/scaffold.dart";
import "./stores/member.store.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<MemberStore>(
              create: (context) => MemberStore()..listenForUpdates())
        ],
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
                useMaterial3: true,
                colorScheme: const ColorScheme.light(
                  primary: Colors.green,
                ),
                primarySwatch: Colors.green,
                appBarTheme: const AppBarTheme(backgroundColor: Colors.green)),
            routes: {
              "admin/home": (context) => Scaffold(),
              "member/home": (context) => const MemberScaffold(),
              "member/account-setup": (context) => const MemberAccountSetup(),
              "staff/home": (context) => Scaffold(),
              "student/home": (context) => Scaffold(),
              "sign-in": (context) => const SignInScreen(),
            },
            home: const SignInScreen()));
  }
}

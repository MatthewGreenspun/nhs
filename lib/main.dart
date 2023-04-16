import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";
import "package:nhs/ui/student/account_setup/account_setup.dart";
import "package:nhs/ui/student/scaffold.dart";
import "./firebase_options.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:cloud_functions/cloud_functions.dart";
import "package:flutter/foundation.dart";
import "./ui/member/account_setup/account_setup.dart";
import "./ui/shared/auth/sign_in_screen.dart";
import "./ui/member/scaffold.dart";
import "./ui/staff/scaffold.dart";
import "./ui/staff/account_setup/account_setup.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    print("using emulator");
    try {
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
      FirebaseFunctions.instance.useFunctionsEmulator("localhost", 5001);
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'NHS',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: const ColorScheme.light(
            primary: Colors.green,
          ),
          primarySwatch: Colors.green,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.green),
        ),
        routes: {
          "admin/home": (context) => Scaffold(),
          "member/home": (context) => const MemberScaffold(),
          "member/account-setup": (context) => const MemberAccountSetup(),
          "staff/home": (context) => const StaffScaffold(),
          "staff/account-setup": (context) => const StaffAccountSetup(),
          "student/home": (context) => const StudentScaffold(),
          "student/account-setup": (context) => const StudentAccountSetup(),
          "sign-in": (context) => const SignInScreen(),
        },
        home: const SignInScreen());
  }
}

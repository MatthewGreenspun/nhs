import 'package:flutter/material.dart';
import "package:firebase_core/firebase_core.dart";
import "package:nhs/services/auth_service.dart";
import "package:nhs/services/ui_service.dart";
import "package:nhs/ui/admin/account_setup.dart";
import "package:nhs/ui/admin/scaffold.dart";
import "package:nhs/ui/shared/auth/pre_sign_in.dart";
import "package:nhs/ui/student/account_setup/account_setup.dart";
import "package:nhs/ui/student/scaffold.dart";
import "package:provider/provider.dart";
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

  runApp(ChangeNotifierProvider(
      create: (context) => UIService()..readSavedPreferences(),
      child: const NHSApp()));
}

class NHSApp extends StatelessWidget {
  const NHSApp({super.key});
  static const _initialScreens = {
    UserType.notSignedIn: SignInScreen(),
    UserType.member: MemberScaffold(),
    UserType.staff: StaffScaffold(),
    UserType.student: StudentScaffold(),
    UserType.admin: AdminScaffold()
  };

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    return Consumer<UIService>(
      builder: (context, uiService, child) => MaterialApp(
        title: 'NHS',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: uiService.colorScheme,
          appBarTheme: AppBarTheme(backgroundColor: uiService.primaryColor),
        ),
        routes: {
          "admin/home": (context) => const AdminScaffold(),
          "admin/account-setup": (context) => const AdminAccountSetup(),
          "member/home": (context) => const MemberScaffold(),
          "member/account-setup": (context) => const MemberAccountSetup(),
          "staff/home": (context) => const StaffScaffold(),
          "staff/account-setup": (context) => const StaffAccountSetup(),
          "student/home": (context) => const StudentScaffold(),
          "student/account-setup": (context) => const StudentAccountSetup(),
          "sign-in": (context) => const SignInScreen(),
        },
        home: child,
      ), // Using child prevents the entire widget tree from rebuilding
      child: FutureBuilder(
        future: authService.getUserType(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == null) return const SignInScreen();
            return _initialScreens[snapshot.data]!;
          }
          return const PreSignIn();
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:nhs/ui/member/account_setup/free_periods.dart";
import "package:nhs/ui/member/account_setup/tutoring_subjects.dart";
import "../../../models/index.dart";
import "./basic_info.dart";

class MemberAccountSetup extends StatefulWidget {
  const MemberAccountSetup({super.key});

  @override
  State<MemberAccountSetup> createState() => _MemberAccountSetupState();
}

class _MemberAccountSetupState extends State<MemberAccountSetup> {
  final member =
      Member(name: "", email: "", graduationYear: DateTime.now().year + 1);
  final PageController _pageController = PageController();
  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser!;
    member.name = user.displayName!;
    member.email = user.email!;
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            BasicInfo(member: member, pageController: _pageController),
            TutoringSubjects(member: member, pageController: _pageController),
            FreePeriods(member: member)
          ]),
    );
  }
}

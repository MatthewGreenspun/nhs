import "dart:async";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:nhs/models/index.dart";
import "package:nhs/ui/member/home/home.dart";
import "./opportunities/opportunities.dart";
import "../shared/appbar/appbar.dart";
import "./settings/settings.dart";

class MemberScaffold extends StatefulWidget {
  const MemberScaffold({super.key});

  @override
  State<MemberScaffold> createState() => _MemberScaffoldState();
}

class _MemberScaffoldState extends State<MemberScaffold> {
  final _user = FirebaseAuth.instance.currentUser!;
  late StreamSubscription _memberSub;
  late StreamSubscription _opportunitiesSub;
  Member? _member;
  int _currentIndex = 0;

  @override
  void initState() {
    final memberStream = FirebaseFirestore.instance
        .collection("users")
        .doc(_user.uid)
        .snapshots();
    _memberSub = memberStream.listen((event) {
      setState(() {
        _member = Member.fromJson(event.data()!);
      });
      final opportunitiesStream =
          event.reference.collection("opportunities").snapshots();
      _opportunitiesSub = opportunitiesStream.listen((event) {
        setState(() {
          _member!.opportunities = event.docs
              .map((doc) => ServiceSnippet.fromJson(doc.data()))
              .toList();
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _memberSub.cancel();
    _opportunitiesSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_member == null) {
      return const Center(child: CircularProgressIndicator());
    }
    Widget page;
    if (_currentIndex == 0) {
      page = MemberHome(member: _member);
    } else if (_currentIndex == 1) {
      page = Opportunities(
        member: _member,
      );
    } else {
      page = MemberSettings(member: _member);
    }

    return Scaffold(
      appBar: _currentIndex == 1 // Opportunities Page
          ? null
          : const NHSAppBar(),
      body: page,
      bottomNavigationBar: BottomNavigationBar(
          onTap: (idx) {
            setState(() {
              _currentIndex = idx;
            });
          },
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.workspace_premium_outlined),
                label: "Opportunities"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined), label: "Settings"),
          ]),
    );
  }
}

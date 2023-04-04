import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:nhs/ui/member/home/home.dart";
import "package:provider/provider.dart";
import "../../stores/member.store.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:google_fonts/google_fonts.dart";
import "./opportunities/opportunities.dart";
import "./settings/settings.dart";
import "../shared/appbar/appbar.dart";

class MemberScaffold extends StatefulWidget {
  const MemberScaffold({super.key});

  @override
  State<MemberScaffold> createState() => _MemberScaffoldState();
}

class _MemberScaffoldState extends State<MemberScaffold> {
  int _currentIndex = 0;
  final _pages = const [MemberHome(), Opportunities(), Settings()];

  @override
  Widget build(BuildContext context) {
    return Consumer<MemberStore>(
        builder: (_, memberStore, __) => Observer(
            builder: (context) => memberStore.member == null
                ? const Center(child: CircularProgressIndicator())
                : Scaffold(
                    appBar: _currentIndex == 1 // Opportunities Page
                        ? null
                        : const NHSAppBar(),
                    body: _pages[_currentIndex],
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
                              icon: Icon(Icons.settings_outlined),
                              label: "Settings"),
                        ]),
                  )));
  }
}

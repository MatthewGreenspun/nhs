import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:nhs/ui/member/home/home.dart";
import "package:provider/provider.dart";
import "../../stores/member.store.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:google_fonts/google_fonts.dart";
import "./opportunities/opportunities.dart";
import "./settings/settings.dart";

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
    final user = FirebaseAuth.instance.currentUser!;
    return Consumer<MemberStore>(
        builder: (_, memberStore, __) => Observer(
            builder: (context) => memberStore.member == null
                ? const Center(child: CircularProgressIndicator())
                : Scaffold(
                    appBar: _currentIndex == 1
                        ? null
                        : AppBar(
                            title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "National Honor Society",
                                    style: GoogleFonts.francoisOne(
                                        color: Colors.white),
                                  ),
                                  CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(user.photoURL!))
                                ]),
                          ),
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
                              icon: Icon(Icons.home), label: "Home"),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.settings_accessibility),
                              label: "Opportunities"),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.settings), label: "Settings"),
                        ]),
                  )));
  }
}

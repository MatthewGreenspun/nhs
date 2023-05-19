import "dart:async";
import "package:flutter/material.dart";
import "package:nhs/models/index.dart";
import "package:nhs/services/member_service.dart";
import "package:nhs/services/ui_service.dart";
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
  late StreamSubscription _memberSub;
  Member? _member;
  int _currentIndex = 0;

  @override
  void initState() {
    MemberService.stream.listen((event) {
      setState(() {
        _member = event;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _memberSub.cancel();
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
    final navigationIsVertical = UIService.isBigScreen(context);

    return Scaffold(
      appBar: const NHSAppBar(),
      body: navigationIsVertical
          ? Row(
              children: [
                NavigationRail(
                    groupAlignment: -1,
                    onDestinationSelected: (idx) {
                      setState(() {
                        _currentIndex = idx;
                      });
                    },
                    selectedIndex: _currentIndex,
                    labelType: NavigationRailLabelType.all,
                    destinations: const [
                      NavigationRailDestination(
                          padding: EdgeInsets.all(16),
                          icon: Icon(Icons.home_outlined),
                          selectedIcon: Icon(Icons.home),
                          label: Text("Home")),
                      NavigationRailDestination(
                          padding: EdgeInsets.all(16),
                          icon: Icon(Icons.workspace_premium_outlined),
                          selectedIcon: Icon(Icons.workspace_premium),
                          label: Text("Opportunities")),
                      NavigationRailDestination(
                          padding: EdgeInsets.all(16),
                          icon: Icon(Icons.settings_outlined),
                          selectedIcon: Icon(Icons.settings),
                          label: Text("Settings")),
                    ]),
                Expanded(child: page)
              ],
            )
          : page,
      bottomNavigationBar: navigationIsVertical
          ? null
          : NavigationBar(
              onDestinationSelected: (idx) {
                setState(() {
                  _currentIndex = idx;
                });
              },
              selectedIndex: _currentIndex,
              destinations: const [
                  NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: "Home"),
                  NavigationDestination(
                      icon: Icon(Icons.workspace_premium_outlined),
                      selectedIcon: Icon(Icons.workspace_premium),
                      label: "Opportunities"),
                  NavigationDestination(
                      icon: Icon(Icons.settings_outlined),
                      selectedIcon: Icon(Icons.settings),
                      label: "Settings"),
                ]),
    );
  }
}

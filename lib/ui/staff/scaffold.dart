import "dart:async";
import "package:flutter/material.dart";
import "package:nhs/services/staff_student_service.dart";
import "package:nhs/services/ui_service.dart";
import "package:nhs/ui/staff/home/home.dart";
import "package:nhs/ui/staff/settings/settings.dart";
import '../shared/misc/appbar.dart';
import "../../models/index.dart";
import "./home/request_service.dart";

class StaffScaffold extends StatefulWidget {
  const StaffScaffold({super.key});

  @override
  State<StaffScaffold> createState() => _StaffScaffoldState();
}

class _StaffScaffoldState extends State<StaffScaffold> {
  StreamSubscription? _sub;
  Staff? _staff;
  int _currentIndex = 0;

  @override
  void initState() {
    StaffService.stream.listen((staff) {
      setState(() {
        _staff = staff;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_staff == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    final fab = FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        showModalBottomSheet(
            useSafeArea: true,
            isScrollControlled: true,
            context: context,
            builder: (context) => RequestService(
                  staff: _staff!,
                ));
      },
    );
    final navigationIsVertical = UIService.isBigScreen(context);
    Widget page;
    if (_currentIndex == 0) {
      page = StaffHome(staff: _staff);
    } else {
      page = StaffSettings(staff: _staff);
    }
    return Scaffold(
      appBar: const NHSAppBar(),
      body: navigationIsVertical
          ? Row(
              children: [
                NavigationRail(
                    onDestinationSelected: (idx) {
                      setState(() {
                        _currentIndex = idx;
                      });
                    },
                    leading: fab,
                    labelType: NavigationRailLabelType.all,
                    destinations: const [
                      NavigationRailDestination(
                          padding: EdgeInsets.all(16),
                          icon: Icon(Icons.home_outlined),
                          selectedIcon: Icon(Icons.home),
                          label: Text("Home")),
                      NavigationRailDestination(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          icon: Icon(Icons.settings_outlined),
                          selectedIcon: Icon(Icons.settings),
                          label: Text("Settings")),
                    ],
                    selectedIndex: _currentIndex),
                Expanded(
                  child: page,
                )
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
                      icon: Icon(Icons.settings_outlined),
                      selectedIcon: Icon(Icons.settings),
                      label: "Settings"),
                ]),
      floatingActionButton:
          _currentIndex == 0 && !navigationIsVertical ? fab : null,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:nhs/services/auth_service.dart';
import 'package:nhs/services/ui_service.dart';
import 'package:nhs/ui/member/settings/edit_tutoring_subjects.dart';
import 'package:provider/provider.dart';
import '../../../models/index.dart';
import '../../shared/settings/settings_container.dart';
import '../../shared/settings/setting.dart';
import "../../../utils/fmt.dart";

class MemberSettings extends StatelessWidget {
  final Member? member;
  MemberSettings({super.key, required this.member});

  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    if (member == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Consumer<UIService>(
        builder: (context, uiService, child) => Padding(
            padding: const EdgeInsets.all(8),
            child: ListView(children: [
              SettingsContainer(
                  title: "Appearence",
                  child: Column(
                    children: [
                      Setting(
                        name: "Dark Theme",
                        child: Switch(
                          value: uiService.isDarkMode,
                          onChanged: (value) => uiService.setIsDarkMode(value),
                        ),
                      )
                    ],
                  )),
              SettingsContainer(
                title: "Account",
                child: Column(children: [
                  Setting(name: "Display Name", child: Text(member!.name)),
                  Setting(name: "Email", child: Text(member!.email)),
                  Setting(
                      name: "Graduation Year",
                      child: Text(member!.graduationYear.toString())),
                  Setting(
                      name: "Sign Out",
                      child: OutlinedButton(
                        style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                                const Color.fromARGB(82, 244, 67, 54)),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.red)),
                        child: const Text("Sign Out"),
                        onPressed: () {
                          _authService.signOut().then((value) =>
                              Navigator.pushReplacementNamed(
                                  context, "sign-in"));
                        },
                      ))
                ]),
              ),
              SettingsContainer(
                  title: "Tutoring Subjects",
                  isEditable: true,
                  onEdit: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        useSafeArea: true,
                        context: context,
                        builder: (context) =>
                            EditTutoringSubjects(member: member!));
                  },
                  child: Column(
                    children: member!.tutoringSubjects
                        .map((subject) =>
                            Setting(name: subject, child: Container()))
                        .toList(),
                  )),
              SettingsContainer(
                  title: "Free Periods",
                  isEditable: true,
                  child: Column(
                      children: member!.freePeriods.entries
                          .map((entry) => Setting(
                              name: "Period ${entry.key}",
                              child: Text(fmtDays(entry.value))))
                          .toList()))
            ])));
  }
}

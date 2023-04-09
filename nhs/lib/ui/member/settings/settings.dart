import 'package:flutter/material.dart';
import '../../../models/index.dart';
import '../../shared/settings/settings_container.dart';
import '../../shared/settings/setting.dart';
import "../../../utils/auth.dart";
import "../../../utils/fmt.dart";

class MemberSettings extends StatelessWidget {
  final Member? member;
  const MemberSettings({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    if (member == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(children: [
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
                        foregroundColor: MaterialStateProperty.all(Colors.red)),
                    child: const Text("Sign Out"),
                    onPressed: () {
                      Authentication.signOut(context: context).then((value) =>
                          Navigator.pushReplacementNamed(context, "sign-in"));
                    },
                  ))
            ]),
          ),
          SettingsContainer(
              title: "Tutoring Subjects",
              isEditable: true,
              child: Column(
                children: member!.tutoringSubjects
                    .map(
                        (subject) => Setting(name: subject, child: Container()))
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
        ]));
  }
}

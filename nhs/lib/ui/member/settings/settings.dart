import 'package:flutter/material.dart';
import "package:flutter_mobx/flutter_mobx.dart";
import "../../../stores/member.store.dart";
import "package:provider/provider.dart";
import '../../shared/settings/settings_container.dart';
import '../../shared/settings/setting.dart';
import "../../../utils/auth.dart";
import "../../../utils/fmt.dart";

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MemberStore>(
        builder: (_, memberStore, __) => Observer(
            builder: (context) => Padding(
                padding: const EdgeInsets.all(8),
                child: ListView(children: [
                  SettingsContainer(
                    title: "Account",
                    child: Column(children: [
                      Setting(
                          name: "Display Name",
                          child: Text(memberStore.member!.name)),
                      Setting(
                          name: "Email",
                          child: Text(memberStore.member!.email)),
                      Setting(
                          name: "Graduation Year",
                          child: Text(
                              memberStore.member!.graduationYear.toString())),
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
                              Authentication.signOut(context: context).then(
                                  (value) => Navigator.pushReplacementNamed(
                                      context, "sign-in"));
                            },
                          ))
                    ]),
                  ),
                  SettingsContainer(
                      title: "Tutoring Subjects",
                      isEditable: true,
                      child: Column(
                        children: memberStore.member!.tutoringSubjects
                            .map((subject) =>
                                Setting(name: subject, child: Container()))
                            .toList(),
                      )),
                  SettingsContainer(
                      title: "Free Periods",
                      isEditable: true,
                      child: Column(
                          children: memberStore.member!.freePeriods.entries
                              .map((entry) => Setting(
                                  name: "Period ${entry.key}",
                                  child: Text(fmtDays(entry.value))))
                              .toList()))
                ]))));
  }
}

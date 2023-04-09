import 'package:flutter/material.dart';
import '../../../models/index.dart';
import '../../shared/settings/settings_container.dart';
import '../../shared/settings/setting.dart';
import "../../../utils/auth.dart";

class StaffSettings extends StatelessWidget {
  final Staff? staff;
  const StaffSettings({super.key, required this.staff});

  @override
  Widget build(BuildContext context) {
    if (staff == null) {
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
              Setting(name: "Display Name", child: Text(staff!.name)),
              Setting(name: "Email", child: Text(staff!.email)),
              Setting(name: "Department", child: Text(staff!.department)),
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
        ]));
  }
}

import 'package:flutter/material.dart';
import 'package:nhs/services/auth_service.dart';
import 'package:nhs/ui/shared/settings/appearance.dart';
import '../../../models/index.dart';
import '../../shared/settings/settings_container.dart';
import '../../shared/settings/setting.dart';

class StaffSettings extends StatelessWidget {
  final Staff? staff;
  StaffSettings({super.key, required this.staff});
  final _authService = AuthService();

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
          const Appearance(),
          SettingsContainer(
            title: "Account",
            child: Column(children: [
              Setting(
                  name: "Display Name",
                  child: Text(
                    staff!.name,
                    style: const TextStyle(fontSize: 12),
                  )),
              Setting(
                  name: "Email",
                  child: Text(
                    staff!.email,
                    style: const TextStyle(fontSize: 12),
                  )),
              Setting(
                  name: "Department",
                  child: Text(
                    staff!.department,
                    style: const TextStyle(fontSize: 12),
                  )),
              Setting(
                  name: "Sign Out",
                  child: OutlinedButton(
                    style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(
                            const Color.fromARGB(82, 244, 67, 54)),
                        foregroundColor: MaterialStateProperty.all(Colors.red)),
                    child: const Text("Sign Out"),
                    onPressed: () {
                      _authService.signOut().then((value) =>
                          Navigator.pushReplacementNamed(context, "sign-in"));
                    },
                  ))
            ]),
          ),
        ]));
  }
}

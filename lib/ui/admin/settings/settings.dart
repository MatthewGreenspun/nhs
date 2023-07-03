import 'package:flutter/material.dart';
import 'package:nhs/services/auth_service.dart';
import 'package:nhs/ui/shared/settings/appearance.dart';
import '../../../models/index.dart';
import '../../shared/settings/settings_container.dart';
import '../../shared/settings/setting.dart';

class AdminSettings extends StatelessWidget {
  final Admin? admin;
  AdminSettings({super.key, required this.admin});
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    if (admin == null) {
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
                    admin!.name,
                    style: const TextStyle(fontSize: 12),
                  )),
              Setting(
                  name: "Email",
                  child: Text(
                    admin!.email,
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
          SettingsContainer(
            title: "Requirements",
            isEditable: true,
            onEdit: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            TextField(),
                            TextField(),
                          ],
                        ),
                      ));
            },
            child: Column(children: [
              Setting(name: "Project Credits", child: Text("2")),
              Setting(name: "Service Credits", child: Text("2")),
              Setting(name: "Tutoring Credits", child: Text("2")),
            ]),
          )
        ]));
  }
}

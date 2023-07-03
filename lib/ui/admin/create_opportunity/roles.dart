import 'package:flutter/material.dart';
import "package:flutter_form_builder/flutter_form_builder.dart";
import 'package:nhs/models/index.dart';

import '../../shared/inc_dec_button/index.dart';

class Roles extends StatefulWidget {
  const Roles({super.key});

  @override
  State<Roles> createState() => _RolesState();
}

class _RolesState extends State<Roles> {
  final List<List<dynamic>> _roleData = [
    [TextEditingController(), IncDecController(initialValue: 1)]
  ];

  List<Role> convertRoleData() {
    return _roleData
        .map((r) => Role(name: r[0].value.text, membersNeeded: r[1].value))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
        name: "roles",
        builder: (field) => Column(children: [
              const ListTile(
                leading: Icon(Icons.people),
                title: Text("Roles"),
              ),
              ...List.generate(
                  _roleData.length,
                  (idx) => ListTile(
                      leading: IconButton.outlined(
                          onPressed: () {
                            setState(() {
                              _roleData.removeAt(idx);
                            });
                            field.didChange(convertRoleData());
                          },
                          icon: const Icon(Icons.close)),
                      title: TextField(
                        controller: _roleData[idx][0],
                        decoration:
                            const InputDecoration(label: Text("Role Name")),
                        onChanged: (value) =>
                            field.didChange(convertRoleData()),
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Number of volunteers"),
                          IncDecButton(
                            controller: _roleData[idx][1],
                            min: 1,
                            max: 400,
                            onChange: (value) =>
                                field.didChange(convertRoleData()),
                          ),
                        ],
                      ))).toList(),
              OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _roleData.add([
                        TextEditingController(),
                        IncDecController(initialValue: 1)
                      ]);
                      field.didChange(convertRoleData());
                    });
                  },
                  child: const Text("Add Role")),
            ]));
  }
}

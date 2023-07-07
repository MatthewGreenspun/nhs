import 'package:flutter/material.dart';
import 'package:nhs/services/admin_service.dart';
import 'package:nhs/ui/shared/inc_dec_button/index.dart';
import '../../../models/index.dart';
import '../../../utils/fmt.dart';

class Statistics extends StatelessWidget {
  final Member member;
  final bool canEdit;
  const Statistics({super.key, required this.member, this.canEdit = false});

  Widget stat(String label, double value) {
    return Column(
      children: [
        CircleAvatar(
          child: Text(fmtCredits(value)),
        ),
        Text(label)
      ],
    );
  }

  void _onEdit(BuildContext context) {
    double project = member.projectCredits;
    double service = member.serviceCredits;
    double tutoring = member.tutoringCredits;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                "Edit Credits",
                textAlign: TextAlign.center,
              ),
              content: SizedBox(
                width: 300,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  ListTile(
                    title: const Text("Project"),
                    trailing: IncDecButton(
                      initial: project.toInt(),
                      max: 1000,
                      onChange: (value) {
                        project = value.toDouble();
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text("Service"),
                    trailing: IncDecButton(
                      initial: service.toInt(),
                      max: 1000,
                      onChange: (value) {
                        service = value.toDouble();
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text("Tutoring"),
                    trailing: IncDecButton(
                      initial: tutoring.toInt(),
                      max: 1000,
                      onChange: (value) {
                        tutoring = value.toDouble();
                      },
                    ),
                  ),
                ]),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel")),
                FilledButton(
                    onPressed: () {
                      AdminService.editMember(member.id!,
                              project: project,
                              service: service,
                              tutoring: tutoring)
                          .then((value) => Navigator.pop(context));
                    },
                    child: const Text("Save")),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: canEdit ? () => _onEdit(context) : null,
        child: Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(children: [
                Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          member.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(
                          fmtSemester(),
                          style: const TextStyle(fontSize: 20),
                        )
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    stat("Project", member.projectCredits),
                    stat("Service", member.serviceCredits),
                    stat("Tutoring", member.tutoringCredits),
                    stat("Probation", member.probationLevel),
                  ],
                )
              ]),
            )));
  }
}

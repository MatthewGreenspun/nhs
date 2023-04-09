import 'package:flutter/material.dart';
import "../../../models/index.dart";
import "../../../utils/fmt.dart";

class Statistics extends StatelessWidget {
  final Member member;
  const Statistics({super.key, required this.member});

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

  @override
  Widget build(BuildContext context) {
    return Card(
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
        ));
  }
}

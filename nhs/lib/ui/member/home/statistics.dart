import 'package:flutter/material.dart';
import "../../../models/index.dart";

class Statistics extends StatelessWidget {
  final Member member;
  const Statistics({super.key, required this.member});

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
                      member.graduationYear.toString(),
                      style: const TextStyle(fontSize: 20),
                    )
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      child: Text(member.projectCredits.toString()),
                    ),
                    const Text("Project")
                  ],
                ),
                Column(
                  children: [
                    CircleAvatar(
                      child: Text(member.serviceCredits.toString()),
                    ),
                    const Text("Service")
                  ],
                ),
                Column(
                  children: [
                    CircleAvatar(
                      child: Text(member.tutoringCredits.toString()),
                    ),
                    const Text("Tutoring")
                  ],
                ),
                Column(
                  children: [
                    CircleAvatar(
                      child: Text(member.probationLevel.toString()),
                    ),
                    const Text("Probation")
                  ],
                ),
              ],
            )
          ]),
        ));
  }
}

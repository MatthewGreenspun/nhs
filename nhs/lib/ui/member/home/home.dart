import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../stores/member.store.dart';
import 'package:provider/provider.dart';
import "./statistics.dart";

class MemberHome extends StatelessWidget {
  const MemberHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MemberStore>(
        builder: (_, memberStore, __) => Observer(
            builder: (context) => Column(
                  children: [
                    Statistics(member: memberStore.member!),
                    const Text(
                      "Upcoming Opportunities",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    const Text("Past Opportunities",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25))
                  ],
                )));
  }
}

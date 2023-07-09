import 'package:flutter/material.dart';
import 'package:nhs/ui/member/home/opportunity_tabs.dart';
import 'package:nhs/ui/shared/constants.dart';
import 'package:nhs/ui/shared/misc/statistics.dart';
import 'package:nhs/ui/shared/misc/appbar.dart';
import '../../../models/index.dart';

class MemberTile extends StatelessWidget {
  final Member member;
  const MemberTile({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final credits =
        member.tutoringCredits + member.serviceCredits + member.projectCredits;
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Scaffold(
                    appBar: const NHSAppBar(),
                    body: Column(
                      children: [
                        Statistics(
                          member: member,
                          canEdit: true,
                        ),
                        Expanded(
                            child: OpportunityTabs(
                                opportunities: member.opportunities))
                      ],
                    ))),
          );
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: credits == 0
                ? Colors.red
                : credits >= kCreditsNeeded
                    ? Colors.green
                    : Colors.orange,
            child: Text("$credits"),
          ),
          title: Text(member.name),
          subtitle: Text(member.email),
          trailing: IconButton(
            icon: const Icon(Icons.mail_outline),
            onPressed: () {},
          ),
        ));
  }
}

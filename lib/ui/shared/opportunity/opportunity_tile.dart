import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import "../../../models/index.dart";
import './opportunity_page.dart';

class OpportunityTile extends StatelessWidget {
  final Opportunity opportunity;
  final Member? member;
  final Admin? admin;
  const OpportunityTile(
      {super.key, required this.opportunity, this.member, this.admin});

  @override
  Widget build(BuildContext context) {
    final isFull =
        opportunity.membersNeeded == opportunity.membersSignedUp.length;
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OpportunityPage(
                        id: opportunity.id,
                        member: member,
                        admin: admin,
                      )));
        },
        child: ListTile(
          title: Text(opportunity.title),
          leading: CircleAvatar(child: Icon(opportunity.icon)),
          subtitle: Text(
            DateFormat.MMMMEEEEd().format(opportunity.date),
          ),
          trailing: Column(
            children: [
              Icon(Icons.people_outline,
                  color: isFull ? Theme.of(context).colorScheme.primary : null),
              Text(
                "${opportunity.membersSignedUp.length} / ${opportunity.membersNeeded}",
                style: const TextStyle(fontSize: 10),
              )
            ],
          ),
          enabled:
              opportunity.membersNeeded != opportunity.membersSignedUp.length &&
                  opportunity.date.isAfter(DateTime.now()),
        ));
  }
}

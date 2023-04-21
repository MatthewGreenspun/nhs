import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nhs/ui/shared/misc/no_results.dart';
import 'package:nhs/ui/shared/opportunity/opportunity_page.dart';
import '../../../models/index.dart';
import "./statistics.dart";

class MemberHome extends StatelessWidget {
  final Member? member;
  const MemberHome({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    if (member == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      children: [
        Statistics(member: member!),
        member!.opportunities.isEmpty
            ? const Expanded(
                child: NoResults(
                    title: "No Opportunities",
                    subtitle: "Sign up on the opportunities page",
                    icon: Icon(
                      Icons.workspace_premium_outlined,
                      size: 50,
                    )))
            : const Text(
                "Upcoming Opportunities",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
        Expanded(
            child: ListView(
          children: ListTile.divideTiles(
              color: Theme.of(context).colorScheme.primary,
              context: context,
              tiles: member!.opportunities.map((serviceSnippet) => ListTile(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OpportunityPage(
                                  id: serviceSnippet.opportunityId,
                                  member: member,
                                ))),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: const Icon(Icons.workspace_premium_outlined),
                    ),
                    title: Text(serviceSnippet.title),
                    subtitle: Text(
                        DateFormat.MMMMEEEEd().format(serviceSnippet.date)),
                  ))).toList(),
        ))
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
    final upcomingOpportunities = member!.opportunities
        .where((serviceSnippet) => serviceSnippet.date.isAfter(DateTime.now()));
    final pastOpportunities = member!.opportunities.where(
        (serviceSnippet) => serviceSnippet.date.isBefore(DateTime.now()));
    return Column(
      children: [
        Statistics(member: member!),
        if (member!.opportunities.isEmpty)
          const Expanded(
              child: NoResults(
                  title: "No Opportunities",
                  subtitle: "Sign up on the opportunities page",
                  icon: Icon(
                    Icons.workspace_premium_outlined,
                    size: 50,
                  ))),
        if (upcomingOpportunities.isNotEmpty) ...[
          const Text(
            "Upcoming Opportunities",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: ListTile.divideTiles(
                  color: Theme.of(context).colorScheme.primary,
                  context: context,
                  tiles: upcomingOpportunities.map((serviceSnippet) => ListTile(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OpportunityPage(
                                      id: serviceSnippet.opportunityId,
                                      member: member,
                                    ))),
                        leading: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          child: const Icon(Icons.workspace_premium_outlined),
                        ),
                        title: Text(serviceSnippet.title),
                        subtitle: Text(
                            DateFormat.MMMMEEEEd().format(serviceSnippet.date)),
                      ))).toList(),
            ),
          ))
        ],
        if (pastOpportunities.isNotEmpty) ...[
          const Text(
            "Past Opportunities",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: ListTile.divideTiles(
                  color: Theme.of(context).colorScheme.primary,
                  context: context,
                  tiles: pastOpportunities.map((serviceSnippet) => ListTile(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OpportunityPage(
                                      id: serviceSnippet.opportunityId,
                                      member: member,
                                    ))),
                        title: Text(serviceSnippet.title),
                        subtitle: Text(
                            DateFormat.MMMMEEEEd().format(serviceSnippet.date)),
                        trailing: serviceSnippet.isApproved
                            ? RatingBarIndicator(
                                rating: serviceSnippet.rating!.toDouble(),
                                itemSize: 20,
                                itemCount: 5,
                                itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ))
                            : Text(
                                "Pending ...",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(fontStyle: FontStyle.italic),
                              ),
                      ))).toList(),
            ),
          ))
        ]
      ],
    );
  }
}

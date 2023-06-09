import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:nhs/models/index.dart';
import 'package:nhs/ui/shared/misc/tab_snippet_list.dart';
import '../../shared/misc/no_results.dart';
import '../../shared/opportunity/opportunity_page.dart';

class OpportunityTabs extends StatelessWidget {
  final List<ServiceSnippet> opportunities;
  final Member? member;
  const OpportunityTabs({super.key, required this.opportunities, this.member});

  @override
  Widget build(BuildContext context) {
    const noUpcomingResults = NoResults(
        title: "No Opportunities",
        subtitle: "Sign up on the opportunities page",
        icon: Icon(
          Icons.workspace_premium_outlined,
          size: 50,
        ));
    const noPastResults = NoResults(
        title: "Nothing Completed",
        subtitle: "Wait for the due date to pass",
        icon: Icon(
          Icons.timer_outlined,
          size: 50,
        ));
    return TabSnippetList(
        opportunities: opportunities,
        upcomingTile: (serviceSnippet) => ListTile(
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
              subtitle:
                  Text(DateFormat.MMMMEEEEd().format(serviceSnippet.date)),
            ),
        pastTile: (serviceSnippet) => ListTile(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OpportunityPage(
                            id: serviceSnippet.opportunityId,
                            member: member,
                          ))),
              title: Text(serviceSnippet.title),
              subtitle:
                  Text(DateFormat.MMMMEEEEd().format(serviceSnippet.date)),
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
            ),
        noUpcomingResults: noUpcomingResults,
        noPastResults: noPastResults);
  }
}

import 'package:flutter/material.dart';
import 'package:nhs/models/index.dart';
import 'package:nhs/ui/shared/misc/tab_snippet_list.dart';
import '../../../services/staff_student_service.dart';
import '../../shared/misc/no_results.dart';
import '../../shared/opportunity/snippet_tile.dart';

class ServiceTabs extends StatelessWidget {
  final List<ServiceSnippet> opportunities;
  final Member? member;
  const ServiceTabs({super.key, required this.opportunities, this.member});

  @override
  Widget build(BuildContext context) {
    final staffService = StaffService();
    const noUpcomingResults = NoResults(
      title: "No Posts",
      subtitle: "Create a service opportunity below",
      icon: Icon(
        Icons.post_add,
        size: 50,
      ),
    );
    const noPastResults = NoResults(
        title: "Nothing Completed",
        subtitle: "Wait for the due date to pass",
        icon: Icon(
          Icons.timer_outlined,
          size: 50,
        ));
    return TabSnippetList(
        opportunities: opportunities,
        upcomingTile: (post) => SnippetTile(
              post: post,
              onEdit: () {
                Navigator.pop(context);
              },
              onDelete: () {
                staffService
                    .deleteOpportunity(post)
                    .then((value) => Navigator.pop(context));
              },
            ),
        pastTile: (post) => SnippetTile(
              post: post,
              onEdit: () {
                Navigator.pop(context);
              },
              onDelete: () {
                staffService
                    .deleteOpportunity(post)
                    .then((value) => Navigator.pop(context));
              },
            ),
        noUpcomingResults: noUpcomingResults,
        noPastResults: noPastResults);
  }
}

import "package:flutter/material.dart";
import "package:nhs/services/staff_student_service.dart";
import "package:nhs/ui/shared/misc/no_results.dart";
import "package:nhs/ui/shared/opportunity/snippet_tile.dart";
import "../../../models/index.dart";

class StaffHome extends StatelessWidget {
  final Staff? staff;
  const StaffHome({super.key, required this.staff});

  @override
  Widget build(BuildContext context) {
    final staffService = StaffService();
    if (staff == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (staff!.posts.isEmpty) {
      return const NoResults(
        title: "No Posts",
        subtitle: "Create a service opportunity below",
        icon: Icon(
          Icons.post_add,
          size: 50,
        ),
      );
    }
    final upcomingService = staff!.posts
        .where((serviceSnippet) => serviceSnippet.date.isAfter(DateTime.now()))
        .toList();
    final pastService = staff!.posts
        .where((serviceSnippet) => serviceSnippet.date.isBefore(DateTime.now()))
        .toList();
    upcomingService.sort((s1, s2) => -s1.date.compareTo(s2.date));
    pastService.sort((s1, s2) => -s1.date.compareTo(s2.date));

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            if (upcomingService.isNotEmpty) ...[
              Text(
                "Upcoming Service",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Flexible(
                child: ListView(
                    children: ListTile.divideTiles(
                        context: context,
                        color: Theme.of(context).colorScheme.primary,
                        tiles: upcomingService.map((post) => SnippetTile(
                              post: post,
                              onEdit: () {
                                Navigator.pop(context);
                              },
                              onDelete: () {
                                staffService
                                    .deleteOpportunity(post)
                                    .then((value) => Navigator.pop(context));
                              },
                            ))).toList()),
              ),
            ],
            if (pastService.isNotEmpty) ...[
              Text(
                "Past Service",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Expanded(
                child: ListView(
                    children: ListTile.divideTiles(
                        context: context,
                        color: Theme.of(context).colorScheme.primary,
                        tiles: pastService.map((post) => SnippetTile(
                              post: post,
                              onEdit: () {
                                Navigator.pop(context);
                              },
                              onDelete: () {
                                staffService
                                    .deleteOpportunity(post)
                                    .then((value) => Navigator.pop(context));
                              },
                            ))).toList()),
              ),
            ]
          ],
        ));
  }
}

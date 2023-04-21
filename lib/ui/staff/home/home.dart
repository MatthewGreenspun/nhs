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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
          children: ListTile.divideTiles(
              context: context,
              color: Theme.of(context).colorScheme.primary,
              tiles: staff!.posts.map((post) => SnippetTile(
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
    );
  }
}

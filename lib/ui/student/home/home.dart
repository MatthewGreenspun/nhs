import "package:flutter/material.dart";
import "package:nhs/services/staff_student_service.dart";
import "package:nhs/ui/shared/misc/no_results.dart";
import "package:nhs/ui/shared/opportunity/snippet_tile.dart";
import "../../../models/index.dart";

class StudentHome extends StatelessWidget {
  final Student? student;
  const StudentHome({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final studentService = StudentService();
    if (student == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (student!.posts.isEmpty) {
      return const NoResults(
        title: "No Posts",
        subtitle: "Request a tutor below.",
        icon: Icon(
          Icons.post_add,
          size: 50,
        ),
      );
    }
    return ListView(
        children: ListTile.divideTiles(
            context: context,
            color: Theme.of(context).colorScheme.primary,
            tiles: student!.posts.map((post) => SnippetTile(
                  post: post,
                  onEdit: () {
                    Navigator.pop(context);
                  },
                  onDelete: () {
                    studentService
                        .deleteOpportunity(post)
                        .then((value) => Navigator.pop(context));
                  },
                ))).toList());
  }
}

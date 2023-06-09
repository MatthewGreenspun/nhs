import "package:flutter/material.dart";
import "package:nhs/ui/staff/home/service_tabs.dart";
import "../../../models/index.dart";
import "../../shared/misc/no_results.dart";

class StaffHome extends StatelessWidget {
  final Staff? staff;
  const StaffHome({super.key, required this.staff});

  @override
  Widget build(BuildContext context) {
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
    return ServiceTabs(opportunities: staff!.posts);
  }
}

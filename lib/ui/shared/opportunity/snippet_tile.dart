import "package:flutter/material.dart";
import "package:flutter_rating_bar/flutter_rating_bar.dart";
import "package:intl/intl.dart";
import "package:nhs/models/index.dart";
import "package:nhs/services/opportunity_service.dart";
import "package:nhs/ui/shared/opportunity/action_dialog.dart";
import "opportunity_page.dart";

class SnippetTile extends StatelessWidget {
  final ServiceSnippet post;
  final void Function() onEdit;
  final void Function() onDelete;
  const SnippetTile(
      {super.key,
      required this.post,
      required this.onEdit,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final hasPassed = post.date.isBefore(DateTime.now());
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      OpportunityPage(id: post.opportunityId)));
        },
        child: ListTile(
          title: Text(post.title),
          leading: hasPassed
              ? null
              : const CircleAvatar(
                  child: Icon(Icons.workspace_premium_outlined)),
          subtitle: Text(DateFormat.MMMMEEEEd().format(post.date)),
          trailing: hasPassed
              ? post.isApproved
                  ? RatingBarIndicator(
                      rating: post.rating!.toDouble(),
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemSize: 20,
                    )
                  : FilledButton(
                      onPressed: () {
                        OpportunityService.showRating(context,
                            opportunityId: post.opportunityId);
                      },
                      child: const Text("Approve"),
                    )
              : IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => ActionDialog(
                              onEdit: onEdit,
                              onDelete: onDelete,
                            ));
                  },
                ),
        ));
  }
}

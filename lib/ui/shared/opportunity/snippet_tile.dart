import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:nhs/models/index.dart";
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
          leading:
              const CircleAvatar(child: Icon(Icons.workspace_premium_outlined)),
          subtitle: Text(DateFormat.MMMMEEEEd().format(post.date)),
          trailing: IconButton(
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

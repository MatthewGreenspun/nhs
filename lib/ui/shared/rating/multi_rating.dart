import "package:flutter/material.dart";
import "package:flutter_rating_bar/flutter_rating_bar.dart";
import "package:intl/intl.dart";
import "../../../models/index.dart";

class MultiRating extends StatefulWidget {
  final Opportunity opportunity;
  final ServiceSnippet snippet;

  const MultiRating(
      {super.key, required this.opportunity, required this.snippet});

  @override
  State<MultiRating> createState() => _MultiRatingState();
}

class _MultiRatingState extends State<MultiRating> {
  final List<double> _ratings = [];
  late TextEditingController _commentsController;
  final FocusNode _commentsNode = FocusNode();
  final List<MemberSnippet> _members = [];

  @override
  void initState() {
    _members.addAll(widget.opportunity.membersSignedUp);
    _ratings.addAll(List.filled(_members.length, 5));
    _commentsController = TextEditingController();
    _commentsNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _commentsController.dispose();
    _commentsNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [
              Text(
                widget.opportunity.title,
                style: textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              Text(
                DateFormat.MMMMEEEEd().format(widget.opportunity.date),
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              )
            ]),
            Container(
              margin: const EdgeInsets.all(8),
              child: Text(
                "NHS Members",
                style: textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ListView(
                  children: ListTile.divideTiles(
                      context: context,
                      color: Theme.of(context).primaryColor,
                      tiles: _members.asMap().entries.map((entry) => ListTile(
                          leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(entry.value.profilePicture)),
                          title: Text(entry.value.name),
                          subtitle: RatingBar.builder(
                            initialRating: _ratings[entry.key],
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemSize: 25,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (value) {
                              setState(() {
                                _ratings[entry.key] = value;
                              });
                            },
                          )))).toList()),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: TextField(
                    controller: _commentsController,
                    focusNode: _commentsNode,
                    minLines: 5,
                    maxLines: 5,
                    decoration: InputDecoration(
                        label: const Text("Any comments?"),
                        filled: true,
                        fillColor: Colors.grey[200]),
                  ),
                ),
                FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Submit")),
              ],
            )
          ],
        ),
      )),
    );
  }
}

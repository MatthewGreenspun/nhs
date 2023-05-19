import 'package:flutter/material.dart';
import "package:flutter_rating_bar/flutter_rating_bar.dart";
import 'package:intl/intl.dart';
import '../../../models/index.dart';

class SingleRating extends StatefulWidget {
  final Opportunity opportunity;

  const SingleRating({super.key, required this.opportunity});

  @override
  State<SingleRating> createState() => _SingleRatingState();
}

class _SingleRatingState extends State<SingleRating> {
  double _rating = 5;
  late TextEditingController _commentsController;
  late MemberSnippet _member;

  @override
  void initState() {
    _commentsController = TextEditingController();
    _member = widget.opportunity.membersSignedUp.first;
    super.initState();
  }

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  void handleSubmit() {
    // TODO: trigger cloud function to update credits
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
            Column(
              children: [
                Text(
                  _member.name,
                  style: textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: Align(
                      alignment: Alignment.center,
                      child: ClipOval(
                        child: Image.network(
                          _member.profilePicture,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      )),
                ),
                Text(
                  "How was your experience?",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Align(
                    alignment: Alignment.center,
                    child: RatingBar.builder(
                      initialRating: _rating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (value) {
                        setState(() {
                          _rating = value;
                        });
                      },
                    )),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: TextField(
                    controller: _commentsController,
                    minLines: 5,
                    maxLines: 5,
                    decoration: InputDecoration(
                        label: const Text("Any comments?"),
                        filled: true,
                        fillColor: Colors.grey[200]!.withAlpha(50)),
                  ),
                ),
                FilledButton(
                    onPressed: () {
                      handleSubmit();
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

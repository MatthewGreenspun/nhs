import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nhs/services/opportunity_service.dart';
import 'package:nhs/ui/shared/misc/appbar.dart';
import 'package:nhs/ui/shared/misc/no_results.dart';
import 'package:nhs/ui/shared/opportunity/members_signed_up.dart';
import '../../../models/index.dart';

class OpportunityPage extends StatefulWidget {
  final String id;
  final Member? member;
  const OpportunityPage({super.key, required this.id, this.member});

  @override
  State<OpportunityPage> createState() => _OpportunityPageState();
}

class _OpportunityPageState extends State<OpportunityPage> {
  Opportunity? _opportunity;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _sub;
  bool _isSignedUp = false;

  @override
  void initState() {
    setState(() {
      _isSignedUp = widget.member != null &&
          widget.member!.opportunities
              .any((snippet) => snippet.opportunityId == widget.id);
    });
    final stream = FirebaseFirestore.instance
        .collection("opportunities")
        .doc(widget.id)
        .snapshots();
    _sub = stream.listen((event) {
      setState(() {
        _opportunity = Opportunity.fromJson(event.data()!);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Widget attributeContainer(IconData icon, String text) {
    return Row(
      children: [
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Icon(icon)),
        Text(text)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_opportunity == null) {
      return const NoResults(
          title: "Not Found",
          subtitle: "This opportunity no longer exists.",
          icon: Icon(Icons.help));
    }
    return Scaffold(
        appBar: const NHSAppBar(),
        body: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _opportunity!.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  attributeContainer(
                      Icons.school_outlined, _opportunity!.creatorName),
                  attributeContainer(
                    Icons.calendar_month_outlined,
                    "${DateFormat.MMMMEEEEd().format(_opportunity!.date)}, Period ${_opportunity!.period}",
                  ),
                  Row(
                    children: [
                      attributeContainer(Icons.people_outlined,
                          "${_opportunity!.membersSignedUp.length} / ${_opportunity!.membersNeeded}"),
                      TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              enableDrag: true,
                              isDismissible: true,
                              builder: (context) => MembersSignedUp(
                                  members: _opportunity!.membersSignedUp));
                        },
                        child: _opportunity!.membersSignedUp.isNotEmpty
                            ? const Text("view")
                            : Container(),
                      ),
                    ],
                  ),
                  widget.member != null
                      ? _isSignedUp
                          ? ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _isSignedUp = false;
                                });
                                OpportunityService.cancelRegistration(
                                    _opportunity!);
                              },
                              child: const Text("Cancel Registration"))
                          : FilledButton(
                              onPressed: () {
                                setState(() {
                                  _isSignedUp = true;
                                });
                                OpportunityService.signUp(_opportunity!);
                              },
                              child: const Text("Sign Up"))
                      : Container(),
                  Divider(color: Theme.of(context).colorScheme.primary),
                  Text(_opportunity!.description),
                ])));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nhs/ui/shared/opportunity/opportunity_tile.dart';
import '../../../models/index.dart';

class Opportunities extends StatefulWidget {
  final Member? member;
  const Opportunities({super.key, required this.member});

  @override
  State<Opportunities> createState() => _OpportunitiesState();
}

class _OpportunitiesState extends State<Opportunities> {
  final _chips = ["All", "Projects", "Service", "Tutoring", "Upcoming", "Past"];
  int _selectedChip = 0;
  List<Opportunity> _opportunities = [];

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("opportunities")
        .limit(10)
        .snapshots()
        .listen((event) {
      setState(() {
        _opportunities.clear();
        _opportunities
            .addAll(event.docs.map((doc) => Opportunity.fromJson(doc.data())));
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                    fit: FlexFit.tight,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _chips
                          .asMap()
                          .entries
                          .map(
                            (entry) => Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedChip = entry.key;
                                    });
                                  },
                                  child: Chip(
                                    side: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    label: Text(
                                      entry.value,
                                      style: TextStyle(
                                          color: entry.key == _selectedChip
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                    backgroundColor: entry.key == _selectedChip
                                        ? Theme.of(context).colorScheme.primary
                                        : null,
                                  ),
                                )),
                          )
                          .toList(),
                    )),
                Expanded(
                  flex: 10,
                  child: ListView(
                      children: ListTile.divideTiles(
                          color: Theme.of(context).colorScheme.primary,
                          context: context,
                          tiles: _opportunities
                              .map((opportunity) => OpportunityTile(
                                    opportunity: opportunity,
                                    member: widget.member,
                                  ))).toList()),
                )
              ],
            )));
  }
}

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
  final _chips = [
    "All",
    "Projects",
    "Service",
    "Tutoring",
    "Upcoming",
    "Past",
  ];
  final List<GlobalKey> _chipKeys = [];
  late ScrollController _chipController;
  int _selectedChip = 0;
  final List<Opportunity> _opportunities = [];

  @override
  void initState() {
    _chipKeys.addAll(List.generate(
        _chips.length, (idx) => GlobalKey(debugLabel: _chips[idx])));
    _chipController = ScrollController();
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
  void dispose() {
    _chipController.dispose();
    super.dispose();
  }

  double computeChipScrollOffset(int chipIdx) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final maxScroll = _chipController.position.maxScrollExtent;
    RenderBox box =
        _chipKeys[chipIdx].currentContext?.findRenderObject() as RenderBox;
    final itemSize = box.size.width;
    Offset position = box.localToGlobal(Offset.zero);
    final desiredPosition = deviceWidth / 2 - itemSize / 2;
    final change = position.dx - desiredPosition;
    if (change + _chipController.offset < 0) {
      return 0;
    }
    if (change + _chipController.offset > maxScroll) {
      return maxScroll;
    }
    return change + _chipController.offset;
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
                      controller: _chipController,
                      scrollDirection: Axis.horizontal,
                      children: _chips.asMap().entries.map(
                        (entry) {
                          final idx = entry.key;
                          return Container(
                              key: _chipKeys[idx],
                              margin: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: ActionChip(
                                label: Text(entry.value),
                                backgroundColor: idx == _selectedChip
                                    ? Theme.of(context).colorScheme.secondary
                                    : null,
                                onPressed: () {
                                  setState(() {
                                    _selectedChip = idx;
                                  });
                                  if (_chipKeys
                                      .any((e) => e.currentContext == null)) {
                                    return;
                                  }
                                  _chipController.animateTo(
                                      computeChipScrollOffset(idx),
                                      curve: Curves.decelerate,
                                      duration:
                                          const Duration(milliseconds: 200));
                                },
                              ));
                        },
                      ).toList(),
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

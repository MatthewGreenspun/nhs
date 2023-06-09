import 'package:flutter/material.dart';
import 'package:nhs/models/index.dart';

/// Wrapper Component for displaying ServiceSnippets on the Home Screen
class TabSnippetList extends StatefulWidget {
  final List<ServiceSnippet> opportunities;
  final Widget Function(ServiceSnippet) upcomingTile;
  final Widget Function(ServiceSnippet) pastTile;
  final Widget noUpcomingResults;
  final Widget noPastResults;
  const TabSnippetList(
      {super.key,
      required this.opportunities,
      required this.upcomingTile,
      required this.pastTile,
      required this.noUpcomingResults,
      required this.noPastResults});

  @override
  State<TabSnippetList> createState() => _TabSnippetListState();
}

class _TabSnippetListState extends State<TabSnippetList>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final upcomingOpportunities = widget.opportunities
        .where((serviceSnippet) => serviceSnippet.date.isAfter(DateTime.now()))
        .toList();
    final pastOpportunities = widget.opportunities
        .where((serviceSnippet) => serviceSnippet.date.isBefore(DateTime.now()))
        .toList();
    upcomingOpportunities.sort((o1, o2) => -o1.date.compareTo(o2.date));
    pastOpportunities.sort((o1, o2) => -o1.date.compareTo(o2.date));

    final tabController = TabController(length: 2, vsync: this);

    return Column(
      children: [
        TabBar(controller: tabController, tabs: const [
          Tab(text: "Upcoming"),
          Tab(
            text: "Past",
          )
        ]),
        Expanded(
            child: TabBarView(controller: tabController, children: [
          if (upcomingOpportunities.isEmpty)
            widget.noUpcomingResults
          else
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                  children: ListTile.divideTiles(
                color: Theme.of(context).colorScheme.primary,
                context: context,
                tiles: upcomingOpportunities.map(widget.upcomingTile).toList(),
              ).toList()),
            ),
          if (pastOpportunities.isEmpty)
            widget.noPastResults
          else
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: ListTile.divideTiles(
                        color: Theme.of(context).colorScheme.primary,
                        context: context,
                        tiles: pastOpportunities.map(widget.pastTile))
                    .toList(),
              ),
            )
        ]))
      ],
    );
  }
}

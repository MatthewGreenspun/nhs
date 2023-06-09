import 'package:flutter/material.dart';
import 'package:nhs/services/opportunity_service.dart';
import 'package:nhs/ui/shared/opportunity/filter_chips.dart';
import 'package:nhs/ui/shared/constants.dart';
import 'package:nhs/ui/shared/misc/no_results.dart';
import 'package:nhs/ui/shared/opportunity/opportunity_tile.dart';
import '../../../models/index.dart';

class Opportunities extends StatefulWidget {
  final Member? member;
  final Admin? admin;
  const Opportunities({super.key, this.member, this.admin});

  @override
  State<Opportunities> createState() => _OpportunitiesState();
}

class _OpportunitiesState extends State<Opportunities> {
  List<String> _chips = [];
  late String _selectedChip;
  bool _isLoadingMore = false;
  bool _isLoadingNewFilter = true;
  final OpportunityService _opportunityService = OpportunityService();
  List<Opportunity> _opportunities = [];

  @override
  void initState() {
    if (widget.admin != null) {
      _chips = kAdminOpportunityChipFilters;
    } else {
      _chips = kMemberOpportunityChipFilters;
    }
    _selectedChip = _chips.first;
    _opportunityService
        .getNextOpportunities(_selectedChip)
        .then((initialOpportunities) {
      setState(() {
        _opportunities = initialOpportunities;
        _isLoadingNewFilter = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onChipSelected(String chip) {
    setState(() {
      _isLoadingNewFilter = true;
    });
    _opportunityService.getNextOpportunities(chip).then((initialOpportunities) {
      setState(() {
        _selectedChip = chip;
        _opportunities = initialOpportunities;
        _isLoadingNewFilter = false;
      });
    });
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
                    child: FilterChips(
                        labels: _chips, onSelected: _onChipSelected)),
                if (_isLoadingNewFilter)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else if (_opportunities.isNotEmpty)
                  Expanded(
                    flex: 10,
                    child: ListView(children: [
                      ...ListTile.divideTiles(
                          color: Theme.of(context).colorScheme.primary,
                          context: context,
                          tiles: _opportunities
                              .map((opportunity) => OpportunityTile(
                                    opportunity: opportunity,
                                    member: widget.member,
                                    admin: widget.admin,
                                  ))).toList(),
                      if (_isLoadingMore)
                        const Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator())
                      else
                        TextButton(
                            onPressed: () {
                              setState(() {
                                _isLoadingMore = true;
                              });
                              _opportunityService
                                  .getNextOpportunities(_selectedChip)
                                  .then((nextOpportunities) {
                                setState(() {
                                  _opportunities = nextOpportunities;
                                  _isLoadingMore = false;
                                });
                              });
                            },
                            child: const Text("Load More"))
                    ]),
                  )
                else
                  const Expanded(
                      flex: 10,
                      child: NoResults(
                          icon: Icon(
                            Icons.search_off_outlined,
                            size: 100,
                          ),
                          title: "No opportunities",
                          subtitle: "Check again another time")),
              ],
            )));
  }
}

import 'package:flutter/material.dart';
import 'package:nhs/ui/shared/misc/no_results.dart';
import 'package:nhs/ui/member/home/opportunity_tabs.dart';
import '../../../models/index.dart';
import "./statistics.dart";

class MemberHome extends StatefulWidget {
  final Member? member;
  const MemberHome({super.key, required this.member});

  @override
  State<MemberHome> createState() => _MemberHomeState();
}

class _MemberHomeState extends State<MemberHome> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    if (widget.member == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      children: [
        Statistics(member: widget.member!),
        if (widget.member!.opportunities.isEmpty)
          const Expanded(
              child: NoResults(
                  title: "No Opportunities",
                  subtitle: "Sign up on the opportunities page",
                  icon: Icon(
                    Icons.workspace_premium_outlined,
                    size: 50,
                  )))
        else
          Expanded(
              child: OpportunityTabs(
            opportunities: widget.member!.opportunities,
            member: widget.member,
          ))
      ],
    );
  }
}

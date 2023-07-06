import 'package:flutter/material.dart';
import 'package:nhs/models/index.dart';
import 'package:nhs/ui/admin/home/opportunity_tabs.dart';
import 'package:nhs/ui/admin/home/statistics.dart';

class AdminHome extends StatelessWidget {
  final Admin admin;
  const AdminHome({super.key, required this.admin});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Statistics(admin: admin),
        Expanded(child: OpportunityTabs(admin: admin))
      ],
    );
  }
}

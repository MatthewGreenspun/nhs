import 'package:flutter/material.dart';
import 'package:nhs/services/admin_service.dart';
import 'package:nhs/ui/admin/people/member_tile.dart';

import '../../../models/index.dart';

class People extends StatefulWidget {
  const People({super.key});

  @override
  State<People> createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  List<Member> members = [];

  @override
  void initState() {
    AdminService.getMembers().then((value) {
      setState(() {
        members.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: members.map((m) => MemberTile(member: m)).toList(),
    );
  }
}

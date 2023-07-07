import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nhs/services/opportunity_service.dart';
import 'package:nhs/ui/shared/misc/appbar.dart';
import 'package:nhs/ui/shared/misc/no_results.dart';
import 'package:nhs/ui/shared/opportunity/members_signed_up.dart';
import '../../../models/index.dart';
import 'role_selection.dart';

class OpportunityPage extends StatefulWidget {
  final String id;
  final Member? member;
  final Staff? staff;
  final Student? student;
  final Admin? admin;
  const OpportunityPage(
      {super.key,
      required this.id,
      this.member,
      this.staff,
      this.student,
      this.admin});

  @override
  State<OpportunityPage> createState() => _OpportunityPageState();
}

class _OpportunityPageState extends State<OpportunityPage> {
  Opportunity? _opportunity;
  StreamSubscription<Opportunity>? _sub;
  bool _isSignedUp = false;

  @override
  void initState() {
    _sub = OpportunityService.stream(widget.id).listen((event) {
      setState(() {
        _opportunity = event;
        _isSignedUp = _opportunity!.membersSignedUp.any((m) => m.isMe);
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _showRoleSelection() {
    showModalBottomSheet(
        context: context,
        enableDrag: true,
        isDismissible: true,
        useSafeArea: true,
        builder: (context) => RoleSelection(initialValue: _opportunity!));
  }

  Widget attributeContainer(IconData icon, String text) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _opportunity!.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      if ((widget.staff ?? widget.student ?? widget.admin) !=
                          null)
                        IconButton.outlined(
                            onPressed: () {},
                            icon: const Icon(Icons.edit_outlined))
                    ],
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  attributeContainer(
                      Icons.school_outlined, _opportunity!.creatorName),
                  attributeContainer(
                    Icons.calendar_month_outlined,
                    DateFormat.MMMMEEEEd().format(_opportunity!.date),
                  ),
                  if (_opportunity!.roles == null)
                    attributeContainer(
                        Icons.timer_outlined, "Period ${_opportunity!.period}"),
                  ListTile(
                      leading: const Icon(Icons.people_outlined),
                      title: Row(
                        children: [
                          Text(
                              "${_opportunity!.membersSignedUp.length} / ${_opportunity!.membersNeeded}"),
                          if (_opportunity!.membersSignedUp.isNotEmpty)
                            TextButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      enableDrag: true,
                                      isDismissible: true,
                                      builder: (context) => MembersSignedUp(
                                          members:
                                              _opportunity!.membersSignedUp,
                                          canEdit: (widget.staff ??
                                                  widget.student ??
                                                  widget.admin) !=
                                              null));
                                },
                                child: const Text("view"))
                        ],
                      )),
                  if (widget.member != null && _isSignedUp)
                    ElevatedButton(
                        onPressed: () {
                          if (_opportunity!.roles == null) {
                            OpportunityService.cancelRegistration(
                                _opportunity!);
                          } else {
                            _showRoleSelection();
                          }
                        },
                        child: Text(_opportunity!.roles == null
                            ? "Cancel Registration"
                            : "Change Role"))
                  else if (widget.member != null && !_isSignedUp)
                    FilledButton(
                        onPressed: () {
                          if (_opportunity!.roles != null) {
                            _showRoleSelection();
                          } else {
                            OpportunityService.signUp(_opportunity!);
                          }
                        },
                        child: const Text("Sign Up")),
                  Divider(color: Theme.of(context).colorScheme.primary),
                  Expanded(
                    child: ListView(
                      children: [
                        Text(_opportunity!.description,
                            style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                  )
                ])));
  }
}

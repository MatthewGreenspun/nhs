import 'package:flutter/material.dart';
import '../../../models/opportunity.dart';
import '../../../services/opportunity_service.dart';

class RoleSelection extends StatefulWidget {
  final Opportunity initialValue;
  const RoleSelection({
    super.key,
    required this.initialValue,
  });

  @override
  State<RoleSelection> createState() => _RoleSelectionState();
}

class _RoleSelectionState extends State<RoleSelection> {
  Opportunity? _opportunity;
  @override
  void initState() {
    _opportunity = widget.initialValue;
    OpportunityService.stream(widget.initialValue.id).listen((event) {
      if (mounted) {
        setState(() {
          _opportunity = event;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_opportunity == null) {
      return const CircularProgressIndicator();
    }
    final isSignedUp = _opportunity!.roles!
        .any((role) => role.membersSignedUp.any((member) => member.isMe));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            "Roles",
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const Divider(),
          Expanded(
              child: ListView(
            children: _opportunity!.roles!.map((role) {
              final isSignedUpForRole = role.membersSignedUp.any((m) => m.isMe);
              return ListTile(
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.people_alt_outlined),
                      Text(
                          "${role.membersSignedUp.length}/${role.membersNeeded}")
                    ],
                  ),
                  title: Text(
                    role.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: TextButton(
                    onPressed: (isSignedUp &&
                                !isSignedUpForRole &&
                                !_opportunity!.allowMultipleRoles!) ||
                            (role.isFull && !isSignedUpForRole)
                        ? null
                        : () {
                            if (isSignedUpForRole) {
                              OpportunityService.cancelRegistrationForRole(
                                  _opportunity!, [role]);
                            } else {
                              OpportunityService.signUpForRole(
                                  _opportunity!, role);
                            }
                          },
                    child: Text(isSignedUpForRole ? "Cancel" : "Sign Up"),
                  ));
            }).toList(),
          ))
        ],
      ),
    );
  }
}

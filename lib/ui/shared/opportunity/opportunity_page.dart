import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nhs/ui/shared/appbar/appbar.dart';
import 'package:nhs/ui/shared/opportunity/membersSignedUp.dart';
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
  final _user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
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

  Future<void> signUp() async {
    final memberSnippet = MemberSnippet(
        email: _user.email!,
        id: _user.uid,
        name: _user.displayName!,
        profilePicture: _user.photoURL!);

    await FirebaseFirestore.instance
        .collection("opportunities")
        .doc(_opportunity!.id)
        .collection("membersSignedUp")
        .doc(_user.uid)
        .set(memberSnippet.toJson());
    final count = await FirebaseFirestore.instance
        .collection("opportunities")
        .doc(_opportunity!.id)
        .collection("membersSignedUp")
        .count()
        .get();
    FirebaseFirestore.instance
        .collection("opportunities")
        .doc(widget.id)
        .set({"numMembersSignedUp": count.count}, SetOptions(merge: true));

    final serviceSnippet = ServiceSnippet.fromOpportunity(_opportunity!);
    FirebaseFirestore.instance
        .collection("users")
        .doc(_user.uid)
        .collection("opportunities")
        .doc(_opportunity!.id)
        .set(serviceSnippet.toJson());
  }

  Future<void> cancelRegistration() async {
    print('cancel registration');
    await FirebaseFirestore.instance
        .collection("opportunities")
        .doc(_opportunity!.id)
        .collection("membersSignedUp")
        .doc(_user.uid)
        .delete();
    final count = await FirebaseFirestore.instance
        .collection("opportunities")
        .doc(_opportunity!.id)
        .collection("membersSignedUp")
        .count()
        .get();
    FirebaseFirestore.instance
        .collection("opportunities")
        .doc(widget.id)
        .set({"numMembersSignedUp": count.count}, SetOptions(merge: true));

    FirebaseFirestore.instance
        .collection("users")
        .doc(_user.uid)
        .collection("opportunities")
        .doc(_opportunity!.id)
        .delete();
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
    final isSignedUp = widget.member != null &&
        widget.member!.opportunities
            .any((snippet) => snippet.opportunityId == widget.id);
    return Scaffold(
        appBar: const NHSAppBar(),
        body: _opportunity == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _opportunity!.title,
                        style: const TextStyle(fontSize: 25),
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
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) =>
                                  MembersSignedUp(opportunityId: widget.id));
                        },
                        child: attributeContainer(Icons.people_outlined,
                            "${_opportunity!.numMembersSignedUp} / ${_opportunity!.membersNeeded}"),
                      ),
                      widget.member != null
                          ? FilledButton(
                              onPressed: () {
                                if (isSignedUp) {
                                  cancelRegistration();
                                } else {
                                  signUp();
                                }
                              },
                              child: Text(isSignedUp
                                  ? "Cancel Registration"
                                  : "Sign Up"))
                          : Container(),
                      Divider(color: Theme.of(context).colorScheme.primary),
                      Text(_opportunity!.description),
                    ])));
  }
}

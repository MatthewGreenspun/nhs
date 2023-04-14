import "dart:async";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:nhs/ui/shared/rating/single_rating.dart";
import "package:nhs/ui/staff/home/home.dart";
import "package:nhs/ui/staff/settings/settings.dart";
import "../shared/appbar/appbar.dart";
import "../../models/index.dart";
import "../shared/rating/multi_rating.dart";
import "./home/request_service.dart";

class StaffScaffold extends StatefulWidget {
  const StaffScaffold({super.key});

  @override
  State<StaffScaffold> createState() => _StaffScaffoldState();
}

class _StaffScaffoldState extends State<StaffScaffold> {
  final _user = FirebaseAuth.instance.currentUser!;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _stream;
  late StreamSubscription _sub;
  Staff? _staff;
  int _currentIndex = 0;

  @override
  void initState() {
    _stream = FirebaseFirestore.instance
        .collection("users")
        .doc(_user.uid)
        .snapshots();
    _sub = _stream.listen((event) {
      setState(() {
        _staff = Staff.fromJson(event.data()!);
        _staff!.posts.forEach((post) async {
          if (DateTime.now().toUtc().isAfter(post.date)) {
            final opportunityDoc = FirebaseFirestore.instance
                .collection("opportunities")
                .doc(post.opportunityId);
            final opportunity =
                Opportunity.fromJson((await opportunityDoc.get()).data()!);
            final membersCollection =
                await opportunityDoc.collection("membersSignedUp").get();
            opportunity.membersSignedUp = membersCollection.docs
                .map((doc) => MemberSnippet.fromJson(doc.data()))
                .toList();
            if (opportunity.membersSignedUp.length > 1) {
              () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MultiRating(
                              opportunity: opportunity,
                              snippet: post,
                            )));
              }();
            } else {
              () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SingleRating(
                              opportunity: opportunity,
                              snippet: post,
                            )));
              }();
            }
          }
        });
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_staff == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    Widget page;
    if (_currentIndex == 0) {
      page = StaffHome(staff: _staff);
    } else {
      page = StaffSettings(staff: _staff);
    }
    return Scaffold(
      appBar: const NHSAppBar(),
      body: page,
      bottomNavigationBar: BottomNavigationBar(
          onTap: (idx) {
            setState(() {
              _currentIndex = idx;
            });
          },
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined), label: "Settings"),
          ]),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                showModalBottomSheet(
                    useSafeArea: true,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => RequestService(
                          staff: _staff!,
                        ));
              },
            )
          : null,
    );
  }
}

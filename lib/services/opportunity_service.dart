import 'package:cloud_firestore/cloud_firestore.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/material.dart';
import 'package:nhs/models/index.dart';
import 'package:nhs/ui/shared/rating/multi_rating.dart';
import 'package:nhs/ui/shared/rating/single_rating.dart';

class OpportunityService {
  static final _fbDB = FirebaseFirestore.instance;
  static final _user = FirebaseAuth.instance.currentUser!;

  static Future<List<Opportunity>> getOpportunities(
      {Opportunity? startAfter}) async {
    const maxResultsPerQuery = 10;
    final docs = await _fbDB
        .collection("opportunities")
        .startAfter([startAfter])
        .limit(maxResultsPerQuery)
        .get();
    return docs.docs.map((doc) => Opportunity.fromJson(doc.data())).toList();
  }

  static Future<void> signUp(Opportunity opportunity) async {
    final memberSnippet = MemberSnippet(
        email: _user.email!,
        id: _user.uid,
        name: _user.displayName!,
        profilePicture: _user.photoURL!);
    final serviceSnippet = ServiceSnippet.fromOpportunity(opportunity);
    await Future.wait([
      _fbDB.collection("opportunities").doc(opportunity.id).set({
        "numMembersSignedUp": FieldValue.increment(1),
        "membersSignedUp": FieldValue.arrayUnion([memberSnippet.toJson()])
      }, SetOptions(merge: true)),
      _fbDB.collection("users").doc(_user.uid).set({
        "opportunities": FieldValue.arrayUnion([serviceSnippet.toJson()])
      }, SetOptions(merge: true))
    ]);
  }

  static Future<void> cancelRegistration(Opportunity opportunity) async {
    final memberSnippet = MemberSnippet(
        email: _user.email!,
        id: _user.uid,
        name: _user.displayName!,
        profilePicture: _user.photoURL!);
    final serviceSnippet = ServiceSnippet.fromOpportunity(opportunity);
    await Future.wait([
      _fbDB.collection("opportunities").doc(opportunity.id).set({
        "numMembersSignedUp": FieldValue.increment(-1),
        "membersSignedUp": FieldValue.arrayRemove([memberSnippet.toJson()])
      }, SetOptions(merge: true)),
      _fbDB.collection("users").doc(_user.uid).set({
        "opportunities": FieldValue.arrayRemove([serviceSnippet.toJson()])
      }, SetOptions(merge: true))
    ]);
  }

  static void showRating(BuildContext context,
      {required String opportunityId}) {
    _fbDB.collection("opportunities").doc(opportunityId).get().then((doc) {
      final opportunity = Opportunity.fromJson(doc.data()!);
      if (opportunity.membersSignedUp.length > 1) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MultiRating(opportunity: opportunity)));
      } else if (opportunity.membersSignedUp.length == 1) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SingleRating(opportunity: opportunity)));
      }
    });
  }
}

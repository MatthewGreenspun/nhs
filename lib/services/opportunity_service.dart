import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter/material.dart';
import 'package:nhs/models/index.dart';
import 'package:nhs/ui/shared/constants.dart';
import 'package:nhs/ui/shared/rating/multi_rating.dart';
import 'package:nhs/ui/shared/rating/single_rating.dart';

class OpportunityService {
  static final _fbDB = FirebaseFirestore.instance;
  static final _fbFns = FirebaseFunctions.instance;
  static final _user = FirebaseAuth.instance.currentUser!;

  /// This is the multiplier for the number of opportunity documents requested.
  /// Each time "Load More" is clicked, the entry in _lastQuerySizeForFilter
  /// corresponding to a particular filter will be incremented by _queryChunkSize
  static const _queryChunkSize = 2;

  static const _maxQuerySize = 20;

  Map<String, int> _querySizeForFilter = {};

  OpportunityService() {
    for (String filter in kMemberOpportunityChipFilters) {
      _querySizeForFilter[filter] = _queryChunkSize;
    }
  }

  Future<List<Opportunity>> getNextOpportunities(String filter) async {
    // Convert to Iso8601String because date is stored as a string in Firebase
    final today = DateTime.now().toUtc().toIso8601String();
    final limit = _querySizeForFilter[filter]!;
    final query = _fbDB
        .collection("opportunities")
        .where("date", isGreaterThanOrEqualTo: today)
        .orderBy("date")
        .limit(limit);
    QuerySnapshot<Map<String, dynamic>> docs;
    if (filter == "Projects" || filter == "Service" || filter == "Tutoring") {
      docs = await query
          .where("opportunityType", isEqualTo: filter.toLowerCase())
          .get();
    } else {
      // Filter is "All"
      docs = await query.get();
    }
    if (docs.docs.length == limit) {
      _querySizeForFilter[filter] = min(limit + _queryChunkSize, _maxQuerySize);
    }
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

  static Future<void> approve(
      Opportunity opportunity, List<int> ratings, String comments) async {
    final approval = Approval(
        opportunity: opportunity, ratings: ratings, comments: comments);
    await _fbFns.httpsCallable("handleApproval").call(approval.toJson());
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/index.dart';
import '../utils/fmt.dart';

class _Base {
  static final _fbDB = FirebaseFirestore.instance;
  static final _user = FirebaseAuth.instance.currentUser!;

  User get user => _user;

  Future<void> _createOpportunity(Opportunity opportunity) async {
    return _fbDB
        .collection("opportunities")
        .doc(opportunity.id)
        .set(opportunity.toJson())
        .then((_) {
      final snippet = ServiceSnippet.fromOpportunity(opportunity);
      _fbDB.collection("users").doc(_user.uid).set({
        "posts": FieldValue.arrayUnion(
          [snippet.toJson()],
        )
      }, SetOptions(merge: true));
    });
  }

  Future<void> deleteOpportunity(ServiceSnippet removedSnippet) async {
    _fbDB
        .collection("opportunities")
        .doc(removedSnippet.opportunityId)
        .delete();
    _fbDB.collection("users").doc(_user.uid).set({
      "posts": FieldValue.arrayRemove([removedSnippet.toJson()])
    }, SetOptions(merge: true));
  }
}

class StudentService extends _Base {
  static Stream<Student> get stream => _Base._fbDB
      .collection("users")
      .doc(_Base._user.uid)
      .snapshots()
      .map((event) => Student.fromJson(event.data()!));

  Future<void> createStudent(
      {required String name, required int graduationYear}) {
    final student = Student(
        name: name, email: _Base._user.email!, graduationYear: graduationYear);
    return _Base._fbDB
        .collection("users")
        .doc(_Base._user.uid)
        .set(student.toJson());
  }

  Future<void> requestTutoring(
      {required String subject,
      required String creatorName,
      required String description,
      required int period,
      required DateTime date}) async {
    final DateTime utcDate = fmtDate(date, period);
    final opportunity = Opportunity(
        creatorId: _Base._user.uid,
        creatorName: creatorName,
        opportunityType: OpportunityType.tutoring,
        credits: 1,
        description: description,
        membersNeeded: 1,
        membersSignedUp: [],
        date: utcDate,
        period: period,
        title: subject);
    await _createOpportunity(opportunity);
  }
}

class StaffService extends _Base {
  static Stream<Staff> get stream => _Base._fbDB
      .collection("users")
      .doc(_Base._user.uid)
      .snapshots()
      .map((event) => Staff.fromJson(event.data()!));

  Future<void> createStaff({required String name, required String department}) {
    final student =
        Staff(name: name, email: _Base._user.email!, department: department);
    return _Base._fbDB
        .collection("users")
        .doc(_Base._user.uid)
        .set(student.toJson());
  }

  Future<void> requestService(
      {required String title,
      required String creatorName,
      required String description,
      required String department,
      required int membersNeeded,
      required int period,
      required DateTime date}) async {
    final DateTime utcDate = fmtDate(date, period);
    final opportunity = Opportunity(
        creatorId: _Base._user.uid,
        creatorName: creatorName,
        department: department,
        opportunityType: OpportunityType.service,
        credits: 1,
        description: description,
        membersNeeded: membersNeeded,
        membersSignedUp: [],
        date: utcDate,
        period: period,
        title: title);
    await _createOpportunity(opportunity);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nhs/models/index.dart';

class MemberService {
  static final _fbDB = FirebaseFirestore.instance;
  static final _user = FirebaseAuth.instance.currentUser!;

  static Stream<Member> get stream => _fbDB
      .collection("users")
      .doc(_user.uid)
      .snapshots()
      .map((event) => Member.fromJson(event.data()!));

  static Future<void> editTutoringSubjects(Set<String> subjects) async {
    await _fbDB
        .collection("users")
        .doc(_user.uid)
        .set({"tutoringSubjects": subjects.toList()}, SetOptions(merge: true));
  }
}

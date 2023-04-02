import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
import "../models/member.dart";
part 'member.store.g.dart';

class MemberStore = _MemberStore with _$MemberStore;

abstract class _MemberStore with Store {
  @observable
  Member? member;

  @action
  void listenForUpdates() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .snapshots()
          .listen((event) {
        member = Member.fromJson(event.data()!);
      });
    }

    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .snapshots()
            .listen((event) {
          member = Member.fromJson(event.data()!);
        });
      }
    });
  }
}

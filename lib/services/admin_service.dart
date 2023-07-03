import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:nhs/models/index.dart';

typedef FormBuilderFields
    = Map<String, FormBuilderFieldState<FormBuilderField<dynamic>, dynamic>>;

class AdminService {
  static final _fbDB = FirebaseFirestore.instance;
  static final _user = FirebaseAuth.instance.currentUser!;

  static Stream<Admin> get stream => _fbDB
      .collection("users")
      .doc(_user.uid)
      .snapshots()
      .map((event) => Admin.fromJson(event.data()!));

  static Future<void> createAdmin({required String name}) async {
    final admin = Admin(name: name, email: _user.email!);
    return _fbDB.collection("users").doc(_user.uid).set(admin.toJson());
  }

  static Future<List<Member>> getMembers() async {
    final docs = await _fbDB
        .collection("users")
        .where("role", isEqualTo: "member")
        .get();
    return docs.docs.map((doc) => Member.fromJson(doc.data())).toList();
  }

  static Future<void> createProject(FormBuilderFields fields) async {
    final opportunity = Opportunity(
      creatorId: _user.uid,
      creatorName: _user.displayName!,
      title: fields['title']!.value,
      description: fields['description']!.value,
      date: fields['date']!.value,
      opportunityType: OpportunityType.project,
      roles: fields['roles']!.value,
      credits: (fields['credits']!.value as int).toDouble(),
      allowMultipleRoles: fields['allowMultiRole']!.value,
    );
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
}

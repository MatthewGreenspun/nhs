import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:json_annotation/json_annotation.dart";
import "package:uuid/uuid.dart";
part "opportunity.g.dart";

enum OpportunityType { project, service, tutoring }

@JsonSerializable()
class MemberSnippet {
  String id;
  String name;
  String email;
  String profilePicture;
  String? role;

  MemberSnippet(
      {required this.id,
      required this.name,
      required this.email,
      required this.profilePicture,
      this.role});

  MemberSnippet copyWith(
      {String? id,
      String? name,
      String? email,
      String? profilePicture,
      String? role}) {
    return MemberSnippet(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        profilePicture: profilePicture ?? this.profilePicture,
        role: role ?? this.role);
  }

  bool get isMe => FirebaseAuth.instance.currentUser!.email == email;

  @override
  bool operator ==(dynamic other) {
    return other.runtimeType == runtimeType &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.profilePicture == profilePicture;
  }

  @override
  int get hashCode => "$id $name $email".hashCode;

  @override
  String toString() => "$id $name $email";

  factory MemberSnippet.fromJson(Map<String, dynamic> json) =>
      _$MemberSnippetFromJson(json);
  Map<String, dynamic> toJson() => _$MemberSnippetToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Role {
  String name;
  int membersNeeded;
  List<MemberSnippet> membersSignedUp;
  Role(
      {required this.name,
      required this.membersNeeded,
      this.membersSignedUp = const []});

  bool get isFull => membersNeeded == membersSignedUp.length;

  @override
  String toString() {
    return "$name : $membersNeeded";
  }

  @override
  bool operator ==(dynamic other) {
    return other.runtimeType == runtimeType &&
        other.name == name &&
        other.membersNeeded == membersNeeded;
  }

  @override
  int get hashCode => "$name $membersNeeded".hashCode;

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
  Map<String, dynamic> toJson() => _$RoleToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Opportunity {
  String id;
  String creatorId;
  String creatorName;
  String department;
  String title;
  String description;
  DateTime date;
  int period;
  OpportunityType opportunityType;
  double credits;
  int _membersNeeded;
  List<MemberSnippet> _membersSignedUp;
  bool isCompleted;
  List<Role>? roles;
  bool? allowMultipleRoles;

  Opportunity(
      {required this.creatorId,
      required this.creatorName,
      this.department = "",
      required this.title,
      required this.description,
      required this.date,
      this.period = 1,
      required this.opportunityType,
      this.credits = 1,
      int membersNeeded = 1,
      List<MemberSnippet> membersSignedUp = const [],
      this.isCompleted = false,
      this.roles,
      this.allowMultipleRoles})
      : id = const Uuid().v4(),
        _membersNeeded = membersNeeded,
        _membersSignedUp = membersSignedUp;

  factory Opportunity.fromJson(Map<String, dynamic> json) =>
      _$OpportunityFromJson(json);
  Map<String, dynamic> toJson() => _$OpportunityToJson(this);

  int get membersNeeded {
    if (roles == null) return _membersNeeded;
    return roles!
        .fold(0, (previousValue, role) => previousValue + role.membersNeeded);
  }

  List<MemberSnippet> get membersSignedUp {
    if (roles == null) return _membersSignedUp;
    return roles!.fold(
        [],
        (previousValue, role) => [
              ...previousValue,
              ...role.membersSignedUp.map((m) => m.copyWith(role: role.name))
            ]);
  }

  IconData get icon {
    switch (opportunityType) {
      case OpportunityType.project:
        return Icons.workspace_premium_outlined;
      case OpportunityType.service:
        return Icons.room_service_outlined;
      case OpportunityType.tutoring:
        return Icons.school_outlined;
    }
  }

  @override
  bool operator ==(dynamic other) {
    return other.runtimeType == runtimeType &&
        other.creatorId == creatorId &&
        other.creatorName == creatorName &&
        other.department == department &&
        other.title == title &&
        other.description == description &&
        other.date == date;
  }

  @override
  int get hashCode => "$creatorId$creatorName$title$description$date".hashCode;
}

@JsonSerializable()
class ServiceSnippet {
  String opportunityId;
  String title;
  DateTime date;
  int period;
  int? rating;
  double? credits;
  ServiceSnippet(
      {required this.opportunityId,
      required this.title,
      required this.date,
      required this.period,
      this.rating,
      this.credits});

  bool get isApproved => rating != null;

  Map<String, dynamic> toJson() => _$ServiceSnippetToJson(this);
  factory ServiceSnippet.fromJson(Map<String, dynamic> json) =>
      _$ServiceSnippetFromJson(json);

  factory ServiceSnippet.fromOpportunity(Opportunity opportunity) =>
      ServiceSnippet(
          opportunityId: opportunity.id,
          title: opportunity.title,
          date: opportunity.date,
          period: opportunity.period,
          credits: opportunity.credits);
}

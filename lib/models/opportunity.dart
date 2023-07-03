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

  MemberSnippet(
      {required this.id,
      required this.name,
      required this.email,
      required this.profilePicture});

  factory MemberSnippet.fromJson(Map<String, dynamic> json) =>
      _$MemberSnippetFromJson(json);
  Map<String, dynamic> toJson() => _$MemberSnippetToJson(this);
}

@JsonSerializable()
class Role {
  String name;
  int membersNeeded;
  List<MemberSnippet> membersSignedUp;
  Role(
      {required this.name,
      required this.membersNeeded,
      this.membersSignedUp = const []});

  @override
  String toString() {
    return "$name : $membersNeeded";
  }

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
  int membersNeeded;
  List<MemberSnippet> membersSignedUp;
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
      this.membersNeeded = 1,
      this.membersSignedUp = const [],
      this.isCompleted = false,
      this.roles,
      this.allowMultipleRoles})
      : id = const Uuid().v4();

  factory Opportunity.fromJson(Map<String, dynamic> json) =>
      _$OpportunityFromJson(json);
  Map<String, dynamic> toJson() => _$OpportunityToJson(this);

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

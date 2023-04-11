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
  int numMembersSignedUp;
  @JsonKey(includeToJson: false)
  @JsonKey(includeFromJson: false)
  List<MemberSnippet> membersSignedUp;

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
      this.numMembersSignedUp = 0,
      this.membersSignedUp = const []})
      : id = const Uuid().v4();

  factory Opportunity.fromJson(Map<String, dynamic> json) =>
      _$OpportunityFromJson(json);
  Map<String, dynamic> toJson() => _$OpportunityToJson(this);
}

@JsonSerializable()
class ServiceSnippet {
  String opportunityId;
  String title;
  DateTime date;
  int period;
  ServiceSnippet({
    required this.opportunityId,
    required this.title,
    required this.date,
    required this.period,
  });
  Map<String, dynamic> toJson() => _$ServiceSnippetToJson(this);
  factory ServiceSnippet.fromJson(Map<String, dynamic> json) =>
      _$ServiceSnippetFromJson(json);

  factory ServiceSnippet.fromOpportunity(Opportunity opportunity) =>
      ServiceSnippet(
          opportunityId: opportunity.id,
          title: opportunity.title,
          date: opportunity.date,
          period: opportunity.period);
}

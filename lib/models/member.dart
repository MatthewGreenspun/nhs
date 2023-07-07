import "package:json_annotation/json_annotation.dart";
import "package:nhs/models/index.dart";
part "member.g.dart";

@JsonSerializable()
class Member {
  String role = "member";
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? id;
  String name;
  String email;
  int graduationYear;
  double projectCredits;
  double serviceCredits;
  double tutoringCredits;
  double probationLevel;
  List<String> tutoringSubjects;
  Map<int, List<String>> freePeriods;
  List<ServiceSnippet> opportunities;

  Member(
      {required this.name,
      required this.email,
      required this.graduationYear,
      this.projectCredits = 0,
      this.serviceCredits = 0,
      this.tutoringCredits = 0,
      this.probationLevel = 0,
      this.tutoringSubjects = const [],
      this.freePeriods = const {},
      this.opportunities = const []});

  void setId(String id) => this.id = id;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
  Map<String, dynamic> toJson() => _$MemberToJson(this);
}

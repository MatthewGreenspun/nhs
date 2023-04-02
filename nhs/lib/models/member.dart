import "package:json_annotation/json_annotation.dart";
part "member.g.dart";

@JsonSerializable()
class Member {
  String role = "member";
  String name;
  String email;
  int graduationYear;
  int projectCredits;
  int serviceCredits;
  int tutoringCredits;
  int probationLevel;
  List<String> tutoringSubjects;
  Map<int, List<String>> freePeriods;

  Member(
      {required this.name,
      required this.email,
      required this.graduationYear,
      this.projectCredits = 0,
      this.serviceCredits = 0,
      this.tutoringCredits = 0,
      this.probationLevel = 0,
      this.tutoringSubjects = const [],
      this.freePeriods = const {}});

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
  Map<String, dynamic> toJson() => _$MemberToJson(this);
}

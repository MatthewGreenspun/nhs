import "package:json_annotation/json_annotation.dart";
import "package:nhs/models/index.dart";
part "approval.g.dart";

@JsonSerializable(explicitToJson: true)
class Approval {
  Opportunity opportunity;
  List<int> ratings;
  String comments;
  Approval(
      {required this.opportunity,
      required this.ratings,
      required this.comments});

  factory Approval.fromJson(Map<String, dynamic> json) =>
      _$ApprovalFromJson(json);
  Map<String, dynamic> toJson() => _$ApprovalToJson(this);
}

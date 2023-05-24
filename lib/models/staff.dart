import './opportunity.dart';
import "package:json_annotation/json_annotation.dart";
part "staff.g.dart";

@JsonSerializable()
class Staff {
  String role = "staff";
  String name;
  String email;
  String department;
  List<ServiceSnippet> posts;
  Staff(
      {required this.name,
      required this.email,
      required this.department,
      this.posts = const []});

  Map<String, dynamic> toJson() => _$StaffToJson(this);
  factory Staff.fromJson(Map<String, dynamic> json) => _$StaffFromJson(json);
}

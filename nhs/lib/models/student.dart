import 'package:nhs/models/index.dart';
import "package:json_annotation/json_annotation.dart";
part "student.g.dart";

@JsonSerializable()
class Student {
  String role = "student";
  String name;
  String email;
  int graduationYear;
  @JsonKey(includeFromJson: false)
  @JsonKey(includeToJson: false)
  List<ServiceSnippet> posts;

  Student(
      {required this.name,
      required this.email,
      required this.graduationYear,
      this.posts = const []});

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);
  Map<String, dynamic> toJson() => _$StudentToJson(this);
}

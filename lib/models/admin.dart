import "package:json_annotation/json_annotation.dart";
import "package:nhs/models/index.dart";
part "admin.g.dart";

@JsonSerializable()
class Admin {
  String role = "admin";
  String name;
  String email;
  List<ServiceSnippet> posts;

  Admin({required this.name, required this.email, this.posts = const []});

  factory Admin.fromJson(Map<String, dynamic> json) => _$AdminFromJson(json);
  Map<String, dynamic> toJson() => _$AdminToJson(this);
}

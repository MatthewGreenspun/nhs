import 'package:uuid/uuid.dart';

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

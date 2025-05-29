import 'package:json_annotation/json_annotation.dart';


part 'Skill.g.dart';

@JsonSerializable()
class Skill {
  const Skill({this.id, this.title});

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);

  final int? id;
  final String? title;

  Map<String, dynamic> toJson() => _$SkillToJson(this);
}



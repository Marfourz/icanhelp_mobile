import 'package:icanhelp/models/Skill.dart';
import 'package:icanhelp/models/User.dart';
import 'package:json_annotation/json_annotation.dart';

part 'UserProfile.g.dart';

@JsonSerializable()
class UserProfile {
  final int id;
  final User user;

  @JsonKey(name: "competences_desired", defaultValue: []) 
  final List<Skill> skillsDesired; 

  @JsonKey(name: "competences_persornal", defaultValue: []) 
  final List<Skill> skillsPersonal; 

  UserProfile({
    required this.id,
    required this.user,
    required this.skillsDesired,
    required this.skillsPersonal,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}
import 'package:icanhelp/models/Skill.dart';
import 'package:icanhelp/models/UserProfile.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Invitation.g.dart';

@JsonSerializable()
class Invitation {
  final int id;
  final DateTime createdAt;
  final String state;
  final String message;
  final UserProfile createdBy;
  final UserProfile receiver;

  @JsonKey(name: "competences_desired", defaultValue: []) 
  final List<Skill> skillsDesired;

  @JsonKey(name: "competences_personal", defaultValue: []) 
  final List<Skill> skillsPersonal;

  Invitation({
    required this.id,
    required this.createdAt,
    required this.state,
    required this.message,
    required this.createdBy,
    required this.receiver,
    required this.skillsDesired,
    required this.skillsPersonal,
  });

  /// Générer un objet Invitation à partir d'un JSON
  factory Invitation.fromJson(Map<String, dynamic> json) => _$InvitationFromJson(json);

  /// Convertir un objet Invitation en JSON
  Map<String, dynamic> toJson() => _$InvitationToJson(this);
}

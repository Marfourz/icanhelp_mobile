import 'package:json_annotation/json_annotation.dart';

part 'SendInvitation.g.dart';

@JsonSerializable()
class SendInvitation {
  final String message;
  final int receiver;
  
  @JsonKey(name: "competences_desired", defaultValue: []) 
  final List<int> skillsDesired;

  @JsonKey(name: "competences_persornal", defaultValue: []) 
  final List<int> skillsPersonal;

  SendInvitation({
    required this.message,
    required this.receiver,
    required this.skillsDesired,
    required this.skillsPersonal,
  });

  /// Générer un objet Invitation à partir d'un JSON
  factory SendInvitation.fromJson(Map<String, dynamic> json) => _$SendInvitationFromJson(json);

  /// Convertir un objet Invitation en JSON
  Map<String, dynamic> toJson() => _$SendInvitationToJson(this);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Invitation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Invitation _$InvitationFromJson(Map<String, dynamic> json) => Invitation(
  id: (json['id'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  state: json['state'] as String,
  message: json['message'] as String,
  createdBy: UserProfile.fromJson(json['createdBy'] as Map<String, dynamic>),
  receiver: UserProfile.fromJson(json['receiver'] as Map<String, dynamic>),
  skillsDesired:
      (json['competences_desired'] as List<dynamic>?)
          ?.map((e) => Skill.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  skillsPersonal:
      (json['competences_personal'] as List<dynamic>?)
          ?.map((e) => Skill.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$InvitationToJson(Invitation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt.toIso8601String(),
      'state': instance.state,
      'message': instance.message,
      'createdBy': instance.createdBy,
      'receiver': instance.receiver,
      'competences_desired': instance.skillsDesired,
      'competences_personal': instance.skillsPersonal,
    };

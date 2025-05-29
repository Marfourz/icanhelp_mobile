// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SendInvitation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendInvitation _$SendInvitationFromJson(Map<String, dynamic> json) =>
    SendInvitation(
      message: json['message'] as String,
      receiver: (json['receiver'] as num).toInt(),
      skillsDesired:
          (json['competences_desired'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
      skillsPersonal:
          (json['competences_persornal'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
    );

Map<String, dynamic> _$SendInvitationToJson(SendInvitation instance) =>
    <String, dynamic>{
      'message': instance.message,
      'receiver': instance.receiver,
      'competences_desired': instance.skillsDesired,
      'competences_persornal': instance.skillsPersonal,
    };

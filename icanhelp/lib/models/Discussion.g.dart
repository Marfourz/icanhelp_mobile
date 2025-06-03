// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Discussion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Discussion _$DiscussionFromJson(Map<String, dynamic> json) => Discussion(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  createdBy: UserProfile.fromJson(json['createdBy'] as Map<String, dynamic>),
  users:
      (json['users'] as List<dynamic>?)
          ?.map((e) => UserProfile.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  lastMessage: json['lastMessage'] as Map<String, dynamic>?,
  nbMessagesNotRead: (json['nbMessagesNotRead'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$DiscussionToJson(Discussion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'users': instance.users,
      'lastMessage': instance.lastMessage,
      'nbMessagesNotRead': instance.nbMessagesNotRead,
    };

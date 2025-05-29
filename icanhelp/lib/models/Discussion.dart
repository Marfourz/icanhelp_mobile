import 'package:json_annotation/json_annotation.dart';
import 'UserProfile.dart';
import 'Message.dart';

part 'Discussion.g.dart';

@JsonSerializable()
class Discussion {
  final int id;
  final String name;
  final DateTime createdAt;
  final UserProfile createdBy;
  @JsonKey(defaultValue: []) 
  final List<UserProfile> users;

  @JsonKey()
  final Map<String, dynamic>? lastMessage;
  
  @JsonKey(defaultValue: 0)
  final int unreadMessagesCount; 

  Discussion({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.createdBy,
    required this.users,
    this.lastMessage,
    this.unreadMessagesCount = 0,
  });


  factory Discussion.fromJson(Map<String, dynamic> json) => _$DiscussionFromJson(json);

  /// Convertir un objet Discussion en JSON
  Map<String, dynamic> toJson() => _$DiscussionToJson(this);
}

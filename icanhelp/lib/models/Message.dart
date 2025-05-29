import 'package:json_annotation/json_annotation.dart';
import 'UserProfile.dart';
import 'Message.dart';

part 'Message.g.dart';

@JsonSerializable()
class Message {
  final int id;
  final int sender;
  final DateTime createdAt;
  final String message;
  Message({
    required this.id,
    required this.createdAt,
    required this.sender,
    required this.message
  });

  /// Générer un objet Message à partir d'un JSON
  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  /// Convertir un objet Message en JSON
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}

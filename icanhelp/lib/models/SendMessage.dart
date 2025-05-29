import 'package:json_annotation/json_annotation.dart';

part 'SendMessage.g.dart';

@JsonSerializable()
class SendMessage {
  final String message;

  SendMessage({
    required this.message,
  });

  /// Générer un objet Invitation à partir d'un JSON
  factory SendMessage.fromJson(Map<String, dynamic> json) => _$SendMessageFromJson(json);

  /// Convertir un objet Invitation en JSON
  Map<String, dynamic> toJson() => _$SendMessageToJson(this);
}

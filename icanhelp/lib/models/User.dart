import 'package:json_annotation/json_annotation.dart';


part 'User.g.dart';

@JsonSerializable()
class User {
  const User({this.id, this.username, this.email});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  final int? id;
  final String? username;
  final String? email;

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';
@JsonSerializable()
class User {
  final String? id;
  final String name;
  final String email;

  User({
     this.id,
    required this.name,
    required this.email,
  });

  // Фабрика для десериализации из JSON
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  // Метод для сериализации в JSON
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
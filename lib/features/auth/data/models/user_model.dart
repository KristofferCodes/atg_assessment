import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String? id;
  final String? email;
  final String? name;
  final String? token;

  const UserModel({
    this.id,
    this.email,
    this.name,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserEntity toEntity() => UserEntity(
        id: id ?? '',
        email: email ?? '',
        name: name ?? '',
        token: token ?? '',
      );
}
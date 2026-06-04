import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String? id;
  final String? email;
  final String? name;
  @JsonKey(name: 'first_name')
  final String? firstName;
  @JsonKey(name: 'last_name')
  final String? lastName;
  final String? token;

  const UserModel({
    this.id,
    this.email,
    this.name,
    this.firstName,
    this.lastName,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserEntity toEntity() => UserEntity(
        id: id ?? '',
        email: email ?? '',
        firstName: firstName?.trim() ?? name?.split(' ').first ?? '',
        lastName: lastName?.trim() ??
            (name != null && name!.contains(' ')
                ? name!.split(' ').skip(1).join(' ')
                : ''),
        token: token ?? '',
      );
}
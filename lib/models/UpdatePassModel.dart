import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UpdatePasswordModel{
  final String? password;
  UpdatePasswordModel({this.password});
  factory UpdatePasswordModel.fromJson(Map<String, dynamic> parsedJson){
    return UpdatePasswordModel(
      password:parsedJson['password'],
    );
  }
  Map<String, dynamic> toJson() => _$UpdatePasswordToJson(this);
  Map<String, dynamic> _$UpdatePasswordToJson(UpdatePasswordModel instance) => <String, dynamic>{
    'password': instance.password,
  };
}
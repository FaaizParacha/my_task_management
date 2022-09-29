import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class LoginModel{
  final String? email;
  final String? password;
  final String? token;
  final String? status;
  LoginModel({this.password,this.email,this.token,this.status});
  factory LoginModel.fromJson(Map<String, dynamic> parsedJson){
    return LoginModel(
      password:parsedJson['password'],
      email:parsedJson['email'],
      token: parsedJson['token'],
      status: parsedJson['status']
    );
  }
  Map<String, dynamic> toJson() => _$LoginToJson(this);
  Map<String, dynamic> _$LoginToJson(LoginModel instance) => <String, dynamic>{
    'password': instance.password,
    'email':instance.email,
    'token':instance.token,
    'status':instance.status
  };
}

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UpdateProfile{
  final String? status;
  Profile? profile;
  User user;
  UpdateProfile({this.status, this.profile,required this.user});
  factory UpdateProfile.fromJson(Map<String, dynamic> parsedJson){
    return UpdateProfile(
        profile:Profile.fromJson(parsedJson['profile']),
        user:User.fromJson(parsedJson['user'])
    );
  }
  Map<String, dynamic> toJson() => _$UpdateProfileToJson(this);
  Map<String, dynamic> _$UpdateProfileToJson(UpdateProfile instance) => <String, dynamic>{
    'profile': instance.profile,
    'user': instance.user,
  };
}
class Profile {
  final String? phone;

  Profile({this.phone
  });
  factory Profile.fromJson(Map<String, dynamic> parsedJson){
    return Profile(
        phone:parsedJson['phone'],
    );
  }
}

class User {
  String? first_name;
  String? last_name;
  String? email;
  User({ this.first_name,this.last_name,this.email});

  factory User.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileToJson(this);
}
User _$CommentModelFromJson(Map<String, dynamic> json) {
  return User(
    first_name: json['first_name'],
    last_name: json['last_name'] ,
      email:json['email']
  );
}
Map<String, dynamic> _$UpdateProfileToJson(User instance) => <String, dynamic>{
  'first_name': instance.first_name,
  'last_name': instance.last_name,
  'email':instance.email
};






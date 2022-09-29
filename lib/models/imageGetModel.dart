import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ImageGetModel{
  final String? message;
  final String? uploaded_image;
  final String? status;
  ImageGetModel({this.message,this.uploaded_image,this.status});
  factory ImageGetModel.fromJson(Map<String, dynamic> parsedJson){
    return ImageGetModel(
        message:parsedJson['message'],
        uploaded_image:parsedJson['uploaded_image'],
        status: parsedJson['status']
    );
  }
  Map<String, dynamic> toJson() => _$LoginToJson(this);
  Map<String, dynamic> _$LoginToJson(ImageGetModel instance) => <String, dynamic>{
    'message': instance.message,
    'uploaded_image':instance.uploaded_image,
    'status':instance.status
  };
}
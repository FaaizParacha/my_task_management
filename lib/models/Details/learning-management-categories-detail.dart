import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class LearningManagementDetailModel{
  final String? status;
  categoryTask task;
  LearningManagementDetailModel({this.status,required this.task});
  factory LearningManagementDetailModel.fromJson(Map<String, dynamic> parsedJson){

    return LearningManagementDetailModel(
        task:categoryTask.fromJson(parsedJson['task'])
    );
  }

}
class categoryTask {
  final int? id;
  final String? title;
  final String? post;
  final String? user;
  final bool? acceptance_required;
  final bool? comments_allowed;
  final String? accepted;
  final List? comments;

  categoryTask({this.id, this.title,
    this.post,this.user,this.acceptance_required,//this.prize,
    this.comments_allowed,this.accepted,this.comments//this.distance_furlong_rounded
  });
  factory categoryTask.fromJson(Map<String, dynamic> parsedJson){
    return categoryTask(
        id:parsedJson['id'],
        title:parsedJson['title'],
        post:parsedJson['post'],
        user:parsedJson['user'],
        acceptance_required: parsedJson['acceptance_required'],
        comments_allowed:parsedJson['comments_allowed'],
        accepted:parsedJson['accepted'],
        comments: parsedJson['comments']
    );
  }
}









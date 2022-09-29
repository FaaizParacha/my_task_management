import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class NewsDetailModel{
  final String? status;
  newsTask task;
  NewsDetailModel({this.status,required this.task});
  factory NewsDetailModel.fromJson(Map<String, dynamic> parsedJson){

    return NewsDetailModel(
        task:newsTask.fromJson(parsedJson['task'])
    );
  }

}
class newsTask {
  final int? id;
  final String? title;
  final String? post;
  final String? user;
  final bool? acceptance_required;
  final bool? comments_allowed;
  final String? accepted;
  final List? comments;

  newsTask({this.id, this.title,
    this.post,this.user,this.acceptance_required,//this.prize,
    this.comments_allowed,this.accepted,this.comments//this.distance_furlong_rounded
  });
  factory newsTask.fromJson(Map<String, dynamic> parsedJson){
    return newsTask(
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









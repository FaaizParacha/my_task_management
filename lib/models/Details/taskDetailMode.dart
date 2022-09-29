
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class TaskDetailModel{
  final String? status;
  TaskOfTasks? task;
  TaskDetailModel({this.status, this.task});
  factory TaskDetailModel.fromJson(Map<String, dynamic> parsedJson){
    return TaskDetailModel(
        task:TaskOfTasks.fromJson(parsedJson['task'])
    );
  }
  Map<String, dynamic> toJson() => _$TaskDetailModelToJson(this);
  Map<String, dynamic> _$TaskDetailModelToJson(TaskDetailModel instance) => <String, dynamic>{
    'task': instance.task!.comments,
  };
}
class TaskOfTasks {
  final int? id;
  final String? title;
  final String? post;
  final String? user;
  final bool? acceptance_required;
  final bool? comments_allowed;
  final String? accepted;
  final List<CommentModel>? comments;

  TaskOfTasks({this.id, this.title,
    this.post,this.user,this.acceptance_required,//this.prize,
    this.comments_allowed,this.accepted, this.comments//this.distance_furlong_rounded
  });
  factory TaskOfTasks.fromJson(Map<String, dynamic> parsedJson){
    List<dynamic> list = parsedJson['comments'] ;
    print(list.runtimeType);
    List<CommentModel> formdata = list.map((i) => CommentModel.fromJson(i)).toList();
    return TaskOfTasks(
        id:parsedJson['id'],
        title:parsedJson['title'],
        post:parsedJson['post'],
        user:parsedJson['user'],
        acceptance_required: parsedJson['acceptance_required'],
        comments_allowed:parsedJson['comments_allowed'],
        accepted:parsedJson['accepted'],
        comments: formdata
    );
  }
}




class CommentModel {
  int? id;
  String? dated;
  int? userId;
  String? userName;
  String? comment;

  CommentModel({ this.id, this.dated, this.userId, this.userName, this.comment
  });
  factory CommentModel.fromJson(Map<String, dynamic> json) =>
      _$CommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);
}

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) {
  return CommentModel(
    id: json['id'],
    dated: json['dated'] ,
    userId: json['user_id'],
    userName: json['user_name'] as String?,
    comment:  json['comment'] as String?,

  );
}

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) => <String, dynamic>{
  'dated': instance.dated,
  'id': instance.id,
  'user_id': instance.userId,
  'user_name': instance.userName,
  'comment' : instance.comment,
};






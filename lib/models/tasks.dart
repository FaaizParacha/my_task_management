class Tasks{
  final String? status;
  final List<TasksList> list;
  Tasks({this.status,required this.list});

  factory Tasks.fromJson(Map<String, dynamic> json){
    List<dynamic> list = json['list'] ;
    print(list.runtimeType);
    List<TasksList> tasksListdata = list.map((i) => TasksList.fromJson(i)).toList();
    return  Tasks(
        status: json['status'],
        list: tasksListdata
    );
  }
}
class TasksList {
  final int? id;
  final String? message;
  final String? description;
  final String? status;
  final int? category_id;
  final String? dated;
  final String? image;
  final bool? read;
  // final double? prize;
  // final int? prize1;
  TasksList({this.id, this.message,//this.prize1,
    this.description,this.category_id,this.dated,//this.prize,
    this.status,this.read,this.image//this.distance_furlong_rounded
  });
  factory TasksList.fromJson(Map<String, dynamic> parsedJson){
    return TasksList(
      id:parsedJson['id'],
      message:parsedJson['message'],
      status:parsedJson['status'],
      category_id:parsedJson['category_id'],
      description: parsedJson['description'],
      dated:parsedJson['dated'],
      read:parsedJson['read'],
      image: parsedJson['image']
    );
  }
}
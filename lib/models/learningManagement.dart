class LearningManagementModel{
  final String? status;
  final List<LearningManagementModelList> list;
  LearningManagementModel({this.status,required this.list});

  factory LearningManagementModel.fromJson(Map<String, dynamic> json){
    List<dynamic> list = json['list'] ;
    print(list.runtimeType);
    List<LearningManagementModelList> tasksListdata = list.map((i) =>
        LearningManagementModelList.fromJson(i)).toList();
    return  LearningManagementModel(
        status: json['status'],
        list: tasksListdata
    );
  }
}
class LearningManagementModelList {
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
  LearningManagementModelList({this.id, this.message,//this.prize1,
    this.description,this.category_id,this.dated,//this.prize,
    this.status,this.read,this.image//this.distance_furlong_rounded
  });
  factory LearningManagementModelList.fromJson(Map<String, dynamic> parsedJson){
    return LearningManagementModelList(
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
class NewsModel{
  final String? status;
  final List<NewsList> list;
  NewsModel({this.status,required this.list});

  factory NewsModel.fromJson(Map<String, dynamic> json){
    List<dynamic> list = json['list'] ;
    print(list.runtimeType);
    List<NewsList> tasksListdata = list.map((i) =>
        NewsList.fromJson(i)).toList();
    return  NewsModel(
        status: json['status'],
        list: tasksListdata
    );
  }
}
class NewsList {
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
  NewsList({this.id, this.message,//this.prize1,
    this.description,this.category_id,this.dated,//this.prize,
    this.status,this.read,this.image//this.distance_furlong_rounded
  });
  factory NewsList.fromJson(Map<String, dynamic> parsedJson){
    return NewsList(
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
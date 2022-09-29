class MyPayrollModel{
  final String? status;
  final List<MyPayrollModelList> list;
  MyPayrollModel({this.status,required this.list});

  factory MyPayrollModel.fromJson(Map<String, dynamic> json){
    List<dynamic> list = json['list'] ;
    print(list.runtimeType);
    List<MyPayrollModelList> tasksListdata = list.map((i) =>
        MyPayrollModelList.fromJson(i)).toList();
    return  MyPayrollModel(
        status: json['status'],
        list: tasksListdata
    );
  }
}
class MyPayrollModelList {
  final int? id;
  final String? message;
  final String? status;
  final String? dated;
  final String? leave;
  // final double? prize;
  // final int? prize1;
  MyPayrollModelList({this.id, this.message,this.dated,this.leave,
    this.status,
  });
  factory MyPayrollModelList.fromJson(Map<String, dynamic> parsedJson){
    return MyPayrollModelList(
        id:parsedJson['id'],
        message:parsedJson['message'],
        status:parsedJson['status'],
        dated:parsedJson['dated'],
      leave: parsedJson['leave']
    );
  }
}


class MyPayrollModelFailed {
  final String? message;
  final String? status;


  MyPayrollModelFailed({ this.message,this.status});
  factory MyPayrollModelFailed.fromJson(Map<String, dynamic> parsedJson){
    return MyPayrollModelFailed(
        message:parsedJson['message'],
        status:parsedJson['status'],
    );
  }
}
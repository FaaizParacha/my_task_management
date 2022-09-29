class PunchOutModel{
  final String? status;
  final String? message;
  PunchOutModel({this.status, this.message});

  factory PunchOutModel.fromJson(Map<String, dynamic> json){
    return  PunchOutModel(
        status: json['status'],
        message: json['message']
    );
  }
}
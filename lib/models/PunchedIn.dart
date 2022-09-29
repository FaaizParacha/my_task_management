class PunchInModel{
  final String? status;
  final String? message;
  PunchInModel({this.status, this.message});

  factory PunchInModel.fromJson(Map<String, dynamic> json){
    return  PunchInModel(
        status: json['status'],
        message: json['message']
    );
  }
}
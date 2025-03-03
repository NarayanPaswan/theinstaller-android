class UserTypeModel {
  int? status;
  List<Data>? data;

  UserTypeModel({this.status, this.data});

  UserTypeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

 
}

class Data {
  int? id;
  String? usertype;

  Data({this.id, this.usertype});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usertype = json['usertype'];
  }

  
}

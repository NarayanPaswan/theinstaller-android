class StatusModel {
  int? status;
  List<Items>? items;

  StatusModel({this.status, this.items});

  StatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

}

class Items {
  int? id;
  String? statusList;

  Items({this.id, this.statusList});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    statusList = json['status_list'];
  }


}

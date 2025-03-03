class GenderModel {
  int? status;
  List<Items>? items;

  GenderModel({this.status, this.items});

  GenderModel.fromJson(Map<String, dynamic> json) {
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
  String? name;

  Items({this.id, this.name});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

}
class SalutationModel {
  int? status;
  List<Items>? items;

  SalutationModel({this.status, this.items});

  SalutationModel.fromJson(Map<String, dynamic> json) {
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
  String? salutationList;
  String? status;

  Items({this.id, this.salutationList, this.status});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salutationList = json['salutation_list'];
    status = json['status'];
  }


}

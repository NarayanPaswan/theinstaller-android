class YesNoModel {
  int? status;
  List<Items>? items;

  YesNoModel({this.status, this.items});

  YesNoModel.fromJson(Map<String, dynamic> json) {
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
  String? yesNoList;

  Items({this.id, this.yesNoList});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    yesNoList = json['yes_no_list'];
  }


}

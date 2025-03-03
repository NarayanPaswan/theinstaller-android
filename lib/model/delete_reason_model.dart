class DeleteReasonModel {
  int? status;
  List<Items>? items;

  DeleteReasonModel({this.status, this.items});

  DeleteReasonModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? id;
  String? reasonList;
  int? status;

  Items({this.id, this.reasonList, this.status});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reasonList = json['reason_list'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['reason_list'] = this.reasonList;
    data['status'] = this.status;
    return data;
  }
}

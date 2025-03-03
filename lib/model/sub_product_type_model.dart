class SubProductTypeModel {
  int? status;
  List<Items>? items;

  SubProductTypeModel({this.status, this.items});

  SubProductTypeModel.fromJson(Map<String, dynamic> json) {
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
  String? subProductList;
  int? typeOfProductId;
  String? status;
  String? createdAt;
  String? updatedAt;

  Items(
      {this.id,
      this.subProductList,
      this.typeOfProductId,
      this.status,
      this.createdAt,
      this.updatedAt});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subProductList = json['sub_product_list'];
    typeOfProductId = json['type_of_product_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  
}

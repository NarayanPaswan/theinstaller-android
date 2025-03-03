class ProductTypeModel {
  int? status;
  List<Items>? items;

  ProductTypeModel({this.status, this.items});

  ProductTypeModel.fromJson(Map<String, dynamic> json) {
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
  String? productList;
  String? status;

  Items({this.id, this.productList, this.status});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productList = json['product_list'];
    status = json['status'];
  }

 
}

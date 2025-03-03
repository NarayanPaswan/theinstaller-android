class ServiceCentreModel {
  int? status;
  List<Items>? items;

  ServiceCentreModel({this.status, this.items});

  ServiceCentreModel.fromJson(Map<String, dynamic> json) {
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
  String? place;
  String? latitude;
  String? longitude;
  int? status;
  String? createdAt;
  String? updatedAt;

  Items(
      {this.id,
      this.place,
      this.latitude,
      this.longitude,
      this.status,
      this.createdAt,
      this.updatedAt});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    place = json['place'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

 
}

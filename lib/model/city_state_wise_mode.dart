
class CityStateWiseModel {
  int status;
  List<Item> items;

  CityStateWiseModel({
    required this.status,
    required this.items,
  });

  factory CityStateWiseModel.fromJson(Map<String, dynamic> json) => CityStateWiseModel(
    status: json["status"],
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
  };
}

class Item {
  int id;
  int stateId;
  String cityName;

  Item({
    required this.id,
    required this.stateId,
    required this.cityName,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    stateId: json["state_id"],
    cityName: json["city_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "state_id": stateId,
    "city_name": cityName,
  };
}

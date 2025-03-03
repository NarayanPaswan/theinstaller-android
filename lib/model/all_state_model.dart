
class AllStateModel {
  int status;
  List<Item> items;

  AllStateModel({
    required this.status,
    required this.items,
  });

  factory AllStateModel.fromJson(Map<String, dynamic> json) => AllStateModel(
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
  String stateName;

  Item({
    required this.id,
    required this.stateName,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json["id"],
    stateName: json["state_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "state_name": stateName,
  };
}

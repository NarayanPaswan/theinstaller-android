class PaymentModeModel {
  int? status;
  List<Items>? items;

  PaymentModeModel({this.status, this.items});

  PaymentModeModel.fromJson(Map<String, dynamic> json) {
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
  String? paymentMethodName;

  Items({this.id, this.paymentMethodName});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paymentMethodName = json['payment_method_name'];
  }

}

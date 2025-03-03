class OnboardingModel {
  int? status;
  List<Data>? data;

  OnboardingModel({this.status, this.data});

  OnboardingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  
}

class Data {
  String? image;
  String? title;
  String? subTitle;
  String? moreServices;

  Data({this.image, this.title, this.subTitle, this.moreServices});

  Data.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    title = json['title'];
    subTitle = json['sub_title'];
    moreServices = json['more_services'];
  }

}

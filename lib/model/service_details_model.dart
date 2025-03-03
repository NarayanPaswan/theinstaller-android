class ServiceDetailsModel {
  int? status;
  List<Items>? items;

  ServiceDetailsModel({this.status, this.items});

  ServiceDetailsModel.fromJson(Map<String, dynamic> json) {
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
  String? image;
  String? serviceCode;
  String? clientName;
  String? clientEmailAddress;
  String? clientMobileNumber;
  String? clientAlternateMobileNumber;
  String? dateTime;
  int? taskTypeId;
  String? measurement;
  String? descriptions;
  int? actionTypeId;
  int? assignedAgentId;
  int? dealerId;
  String? serviceCharge;
  String? slug;
  String? metaData;
  String? createdAt;
  String? updatedAt;
  String? remarks;
  String? notes;
  int? paymentModeId;
  int? createdByUserId;
  String? address;
  String? typeOfMeasurement;
  String? typeOfMaterial;
  int? employeeOf;
  int? status;
  int? coordinate;
  String? landmark;
  String? quantity;
  String? bookingDateTime;
  int? salut;
  Tasktype? tasktype;
  ServiceCreator? serviceCreator;
  PaymentMode? paymentMode;
  AcceptNotificationType? acceptNotificationType;
  List<ServiceImageData>? serviceImageData;
  SalutationData? salutationData;
  int? typeOfProductId;
  String? subProductId;
  List<SubProducts>? subProducts;
  TypeOfProduct? typeOfProduct;
  String? messageNintyOneStatus;
  List<ServiceVideoData>? serviceVideoData;

  Items(
      {this.id,
      this.image,
      this.serviceCode,
      this.clientName,
      this.clientEmailAddress,
      this.clientMobileNumber,
      this.clientAlternateMobileNumber,
      this.dateTime,
      this.taskTypeId,
      this.measurement,
      this.descriptions,
      this.actionTypeId,
      this.assignedAgentId,
      this.dealerId,
      this.serviceCharge,
      this.slug,
      this.metaData,
      this.createdAt,
      this.updatedAt,
      this.remarks,
      this.notes,
      this.paymentModeId,
      this.createdByUserId,
      this.address,
      this.typeOfMeasurement,
      this.typeOfMaterial,
      this.employeeOf,
      this.status,
      this.coordinate,
      this.landmark,
      this.quantity,
      this.bookingDateTime,
      this.salut,
      this.tasktype,
      this.serviceCreator,
      this.paymentMode,
      this.acceptNotificationType,
      this.serviceImageData,
      this.salutationData,
      this.typeOfProductId,
      this.subProductId,
      this.subProducts,
      this.typeOfProduct,
      this.messageNintyOneStatus,
      this.serviceVideoData
      });

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    serviceCode = json['service_code'];
    clientName = json['client_name'];
    clientEmailAddress = json['client_email_address'];
    clientMobileNumber = json['client_mobile_number'];
    clientAlternateMobileNumber = json['client_alternate_mobile_number'];
    dateTime = json['date_time'];
    taskTypeId = json['task_type_id'];
    measurement = json['measurement'];
    // notificationtype = json['notification_type'];
    descriptions = json['descriptions'];
    actionTypeId = json['action_type_id'];
    assignedAgentId = json['assigned_agent_id'];
    dealerId = json['dealer_id'];
    serviceCharge = json['service_charge'];
    slug = json['slug'];
    metaData = json['meta_data'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    remarks = json['remarks'];
    notes = json['notes'];
    paymentModeId = json['payment_mode_id'];
    createdByUserId = json['created_by_user_id'];
    address = json['address'];
    typeOfMeasurement = json['type_of_measurement'];
    typeOfMaterial = json['type_of_material'];
    employeeOf = json['employee_of'];
    status = json['status'];
    coordinate = json['coordinate'];
    landmark = json['landmark'];
    quantity = json['quantity'];
    bookingDateTime = json['booking_date_time'];
    salut = json['salut'];
    typeOfProductId = json['type_of_product_id'];
    subProductId = json['sub_product_id'];
    if (json['sub_products'] != null) {
      subProducts = <SubProducts>[];
      json['sub_products'].forEach((v) {
        subProducts!.add(SubProducts.fromJson(v));
      });
    }
    messageNintyOneStatus = json['message_ninty_one_status'];
    tasktype = json['tasktype'] != null
        ? Tasktype.fromJson(json['tasktype'])
        : null;
 
    serviceCreator = json['service_creator'] != null
        ? ServiceCreator.fromJson(json['service_creator'])
        : null;
    paymentMode = json['payment_mode'] != null
        ? PaymentMode.fromJson(json['payment_mode'])
        : null;
    acceptNotificationType = json['accept_notification_type'] != null
        ? AcceptNotificationType.fromJson(json['accept_notification_type'])
        : null;

    if (json['service_image_data'] != null) {
      serviceImageData = <ServiceImageData>[];
      json['service_image_data'].forEach((v) {
        serviceImageData!.add(ServiceImageData.fromJson(v));
      });
    }

    if (json['service_video_data'] != null) {
      serviceVideoData = <ServiceVideoData>[];
      json['service_video_data'].forEach((v) {
        serviceVideoData!.add(ServiceVideoData.fromJson(v));
      });
    }
     
    salutationData = json['salutation_data'] != null
        ? SalutationData.fromJson(json['salutation_data'])
        : null;

     typeOfProduct = json['type_of_product'] != null
        ? TypeOfProduct.fromJson(json['type_of_product'])
        : null;   
  }

  
}

class SubProducts {
  int? id;
  String? subProductList;
  int? typeOfProductId;

  SubProducts({this.id, this.subProductList, this.typeOfProductId});

  SubProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subProductList = json['sub_product_list'];
    typeOfProductId = json['type_of_product_id'];
  }


}




class Tasktype {
  int? id;
  String? taskName;

  Tasktype({this.id, this.taskName});

  Tasktype.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskName = json['task_name'];
  }

 
}


class ServiceCreator {
  int? id;
  String? name;
  String? companyName;
  String? avatar;
  int? coordinate;
  CoordinateData? coordinateData;

  ServiceCreator(
      {this.id,
      this.name,
      this.companyName,
      this.avatar,
      this.coordinate,
      this.coordinateData});

  ServiceCreator.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    companyName = json['company_name'];
    avatar = json['avatar'];
    coordinate = json['coordinate'];
    coordinateData = json['coordinate_data'] != null
        ? CoordinateData.fromJson(json['coordinate_data'])
        : null;
  }


}

class CoordinateData {
  int? id;
  String? place;
  String? latitude;
  String? longitude;
  int? status;
  String? createdAt;
  String? updatedAt;

  CoordinateData(
      {this.id,
      this.place,
      this.latitude,
      this.longitude,
      this.status,
      this.createdAt,
      this.updatedAt});

  CoordinateData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    place = json['place'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }


}

class PaymentMode {
  int? id;
  String? paymentMethodName;

  PaymentMode({this.id, this.paymentMethodName});

  PaymentMode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paymentMethodName = json['payment_method_name'];
  }


}
class AcceptNotificationType {
  int? id;
  int? serviceId;
  String? notificationType;

  AcceptNotificationType({this.id, this.serviceId, this.notificationType});

  AcceptNotificationType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceId = json['service_id'];
    notificationType = json['notification_type'];
  }


}

class ServiceImageData {
  int? id;
  int? serviceId;
  String? imageFile;
  String? caption;

  ServiceImageData({this.id, this.serviceId, this.imageFile, this.caption});

  ServiceImageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceId = json['service_id'];
    imageFile = json['image_file'];
    caption = json['caption'];
  }


}

class SalutationData {
  int? id;
  String? salutationList;

  SalutationData({this.id, this.salutationList});

  SalutationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salutationList = json['salutation_list'];
  }


}

class TypeOfProduct {
  int? id;
  String? productList;

  TypeOfProduct({this.id, this.productList});

  TypeOfProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productList = json['product_list'];
  }
}

class ServiceVideoData {
  int? id;
  int? serviceId;
  String? videoFile;
  String? caption;

  ServiceVideoData({this.id, this.serviceId, this.videoFile, this.caption});

  ServiceVideoData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceId = json['service_id'];
    videoFile = json['video_file'];
    caption = json['caption'];
  }


}
class BookingCompletedDetailsModel {
  int? status;
  List<Items>? items;

  BookingCompletedDetailsModel({this.status, this.items});

  BookingCompletedDetailsModel.fromJson(Map<String, dynamic> json) {
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
  Tasktype? tasktype;
  ServiceCreator? serviceCreator;
  PaymentMode? paymentMode;
  List<TaskUpadatedByAgent>? taskUpadatedByAgent;
  String? landmark;
  String? quantity;
  int? salut;
  SalutationData? salutationData;

  int? typeOfProductId;
  String? subProductId;
  List<SubProducts>? subProducts;
  TypeOfProduct? typeOfProduct;


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
      this.tasktype,
      this.serviceCreator,
      this.paymentMode,
      this.taskUpadatedByAgent,
      this.landmark,
      this.quantity,
      this.salut,
      this.salutationData,
      this.typeOfProductId,
      this.subProductId,
      this.subProducts,
      this.typeOfProduct
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
    
    typeOfProductId = json['type_of_product_id'];
    subProductId = json['sub_product_id'];
    if (json['sub_products'] != null) {
      subProducts = <SubProducts>[];
      json['sub_products'].forEach((v) {
        subProducts!.add(SubProducts.fromJson(v));
      });
    }

    tasktype = json['tasktype'] != null
        ? Tasktype.fromJson(json['tasktype'])
        : null;
    serviceCreator = json['service_creator'] != null
        ? ServiceCreator.fromJson(json['service_creator'])
        : null;
    paymentMode = json['payment_mode'] != null
        ? PaymentMode.fromJson(json['payment_mode'])
        : null;
    if (json['task_upadated_by_agent'] != null) {
      taskUpadatedByAgent = <TaskUpadatedByAgent>[];
      json['task_upadated_by_agent'].forEach((v) {
        taskUpadatedByAgent!.add(TaskUpadatedByAgent.fromJson(v));
      });
    }
     landmark = json['landmark'];
    quantity = json['quantity'];     
    salut = json['salut'];

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

  ServiceCreator({this.id, this.name, this.companyName});

  ServiceCreator.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    companyName = json['company_name'];
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

class TaskUpadatedByAgent {
  int? id;
  int? serviceId;
  String? form;
  String? remarks;
  int? status;
  int? createdBy;
  String? createdDate;
  String? createdTime;
  String? createdAt;
  String? updatedAt;
  int? paymentCollected;
  String? serviceCharge;
  List<FormImageData>? formImageData;
  List<SiteImageData>? siteImageData;

  TaskUpadatedByAgent(
      {this.id,
      this.serviceId,
      this.form,
      this.remarks,
      this.status,
      this.createdBy,
      this.createdDate,
      this.createdTime,
      this.createdAt,
      this.updatedAt,
      this.paymentCollected,
      this.serviceCharge,
      this.formImageData,
      this.siteImageData});

  TaskUpadatedByAgent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceId = json['service_id'];
    form = json['form'];
    remarks = json['remarks'];
    status = json['status'];
    createdBy = json['created_by'];
    createdDate = json['created_date'];
    createdTime = json['created_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    paymentCollected = json['payment_collected'];
    serviceCharge = json['service_charge'];
    if (json['form_image_data'] != null) {
      formImageData = <FormImageData>[];
      json['form_image_data'].forEach((v) {
        formImageData!.add(FormImageData.fromJson(v));
      });
    }
    if (json['site_image_data'] != null) {
      siteImageData = <SiteImageData>[];
      json['site_image_data'].forEach((v) {
        siteImageData!.add(SiteImageData.fromJson(v));
      });
    }
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

class FormImageData {
  int? id;
  int? serviceUpdatedByAgentId;
  String? formImageFile;
  String? caption;
  String? createdAt;
  String? updatedAt;

  FormImageData(
      {this.id,
      this.serviceUpdatedByAgentId,
      this.formImageFile,
      this.caption,
      this.createdAt,
      this.updatedAt});

  FormImageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceUpdatedByAgentId = json['service_updated_by_agent_id'];
    formImageFile = json['form_image_file'];
    caption = json['caption'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

 
}

class SiteImageData {
  int? id;
  int? serviceUpdatedByAgentId;
  String? siteImageFile;
  String? caption;
  String? createdAt;
  String? updatedAt;

  SiteImageData(
      {this.id,
      this.serviceUpdatedByAgentId,
      this.siteImageFile,
      this.caption,
      this.createdAt,
      this.updatedAt});

  SiteImageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceUpdatedByAgentId = json['service_updated_by_agent_id'];
    siteImageFile = json['site_image_file'];
    caption = json['caption'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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


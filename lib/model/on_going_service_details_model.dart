class OnGoingServiceDetailsModel {
  int? status;
  List<Items>? items;

  OnGoingServiceDetailsModel({this.status, this.items});

  OnGoingServiceDetailsModel.fromJson(Map<String, dynamic> json) {
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
  AssignedAgent? assignedAgent;
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
      this.assignedAgent,
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
        subProducts!.add(new SubProducts.fromJson(v));
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
    assignedAgent = json['assigned_agent'] != null
        ? AssignedAgent.fromJson(json['assigned_agent'])
        : null;
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

class AssignedAgent {
  int? id;
  int? serviceId;
  int? assignedBy;
  int? agent;
  String? assignedDate;
  String? assignedTime;
  String? createdAt;
  String? updatedAt;
  AgentName? agentName;

  AssignedAgent(
      {this.id,
      this.serviceId,
      this.assignedBy,
      this.agent,
      this.assignedDate,
      this.assignedTime,
      this.createdAt,
      this.updatedAt,
      this.agentName});

  AssignedAgent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceId = json['service_id'];
    assignedBy = json['assigned_by'];
    agent = json['agent'];
    assignedDate = json['assigned_date'];
    assignedTime = json['assigned_time'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    agentName = json['agent_name'] != null
        ? AgentName.fromJson(json['agent_name'])
        : null;
  }

 
}

class AgentName {
  int? id;
  String? name;
  String? avatar;
  AgentName({this.id, this.name, this.avatar});

  AgentName.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
    
  }

  

 
}

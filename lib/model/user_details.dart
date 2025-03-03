// To parse this JSON data, do
//
//     final userDetails = userDetailsFromJson(jsonString);

class UserDetails {
  int? id;
  // ignore: prefer_typing_uninitialized_variables
  var avatar;
  String? image;
  String? name;
  String? companyName;
  String? email;
  String? mobileNumber;
  String? dateOfBirth;
  String? address;
  String? landmark;
  int? city;
  int? state;
  String? pinCode;
  int? genderId;
  // ignore: prefer_typing_uninitialized_variables
  var status;

  UserDetails({
    this.id,
    this.avatar,
    this.image,
    this.name,
    this.companyName,
    this.email,
    this.mobileNumber,
    this.status,
    this.state,
    this.city,
    this.landmark,
    this.address,
    this.dateOfBirth,
    this.pinCode,
    this.genderId
  });

   UserDetails.fromJson(Map<String, dynamic> json) {
   avatar = json['avatar'];
   image = json['image'];
   id = json['id'];
   name = json['name'];
   companyName = json['company_name'];
   email = json['email'];
   mobileNumber = json['mobile_number'];
   status = json['status'];
   dateOfBirth = json['date_of_birth'];
   address = json['address'];
   landmark = json['landmark'];
   city = json['city'];
   state = json['state'];
   pinCode = json['pin_code'];
   genderId = json['gender_id'];
   }

}

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:theinstallers/model/service_centre_model.dart';
import 'package:theinstallers/model/user_type_model.dart';
import '../../model/onboarding_model.dart';
import '../database/database_controller_provider.dart';
import '../../utils/exports.dart';

class AuthenticationControllerProvider extends ChangeNotifier {
  final dio = Dio();
  //setter
  bool _isLoading = false;
  String _responseMessage = '';
  //getter
  bool get isLoading => _isLoading;
  String get responseMessage => _responseMessage;

 String _newRoleId = '';
 String get newRoleId => _newRoleId;
  

  bool _obscurePassword =true;
  bool get obscurePassword => _obscurePassword;
  set obscurePassword(bool obscureText) {
    _obscurePassword = obscureText;
    notifyListeners();
  }

  bool _obscureConfirmPassword =true;
   bool get obscureConfirmPassword => _obscureConfirmPassword;
  set obscureConfirmPassword(bool obscureConfirmText) {
    _obscureConfirmPassword = obscureConfirmText;
    notifyListeners();
  }

   String _passwordValue ='';
  String get password => _passwordValue;
  set passwordValue(String passwordValue){
    _passwordValue = passwordValue;
    notifyListeners();
  }

  String? validateConfirmPassword(String value) {

    if(value.isEmpty){
      return 'Please enter confirm password';
    }
    else if(value != password){
      return 'Confirm password does not match.';
    }
    else{
      return null;
    }

  }

  String? validatePassword(String value) {

    if (value.isEmpty) {
      return 'Please enter password';
    } else if(value.length< 8){
      return 'Password can not be less than 8 char.';
    }
    else{
      return null;
    }

  }

  String? emailValidate(String value){
    const String format = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    return !RegExp(format).hasMatch(value) ? "Enter valid email" : null;
  }

  String? mobileNumberValidator(String value) {
    if (value.isEmpty) {
      return 'Please enter your Mobile Number';
    } else if(value.length > 10 || value.length < 10){
      return 'Please enter your 10 digit Mobile Number';
    }
    else {
      return null;
    }
  }

   String? validateBlankField(String value) {
 
    if (value.isEmpty) {
          return 'Data required here';
    }
    return null;
   }

   String? emailOrMobileValidate(String value) {
    // Check if it's a valid email
      const String emailFormat =
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";

      // Check if it's a valid mobile number
      const String mobileNumberFormat = r"^\d{10}$"; // Assuming a 10-digit format

      if (!RegExp(emailFormat).hasMatch(value) && !RegExp(mobileNumberFormat).hasMatch(value)) {
        return 'Enter valid email or 10-digit mobile number';
      }

      // If it's an email, return the result of email validation
      if (RegExp(emailFormat).hasMatch(value)) {
        return emailValidate(value);
      }

      // If it's a mobile number, return the result of mobile number validation
      return mobileNumberValidator(value);
    }


  

  Future<void> dealerRegister({
    required String companyName,
    required String email,
    required String password,
    required String confirmPassword,
    required String deviceToken,
    required String nearestPlaceId,
    BuildContext? context,
  }) async {
    // print(AppUrl.registrationUri);
    _isLoading = true;
    notifyListeners();
    final body = {
      'company_name': companyName,
      'email': email,
      'password': password,
      'password_confirmation': confirmPassword,
      'user_type_id': 4,
      'device_token': deviceToken,
      'coordinate': nearestPlaceId,
      
    };
    // print(body);

    try {
      final response = await dio.post(
        AppUrl.registrationUri,
        data: body,
      );
      if (response.statusCode == 200) {
        // print(response.data);
        _isLoading = false;
        _responseMessage = "Register successful!";
        _selectedServiceCentreListId = null;
        notifyListeners();
        
        
      } else {
        _isLoading = false;
        if (response.statusCode == 401) {
          _responseMessage = "Invalid username or password";
        } else {
          _responseMessage = "Error: ${response.statusCode}";
        }
        notifyListeners();
      }
    } on SocketException catch (_) {
      _isLoading = false;
      _responseMessage = "Internet connection is not available";
      notifyListeners();
    } catch (e) {
      _isLoading = false;
       notifyListeners();
    
      if (e is DioException) {
      final errorResponse = e.response?.data;
      if (errorResponse != null && errorResponse['name'] != null) {
        throw _responseMessage = errorResponse['name'][0];
        

      }else if (errorResponse != null && errorResponse['email'] != null) {
        throw _responseMessage = errorResponse['email'][0];
        // throw Exception(_responseMessage);
      }
      else if (errorResponse != null && errorResponse['password'] != null) {
        throw _responseMessage = errorResponse['password'][0];
       
      }
      else if (errorResponse != null && errorResponse['mobile_number'] != null) {
        throw _responseMessage = errorResponse['mobile_number'][0];
        
      }
       else if (errorResponse != null && errorResponse['coordinate'] != null) {
        throw _responseMessage = errorResponse['coordinate'][0];
        
      }
      
      else if (errorResponse != null && errorResponse['error'] != null) {
        throw Exception(errorResponse['error']);
      }
     
    }
    throw Exception('Register failed');
   
    
    }
  }



Future<void> agentRegister({
  required String name,
  required String mobile,
  required String password,
  required String confirmPassword,
  int? nearestPlaceId,
  File? aadhaarCard,
  File? aadhaarCardBack,
  File? drivingLicense,
  BuildContext? context,
  required String deviceToken,
}) async {
  _isLoading = true;
  notifyListeners();

  FormData formData;

  if (aadhaarCard != null || drivingLicense != null || aadhaarCardBack != null) {
    MultipartFile? aadhaarCardFile;
    MultipartFile? drivingLicenseFile;
    MultipartFile? aadhaarCardBackFile;

    if (aadhaarCard != null) {
      final bytes = await aadhaarCard.readAsBytes();
      aadhaarCardFile = MultipartFile.fromBytes(bytes, filename: aadhaarCard.path.split('/').last);
    }

    if (drivingLicense != null) {
      final bytes1 = await drivingLicense.readAsBytes();
      drivingLicenseFile = MultipartFile.fromBytes(bytes1, filename: drivingLicense.path.split('/').last);
    }

    if (aadhaarCardBack != null) {
      final bytes2 = await aadhaarCardBack.readAsBytes();
      aadhaarCardBackFile = MultipartFile.fromBytes(bytes2, filename: aadhaarCardBack.path.split('/').last);
    }

    formData = FormData.fromMap({
      if (aadhaarCardFile != null) 'aadhaar_card': aadhaarCardFile,
      if (drivingLicenseFile != null) 'driving_license': drivingLicenseFile,
      if (aadhaarCardBackFile != null) 'aadhaar_card_back_image': aadhaarCardBackFile,
      'name': name,
      'mobile_number': mobile,
      'password': password,
      'password_confirmation': confirmPassword,
      'user_type_id': 3,
      'coordinate': nearestPlaceId,
      'device_token': deviceToken,
    });
  } else {
    formData = FormData.fromMap({
      'name': name,
      'mobile_number': mobile,
      'password': password,
      'password_confirmation': confirmPassword,
      'user_type_id': 3,
      'coordinate': nearestPlaceId,
      'device_token': deviceToken,
    });
  }


   
   try {
      final response = await dio.post(
        AppUrl.registrationUri,
        data: formData,
        options: Options(headers: {
            "Content-Type": "application/json",
          })
      );
      if (response.statusCode == 200) {
        // print(response.data);
        _isLoading = false;
        _responseMessage = "Register successful!";
        _selectedServiceCentreListId = null;
        notifyListeners();
        
        
      } else {
        _isLoading = false;
        if (response.statusCode == 401) {
          _responseMessage = "Invalid username or password";
        } else {
          _responseMessage = "Error: ${response.statusCode}";
        }
        notifyListeners();
      }
    } on SocketException catch (_) {
      _isLoading = false;
      _responseMessage = "Internet connection is not available";
      notifyListeners();
    } catch (e) {
      _isLoading = false;
       notifyListeners();
    
      if (e is DioException) {
      final errorResponse = e.response?.data;
      if (errorResponse != null && errorResponse['name'] != null) {
        throw _responseMessage = errorResponse['name'][0];
        

      }else if (errorResponse != null && errorResponse['mobile_number'] != null) {
        throw _responseMessage = errorResponse['mobile_number'][0];
        // throw Exception(_responseMessage);
      }
      else if (errorResponse != null && errorResponse['password'] != null) {
        throw _responseMessage = errorResponse['password'][0];
       
      }
      
       else if (errorResponse != null && errorResponse['coordinate'] != null) {
        throw _responseMessage = errorResponse['coordinate'][0];
       
      }
      else if (errorResponse != null && errorResponse['error'] != null) {
        throw Exception(errorResponse['error']);
      }
     
    }
    throw Exception('Registration failed');
   
    
    }
  }


  Future<void> dealerEmployeeRegister({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    String? aadhaarCard,
    
    BuildContext? context,
  }) async {
    // print(AppUrl.registrationUri);
     final userId = await DatabaseControllerProvider().getUserId();
    _isLoading = true;
    notifyListeners();
    final body = {
      'name': name,
      'email': email,
      'mobile_number': phone,
      'password': password,
      'password_confirmation': confirmPassword,
      'aadhaar_card': aadhaarCard,
      'user_type_id': 5,
      'employee_of_dealer_id': userId
      
    };
    // print(body);

    try {
      final response = await dio.post(
        AppUrl.registrationUri,
        data: body,
      );
      if (response.statusCode == 200) {
        // print(response.data);
        _isLoading = false;
        _responseMessage = "Register successful!";
        notifyListeners();
        
        
      } else {
        _isLoading = false;
        if (response.statusCode == 401) {
          _responseMessage = "Invalid username or password";
        } else {
          _responseMessage = "Error: ${response.statusCode}";
        }
        notifyListeners();
      }
    } on SocketException catch (_) {
      _isLoading = false;
      _responseMessage = "Internet connection is not available";
      notifyListeners();
    } catch (e) {
      _isLoading = false;
       notifyListeners();
    
      if (e is DioException) {
      final errorResponse = e.response?.data;
      if (errorResponse != null && errorResponse['name'] != null) {
        throw _responseMessage = errorResponse['name'][0];
        

      }else if (errorResponse != null && errorResponse['email'] != null) {
        throw _responseMessage = errorResponse['email'][0];
        // throw Exception(_responseMessage);
      }
      else if (errorResponse != null && errorResponse['password'] != null) {
        throw _responseMessage = errorResponse['password'][0];
       
      }
      else if (errorResponse != null && errorResponse['mobile_number'] != null) {
        throw _responseMessage = errorResponse['mobile_number'][0];
        
      }
      
      else if (errorResponse != null && errorResponse['error'] != null) {
        throw Exception(errorResponse['error']);
      }
     
    }
    throw Exception('Register failed');
   
    
    }
  }

  Future<void> login({
    required String email,
    required String password,
    required String deviceToken,
    BuildContext? context,
  }) async {
    // print(AppUrl.loginUri);
    _isLoading = true;
    notifyListeners();
    final body = {'email_or_mobile': email, 'password': password, 'device_token': deviceToken};
    // print(body);

    try {
      final response = await dio.post(
        AppUrl.loginUri,
        data: body,
      );

      if (response.statusCode == 200) {
        // print(response.data);
        _isLoading = false;
        _responseMessage = "Login successful!";
        notifyListeners();
        //save in sharedprefrences
        final userId = response.data['user']['id'].toString();
        final roleId = response.data['user']['role_id'].toString();
        final installerMobileNo = response.data['user']['mobile_number'].toString();
        final token = response.data['token'];
        _newRoleId = roleId;
        // print("Your user id is : $userId");
        // print("Your token is : $token");
        DatabaseControllerProvider().saveToken(token);
        DatabaseControllerProvider().saveUserId(userId);
        DatabaseControllerProvider().saveRoleId(roleId);
        DatabaseControllerProvider().saveInstallerMobileNo(installerMobileNo);

      } else {
        _isLoading = false;
        if (response.statusCode == 401) {
          _responseMessage = "Invalid username or password";
        } else {
          _responseMessage = "Error: ${response.statusCode}";
        }
        notifyListeners();
      }
    } on SocketException catch (_) {
      _isLoading = false;
      _responseMessage = "Internet connection is not available";
      notifyListeners();
    } catch (e) {
       _isLoading = false;
       notifyListeners();
   
      if (e is DioException) {
      final errorResponse = e.response?.data;
      if (errorResponse != null && errorResponse['email'] != null) {
        throw _responseMessage = errorResponse['email'][0];
        // throw Exception(_responseMessage);
      }
      else if (errorResponse != null && errorResponse['password'] != null) {
        throw _responseMessage = errorResponse['password'][0];
       
      }
      else if (errorResponse != null && errorResponse['error'] != null) {
        throw Exception(errorResponse['error']);
      }
     
    }
    throw Exception('Register failed');
    }
  }

  Future<void> forgotPassword({required String email, BuildContext? context,}) async {
    
    _isLoading = true;
    notifyListeners();
    final body = {'email': email};
    
    try {
      final response = await dio.post(
        AppUrl.forgotPasswordUri,
        data: body,
      );

      if (response.statusCode == 200) {
        _isLoading = false;
        _responseMessage = response.data['data'];
        notifyListeners();
        
      } else {
        _isLoading = false;
        if (response.statusCode == 401) {
          _responseMessage = "Invalid email";
        } else {
          _responseMessage = "Error: ${response.statusCode}";
        }
        notifyListeners();
      }
    } on SocketException catch (_) {
      _isLoading = false;
      _responseMessage = "Internet connection is not available";
      notifyListeners();
    } catch (e) {
       _isLoading = false;
       notifyListeners();
   
      if (e is DioException) {
      final errorResponse = e.response?.data;
       
      if (errorResponse != null && errorResponse['error'] != null) {
        throw Exception(errorResponse['error']);
      }
     
    }
    throw Exception('Email is not exist!');
    }
  }

    int? selectedUserTypeId;
  void setSelectedUserTypeId(int? id) {
    selectedUserTypeId = id;
    //  print("selectedUserTypeId: $selectedUserTypeId");
    notifyListeners();
  }

  Future<UserTypeModel?> fetchUsertype() async {
    try {
      
      const urlUserType = AppUrl.userTypesUri;
      // print(urlUserType);

      final response = await dio.get(
        urlUserType,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            
          },
        ),
      );
      // print(response.data);
      return UserTypeModel.fromJson(response.data);
    } catch (error) {
      // Handle error
      if (kDebugMode) {
        print('Error fetching user type: $error');
      }
      return null;
      
    }
  }

  Future<OnboardingModel?> fetchOnboarding() async {
    try {
      
      const urlOnboard = AppUrl.onBoardingUri;
      // print(urlOnboard);

      final response = await dio.get(
        urlOnboard,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      // print(response.data);
      return OnboardingModel.fromJson(response.data);
    } catch (error) {
      // Handle error
      if (kDebugMode) {
        print('Error fetching on boarding: $error');
      }
      return null;
      
    }
  }

  Future<void> updateRole({required String userTypeId, BuildContext? context,
  }) async {
    
    final userId = await DatabaseControllerProvider().getUserId();
    final urlUpdateRole = '${AppUrl.updateRoleUri}?id=$userId';
    _isLoading = true;
    notifyListeners();
    final body = {
      'user_type_id': userTypeId,
      
    };
    // print(body);

    try {
      final response = await dio.post(urlUpdateRole,
          data: body,
          options: Options(headers: {
            "Content-Type": "application/json",
            
          }));
      //  print(response.data);

      if (response.statusCode == 200) {
        // print(response.data);
        _isLoading = false;
        _responseMessage = "Role updated successfully!";
        notifyListeners();
      } else {
        _isLoading = false;
        if (response.statusCode == 401) {
          _responseMessage = "Something went wrong";
        } else {
          _responseMessage = "Error: ${response.statusCode}";
        }
        notifyListeners();
      }
    } on SocketException catch (_) {
      _isLoading = false;
      _responseMessage = "Internet connection is not available";
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _responseMessage = 'Please try again';
      notifyListeners();
      if (kDebugMode) {
        print("Your error is $e");
      }
    }
  }
  

  void clear() {
    _responseMessage = '';
    notifyListeners();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _responseMessage = 'Location services are disabled.';
      notifyListeners();
       
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
      _responseMessage = 'Location permissions are denied.';
      notifyListeners();
       
      
      }
    }
  
    if (permission == LocationPermission.deniedForever) {
      _responseMessage = 'Location permissions are permanently denied, we cannot request permissions.';
      notifyListeners();     
    } 
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

     double _lat = 0.0;
     double get lat => _lat;

     double _long = 0.0;
     double get long => _long;

     int? _nearestId;
     int? get nearestId => _nearestId;

     String? _nearestPlace;
     String? get nearestPlace => _nearestPlace;
  
 

      getLatLong() {
      Future<Position> data = _determinePosition();
      data.then((value) async{
          _lat = value.latitude;
          _long = value.longitude;
          print('your lat is: $lat');
          print('your long is: $long');

          final urlGetNearestServiceCenter = '${AppUrl.nearestServiceCenter}?latitude=$_lat&longitude=$_long';
          
            final response = await dio.get(
            urlGetNearestServiceCenter,
            options: Options(
              headers: {
                'Content-Type': 'application/json',
              },
            ),
          );
        
        _nearestId = response.data['items']['id'];
        _nearestPlace = response.data['items']['place'];
        print('your nearest id $_nearestId');
        print('your nearest place $_nearestPlace');
        notifyListeners();
        // return response.data;

          

        // getAddress(value.latitude, value.longitude);
      }).catchError((error) {
        print("Error $error");
        
      });
    }

    //  Future<Position> getUserCurrentLocation ()async{
       
    //   await Geolocator.requestPermission().then((value) {
       
    //   }).onError((error, stackTrace) {
    //     print("error"+error.toString());
    //   });
    //   return await Geolocator.getCurrentPosition();
    // }
   
    
    //  getUserCurrentLocation (BuildContext context)async{
    //  PermissionStatus status = await Permission.location.request();
    //  if(status == PermissionStatus.granted){
      
    //     debugPrint("Permission granted");
      
    //   return await Geolocator.getCurrentPosition();
    //  }
    //   if(status == PermissionStatus.denied){
    //     print("Permission denied");
    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Can not access location"),
    //     action: SnackBarAction(label: "Open app settings", onPressed: (){
    //       openAppSettings();
    //     }),
    //     ));
    //   }
    //   if(status == PermissionStatus.limited){
    //   debugPrint("Permission is limited");
    //   }
    //   if(status == PermissionStatus.restricted){
    //   debugPrint("Permission is restricted");
    //    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Permission is restricted"),
    //     action: SnackBarAction(label: "Open app settings", onPressed: (){
    //       openAppSettings();
    //     }),
    //     ));
    //   }

    //      if(status == PermissionStatus.permanentlyDenied){
    //   debugPrint("Permission permanently denied");
    //    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Permission permanently denied"),
    //     action: SnackBarAction(label: "Open app settings", onPressed: (){
    //       openAppSettings();
    //     }),
    //     ));
    //   }
    
    // }
    


    getUserCurrentLocation (BuildContext context)async{
     
     Map<Permission, PermissionStatus> multiplestatus = await
     [Permission.location, Permission.camera, Permission.storage, Permission.notification,].request();

      //Notifications permission
     if(multiplestatus[Permission.notification]!.isGranted){
      debugPrint('Notifications permission is granted');
     }
     if(multiplestatus[Permission.notification]!.isDenied){
        debugPrint("Notification Permission denied");
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("Can not access notifiations"),
        action: SnackBarAction(label: "Open app settings", onPressed: (){
          openAppSettings();
        }),
        ));
     }
     if(multiplestatus[Permission.notification]!.isPermanentlyDenied){
      debugPrint("Notification permission permanently denied");
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("Can not access notification"),
        action: SnackBarAction(label: "Open app settings", onPressed: (){
          openAppSettings();
        }),
        ));
     }

      //Location permission
     if(multiplestatus[Permission.location]!.isGranted){
      debugPrint('Location permission is granted');
      return await Geolocator.getCurrentPosition();
     }
     if(multiplestatus[Permission.location]!.isDenied){
        debugPrint("Permission denied");
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("Can not access location"),
        action: SnackBarAction(label: "Open app settings", onPressed: (){
          openAppSettings();
        }),
        ));
     }
     if(multiplestatus[Permission.location]!.isPermanentlyDenied){
      debugPrint("Permission permanently denied");
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("Can not access location"),
        action: SnackBarAction(label: "Open app settings", onPressed: (){
          openAppSettings();
        }),
        ));
     }
      
      //Camera permission
     if(multiplestatus[Permission.camera]!.isGranted){
      debugPrint('Camera permission is granted');
     }
     if(multiplestatus[Permission.camera]!.isDenied){
        debugPrint("Permission denied");
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("Can not access camera"),
        action: SnackBarAction(label: "Open app settings", onPressed: (){
          openAppSettings();
        }),
        ));
     }
     if(multiplestatus[Permission.camera]!.isPermanentlyDenied){
      debugPrint("Permission permanently denied");
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("Can not access camera"),
        action: SnackBarAction(label: "Open app settings", onPressed: (){
          openAppSettings();
        }),
        ));
     }

      //Storage permission
     if(multiplestatus[Permission.storage]!.isGranted){
      debugPrint('Storage permission is granted');
     }
     if(multiplestatus[Permission.storage]!.isDenied){
        debugPrint("Permission denied");
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("Can not access storage"),
        action: SnackBarAction(label: "Open app settings", onPressed: (){
          openAppSettings();
        }),
        ));
     }
     if(multiplestatus[Permission.storage]!.isPermanentlyDenied){
      debugPrint("Permission permanently denied");
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("Can not access storage"),
        action: SnackBarAction(label: "Open app settings", onPressed: (){
          openAppSettings();
        }),
        ));
     }

    

    }

      int? get selectedServiceCentreListId => _selectedServiceCentreListId;
      int? _selectedServiceCentreListId;  
      void setSelectedServiceCentreListId(int? id) {
        _selectedServiceCentreListId = id;
        print("select Service Centre List Id: $selectedServiceCentreListId");
        notifyListeners();
      }

    Future<ServiceCentreModel?> fetchServiceCentre() async {
    try {
      
      const urlServiceCentre = AppUrl.serviceCentreUri;
      final response = await dio.get(
        urlServiceCentre,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      return ServiceCentreModel.fromJson(response.data);
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching service centre: $error');
      }
      return null;
      
    }
  }
    
  

}

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../controller/database/database_controller_provider.dart';
import '../model/all_state_model.dart';
import '../model/gender_model.dart';
import '../model/user_details.dart';

import '../utils/exports.dart';


class UserDetailsControllerProvider extends ChangeNotifier {

  final dio = Dio();
  //setter

  bool _isLoading = false;
  String _responseMessage = '';
  //getter

  bool get isLoading => _isLoading;
  String get responseMessage => _responseMessage;

   void clear() {
    _responseMessage = '';
    notifyListeners();
  }

  // ignore: non_constant_identifier_names
  Future<UserDetails?> UserDetailsShow() async {
    
  final token = await DatabaseControllerProvider().getToken();
    try {

      const urlUserDetails = AppUrl.userUri;
      
      final response = await dio.get(
        urlUserDetails,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            HttpHeaders.authorizationHeader: "Bearer $token"

          },
        ),
      );
      // print(response.data);
      return UserDetails.fromJson(response.data);

    } catch (error) {
      // Handle error
      if (kDebugMode) {
        print('Error fetching user details: $error');
      }
      return null;

    }
  }

   Future<void> updateUserProfile({required int id,String? fullName, 
   String? address, String? email,String? phone, String? password,
      File? profileImage, BuildContext? context,
    required Function() onSuccess,
    
    
  }) async {
    final urlUpdateProfile = '${AppUrl.updateUserDetails}?id=$id';
    
    final token = await DatabaseControllerProvider().getToken();
    _isLoading = true;
    notifyListeners();

    FormData formData;

    if (profileImage != null) {
    final bytes = await profileImage.readAsBytes();

     formData = FormData.fromMap({
      'avatar': MultipartFile.fromBytes(bytes, filename: profileImage.path.split('/').last),
      'name': fullName,
      'address': address,
      'email': email,
      'mobile_number': phone,
      'password': password,
    });

 
    } else {
      formData = FormData.fromMap({
        'name': fullName,
        'address': address,
        'email': email,
        'mobile_number': phone,
        'password': password,
      });
    }

    try {
      final response = await dio.post(urlUpdateProfile,
          data: formData,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          }));
      if (response.statusCode == 200) {
        _isLoading = false;
        _responseMessage = "updated successfully! ";
        notifyListeners();
        onSuccess();
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
      notifyListeners();

      if (e is DioException) {
      final errorResponse = e.response?.data;
      if (errorResponse != null && errorResponse['email'] != null) {
        throw _responseMessage = errorResponse['email'][0];
        

      }else if (errorResponse != null && errorResponse['mobile_number'] != null) {
        throw _responseMessage = errorResponse['mobile_number'][0];
      }
      else if (errorResponse != null && errorResponse['name'] != null) {
        throw _responseMessage = errorResponse['name'][0];
      }
      
     
    }
    throw Exception('Please try again');
   
    }
  }

  // Future<GenderModel?> GenderData() async {
  //   String token;
  //   token = await DatabaseControllerProvider().getToken();
  //   try {

  //     const urlUserDetails = AppUrl.genderDataUri;
  //     // print(urlUserType);

  //     final response = await dio.get(
  //       urlUserDetails,
  //       options: Options(
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Accept': 'application/json',
  //           HttpHeaders.authorizationHeader: "Bearer $token"

  //         },
  //       ),
  //     );

  //     return GenderModel.fromJson(response.data);

  //   } catch (error) {
  //     // Handle error
  //     if (kDebugMode) {
  //       print('Error fetching user details: $error');
  //     }
  //     return null;

  //   }
  // }

  // Future<AllStateModel?> allStateData() async {
  //   String token;
  //   token = await DatabaseControllerProvider().getToken();
  //   try {

  //     const urlStateData = AppUrl.allSatateUri;
  //     // print(urlUserType);

  //     final response = await dio.get(
  //       urlStateData,
  //       options: Options(
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Accept': 'application/json',
  //           HttpHeaders.authorizationHeader: "Bearer $token"

  //         },
  //       ),
  //     );
  //     return AllStateModel.fromJson(response.data);

  //   } catch (error) {
  //     // Handle error
  //     if (kDebugMode) {
  //       print('Error fetching user details: $error');
  //     }
  //     return null;

  //   }
  // }

  
 

}

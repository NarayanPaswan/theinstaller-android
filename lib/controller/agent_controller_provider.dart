import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:theinstallers/model/status_model.dart';
import '../../utils/exports.dart';
import '../model/yes_no_model.dart';
import 'database/database_controller_provider.dart';


class AgentControllerProvider extends ChangeNotifier {
  
  String _selectedValue = "accepted"; // Initialize with your default value

  String get selectedValue => _selectedValue;

  void updateSelectedValue(String newValue) {
    _selectedValue = newValue;
    notifyListeners(); // Notify listeners of the change
  }

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

 
 
  int? get selectedStatusId => _selectedStatusId;
  int? _selectedStatusId;  
  void setSelectedStatusId(int? id) {
    _selectedStatusId = id;
     print("select Status Id: $selectedStatusId");
    notifyListeners();
  }

  int? get selectedYesNoId => _selectedYesNoId;
  int? _selectedYesNoId;  
  void setSelectedYesNoId(int? id) {
    _selectedYesNoId = id;
     print("select Yes No Id: $selectedYesNoId");
    notifyListeners();
  }

  Future<StatusModel?> fetchStatus() async {
    try {
      final token = await DatabaseControllerProvider().getToken();
      const urlstatus = AppUrl.statusUri;
      final response = await dio.get(
        urlstatus,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return StatusModel.fromJson(response.data);
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching status: $error');
      }
      return null;
      
    }
  }

     Future<void> updateServiceByAgent({
    int? id, 
    List<File>? formFileImages,
    List<File>? formFileSiteImages,
    List<String>? imageCaptions,
    List<String>? siteCaptions,
    
    String? remarks, String? status, String? serviceCharge, 
    String? yeNoId,String? reason, 
    
    
    BuildContext? context,
      required Function() onSuccess,
      
    }) async {
      final token = await DatabaseControllerProvider().getToken();
      _isLoading = true;
      notifyListeners();
     
    try {

      FormData formData = FormData();

      List<MapEntry<String, String>> fields = [
      MapEntry('service_id', id.toString()),
      MapEntry('remarks', remarks ?? ''),
      MapEntry('status', status ?? ''),
      MapEntry('service_charge', serviceCharge ?? ''),
      MapEntry('payment_collected', yeNoId ?? ''),
      MapEntry('reason', reason ?? ''),
      
    ];

    formData.fields.addAll(fields);

    if (formFileImages != null && formFileImages.isNotEmpty) {
      for (int i = 0; i < formFileImages.length; i++) {
        final File formFileImage = formFileImages[i];
        final bytes = await formFileImage.readAsBytes();
        final fileName = formFileImage.path.split('/').last;

        formData.files.add(
          MapEntry(
            'agent_form_image[$i][form_image_file]',
            MultipartFile.fromBytes(bytes, filename: fileName),
          ),
        );
        // Add the image caption here based on the index
        if (imageCaptions != null && i < imageCaptions.length) {

          formData.fields.add(
            MapEntry('agent_form_image[$i][caption]', imageCaptions[i]),
          );

          // Print the image caption
         print("Image Caption $i: ${imageCaptions[i]}");

        }
      }

     
    }

    

     if (formFileSiteImages != null && formFileSiteImages.isNotEmpty) {
      for (int i = 0; i < formFileSiteImages.length; i++) {
        final File formFileSiteImage = formFileSiteImages[i];
        final bytes = await formFileSiteImage.readAsBytes();
        final fileName = formFileSiteImage.path.split('/').last;

        formData.files.add(
          MapEntry(
            'agent_site_image[$i][site_image_file]',
            MultipartFile.fromBytes(bytes, filename: fileName),
          ),
        );
              // Add the image caption here based on the index
        if (siteCaptions != null && i < siteCaptions.length) {

          formData.fields.add(
            MapEntry('agent_site_image[$i][caption]', siteCaptions[i]),
          );

          // Print the image caption
         print("site Image Caption $i: ${siteCaptions[i]}");

        }
      }
    }


      final response = await dio.post(AppUrl.updateServiceByAgentUri,
          data: formData,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          }));
      if (response.statusCode == 200) {
        _isLoading = false;
        _responseMessage = "Service updated successfull! ";
        _selectedYesNoId = null;
        _selectedStatusId = null;
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
      // _responseMessage = 'Please try again';
      notifyListeners();
      // if (kDebugMode) {
      //   print("Your error is $e");
      // }
       if (e is DioException) {
      final errorResponse = e.response?.data;
      if (errorResponse != null && errorResponse['status'] != null) {
        throw _responseMessage = errorResponse['status'][0];
      }
      else if (errorResponse != null && errorResponse['new_booking_date_time'] != null) {
        throw _responseMessage = errorResponse['new_booking_date_time'][0];
      }
      else if (errorResponse != null && errorResponse['reason'] != null) {
        throw _responseMessage = errorResponse['reason'][0];
      }
     
    }
    throw Exception('Please try again');
    }
  }  

  Future<YesNoModel?> fetchYesNo() async {
    try {
      final token = await DatabaseControllerProvider().getToken();
      const urlYesNo = AppUrl.yesNoUri;
      final response = await dio.get(
        urlYesNo,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return YesNoModel.fromJson(response.data);
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching status: $error');
      }
      return null;
      
    }
  }

/*
   Future<void> acceptDeclineTask({
    required String serviceId,
    BuildContext? context,
  }) async {
    // print(AppUrl.loginUri);
    _isLoading = true;
    notifyListeners();
    final body = {'service_id': serviceId, 'notification_message': 'accepted', 'is_accept': '1'};
    print(body);

    try {
      final response = await dio.post(
        AppUrl.acceptDeclineTaskUri,
        data: body,
      );

      if (response.statusCode == 200) {
        // print(response.data);
        _isLoading = false;
        _responseMessage = "Accept successful!";
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
       notifyListeners();
   
    throw Exception(e.toString());
    }
  }

  */

   Future<void> acceptDeclineTask({
    required String serviceId,
    required String notificationMessage,
    // required String isAccept,
    String? reason,
    BuildContext? context,
     required Function() onSuccess,
      
    }) async {
      final token = await DatabaseControllerProvider().getToken();
      _isLoading = true;
      notifyListeners();
      print(serviceId.toString());
    try {

      final body = {'service_id': serviceId, 'notification_message': notificationMessage, 
      // 'is_accept': isAccept,
      'reason': reason,
      };

      final response = await dio.post(AppUrl.acceptDeclineTaskUri,
          data: body,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          }));
      if (response.statusCode == 200) {
        _isLoading = false;
        _responseMessage =  "Task $notificationMessage !";
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
      _responseMessage = 'Please try again';
      notifyListeners();
      if (kDebugMode) {
        print("Your error is $e");
      }
    }
  }  


  Future<void> installerCallingTheCustomer({
    required String installerNo,
    required String customerNo,
    BuildContext? context,
     required Function() onSuccess,
      
    }) async {
      final token = await DatabaseControllerProvider().getToken();
      _isLoading = true;
      notifyListeners();
      print(installerNo.toString());
      print(customerNo.toString());
    try {

      final body = {
        'installer_no': installerNo, 
        'customer_no': customerNo, 
    
      };

      final response = await dio.post(AppUrl.installerCallingTheCustomerUri,
          data: body,
          options: Options(headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          }));
      if (response.statusCode == 200) {
        _isLoading = false;
        _responseMessage =  "Callling.. !";
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
      _responseMessage = 'Please try again';
      notifyListeners();
      if (kDebugMode) {
        print("Your error is $e");
      }
    }
  }  

  
  

}
// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:theinstallers/model/delete_reason_model.dart';
// import 'package:theinstallers/model/salutation_model.dart';
// import 'package:theinstallers/model/task_type_model.dart';
// import '../../utils/exports.dart';
// import '../model/booking_completed_details_model.dart';
// import '../model/on_going_service_details_model.dart';
// import '../model/payment_mode_model.dart';
// import '../model/service_details_model.dart';
// import 'database/database_controller_provider.dart';


// class BookingControllerProvider extends ChangeNotifier {

 

//   final dio = Dio();
//   //setter

//   bool _isLoading = false;
//   String _responseMessage = '';
//   //getter

//   bool get isLoading => _isLoading;
//   String get responseMessage => _responseMessage;

//   String? validateMobile(String value) {
//   String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
//   RegExp regExp = RegExp(patttern);
//   if (value.isEmpty) {
//         return 'Please enter mobile number';
//   }
//   else if (!regExp.hasMatch(value)) {
//         return 'Please enter valid mobile number';
//   }
//   return null;
//   } 

//   String? validateName(String value) {
//   final RegExp nameRegExp = RegExp('[a-zA-Z]'); 
 
//   if (value.isEmpty) {
//         return 'Please enter name';
//   }
//   else if (!nameRegExp.hasMatch(value)) {
//         return 'Please enter valid name';
//   }
//   return null;
//   } 

//   String? validateBlankField(String value) {
 
//   if (value.isEmpty) {
//         return 'Data required here';
//   }
 
//   return null;
//   } 

//   String? validateDateTime(String value) {
 
//   if (value.isEmpty) {
//         return 'Please enter booking date & time';
//   }
  
//   return null;
//   } 

//   DateTime? _selectedDate;
//   DateTime? get selectedDate => _selectedDate;
//   void updateSelectedDateTime(DateTime date) {
//     _selectedDate = date;
//     // print("new date is : $date");
//     notifyListeners();
//   }

//    void clear() {
//     _responseMessage = '';
//     notifyListeners();
//   }

//    Future<void> newBooking({
//     List<File>? formFileImages,
//     String? address, required String fullName, String? email,String? phone, 
//     String? dateAndTimeOfBooking, required String tasktypeid, String? typeOfMeasurement, String? typeOfMaterial,
//     String? paymentModeId, String? remarks, String? notes, String? desription,String? nearestServiceCenterId, 
//     String? landmark,String? quantity, required String salutation_id,
    
//     BuildContext? context,
//     required Function() onSuccess,
      
//     }) async {
//       final token = await DatabaseControllerProvider().getToken();
//       _isLoading = true;
//       notifyListeners();
     
//     try {

//       FormData formData = FormData();

//       List<MapEntry<String, String>> fields = [
//       MapEntry('address', address ?? ''),
//       MapEntry('client_name', fullName),
//       MapEntry('client_email_address', email ?? ''),
//       MapEntry('client_mobile_number', phone ?? ''),
//       MapEntry('date_time', dateAndTimeOfBooking ?? ''),
//       MapEntry('task_type_id', tasktypeid),
//       MapEntry('type_of_measurement', typeOfMeasurement ?? ''),
//       MapEntry('type_of_material', typeOfMaterial ?? ''),
//       MapEntry('payment_mode_id', paymentModeId ?? ''),
//       MapEntry('remarks', remarks ?? ''),
//       MapEntry('notes', notes ?? ''),
//       MapEntry('descriptions', desription ?? ''),
//       MapEntry('landmark', landmark ?? ''),
//       MapEntry('quantity', quantity ?? ''),
//       MapEntry('coordinate', nearestServiceCenterId ?? ''),
//       MapEntry('salut', salutation_id),
      
//     ];

//     formData.fields.addAll(fields);

//     if (formFileImages != null && formFileImages.isNotEmpty) {
//       for (int i = 0; i < formFileImages.length; i++) {
//         final File formFileImage = formFileImages[i];
//         final bytes = await formFileImage.readAsBytes();
//         final fileName = formFileImage.path.split('/').last;

//         formData.files.add(
//           MapEntry(
//             'service_image[$i][image_file]',
//             MultipartFile.fromBytes(bytes, filename: fileName),
//           ),
//         );
      
//       }

     
//     }

    
//       final response = await dio.post(AppUrl.storeServiceBookingUri,
//           data: formData,
//           options: Options(headers: {
//             "Content-Type": "application/json",
//             "Authorization": "Bearer $token",
//           }));
//       if (response.statusCode == 200) {
//         _isLoading = false;
//         _responseMessage = "Booking successfull! ";
//         _selectedTaskTypeId = null;
//         _selectedPaymentModeId = null;
//         _selectedSalutationId = null;
//         notifyListeners();
//         onSuccess();
//       } else {
//         _isLoading = false;
//         if (response.statusCode == 401) {
//           _responseMessage = "Something went wrong";
//         } else {
//           _responseMessage = "Error: ${response.statusCode}";
//         }
//         notifyListeners();
//       }
//     } on SocketException catch (_) {
//       _isLoading = false;
//       _responseMessage = "Internet connection is not available";
//       notifyListeners();
//     } catch (e) {
//       _isLoading = false;
//       // _responseMessage = 'Please try again';
//       notifyListeners();
//       // if (kDebugMode) {
//       //   print("Your error is $e");
//       // }
//        if (e is DioException) {
//       final errorResponse = e.response?.data;
//       if (errorResponse != null && errorResponse['address'] != null) {
//         throw _responseMessage = errorResponse['address'][0];
//       }else if (errorResponse != null && errorResponse['client_name'] != null) {
//         throw _responseMessage = errorResponse['client_name'][0];
//       }
//       else if (errorResponse != null && errorResponse['client_mobile_number'] != null) {
//         throw _responseMessage = errorResponse['client_mobile_number'][0];
//       }
//       else if (errorResponse != null && errorResponse['date_time'] != null) {
//         throw _responseMessage = errorResponse['date_time'][0];
//       }
//       else if (errorResponse != null && errorResponse['task_type_id'] != null) {
//         throw _responseMessage = errorResponse['task_type_id'][0];
//       }
//       else if (errorResponse != null && errorResponse['type_of_measurement'] != null) {
//         throw _responseMessage = errorResponse['type_of_measurement'][0];
//       }
//       else if (errorResponse != null && errorResponse['type_of_material'] != null) {
//         throw _responseMessage = errorResponse['type_of_material'][0];
//       }
//       else if (errorResponse != null && errorResponse['payment_mode_id'] != null) {
//         throw _responseMessage = errorResponse['payment_mode_id'][0];
//       }
//       else if (errorResponse != null && errorResponse['salut'] != null) {
//         throw _responseMessage = errorResponse['salut'][0];
//       }
     
//     }
//     throw Exception('Please try again');
//     }
//   } 

   

// /*
//     Future<void> newBooking({String? address, required String fullName, String? email,String? phone, 
//     String? dateAndTimeOfBooking, required String tasktypeid, String? typeOfMeasurement, String? typeOfMaterial,
//     String? paymentModeId, String? remarks, String? notes, String? desription,String? nearestServiceCenterId, 
//     String? landmark,String? quantity,BuildContext? context,
//     required Function() onSuccess,
    
//   }) async {
//     // print(AppUrl.registrationUri);
//     final token = await DatabaseControllerProvider().getToken();
//     _isLoading = true;
//     notifyListeners();
//     final body = {
//       'address': address,
//       'client_name': fullName,
//       'client_email_address': email,
//       'client_mobile_number': phone,
//       'date_time': dateAndTimeOfBooking,
//       'task_type_id': tasktypeid,
//       'type_of_measurement': typeOfMeasurement,
//       'type_of_material': typeOfMaterial,
//       'payment_mode_id': paymentModeId,
//       'remarks': remarks,
//       'notes': notes,
//       'descriptions': desription,
//       'landmark': landmark,
//       'quantity': quantity,
//       'coordinate': nearestServiceCenterId,
      
//     };
//     // print(body);

//     try {
//       final response = await dio.post(AppUrl.storeServiceBookingUri,
//           data: body,
//           options: Options(headers: {
//             "Content-Type": "application/json",
//             "Authorization": "Bearer $token",
//           }));
//       if (response.statusCode == 200) {
//         _isLoading = false;
//         _responseMessage = "Booking successfull! ";
//         _selectedTaskTypeId = null;
//         _selectedPaymentModeId = null;
//         notifyListeners();
//         onSuccess();
//       } else {
//         _isLoading = false;
//         if (response.statusCode == 401) {
//           _responseMessage = "Something went wrong";
//         } else {
//           _responseMessage = "Error: ${response.statusCode}";
//         }
//         notifyListeners();
//       }
//     } on SocketException catch (_) {
//       _isLoading = false;
//       _responseMessage = "Internet connection is not available";
//       notifyListeners();
//     } catch (e) {
//       _isLoading = false;
//       // _responseMessage = 'Please try again';
//       notifyListeners();

//       // if (kDebugMode) {
//       //   print("Your error is $e");
//       // }

//       if (e is DioException) {
//       final errorResponse = e.response?.data;
//       if (errorResponse != null && errorResponse['address'] != null) {
//         throw _responseMessage = errorResponse['address'][0];
//       }else if (errorResponse != null && errorResponse['client_name'] != null) {
//         throw _responseMessage = errorResponse['client_name'][0];
//       }
//       else if (errorResponse != null && errorResponse['client_mobile_number'] != null) {
//         throw _responseMessage = errorResponse['client_mobile_number'][0];
//       }
//       else if (errorResponse != null && errorResponse['date_time'] != null) {
//         throw _responseMessage = errorResponse['date_time'][0];
//       }
//       else if (errorResponse != null && errorResponse['task_type_id'] != null) {
//         throw _responseMessage = errorResponse['task_type_id'][0];
//       }
//       else if (errorResponse != null && errorResponse['type_of_measurement'] != null) {
//         throw _responseMessage = errorResponse['type_of_measurement'][0];
//       }
//       else if (errorResponse != null && errorResponse['type_of_material'] != null) {
//         throw _responseMessage = errorResponse['type_of_material'][0];
//       }
//       else if (errorResponse != null && errorResponse['payment_mode_id'] != null) {
//         throw _responseMessage = errorResponse['payment_mode_id'][0];
//       }
      
     
//     }
//     throw Exception('Please try again');

//     }
//   }
// */
//   Future<void> deleteAccountRequest({String? reason, String? others,
//     BuildContext? context,
//     required Function() onSuccess,
    
//   }) async {
//     // print(AppUrl.registrationUri);
//     final token = await DatabaseControllerProvider().getToken();
//     _isLoading = true;
//     notifyListeners();
//     final body = {
//       'reason': reason,
//       'others': others,
//     };
//     // print(body);

//     try {
//       final response = await dio.post(AppUrl.storeDeleteAccountRequestUri,
//           data: body,
//           options: Options(headers: {
//             "Content-Type": "application/json",
//             "Authorization": "Bearer $token",
//           }));
//       if (response.statusCode == 200) {
//         _isLoading = false;
//         _responseMessage = "Request sent successfully! ";
//         notifyListeners();
//         onSuccess();
//       } else {
//         _isLoading = false;
//         if (response.statusCode == 401) {
//           _responseMessage = "Something went wrong";
//         } else {
//           _responseMessage = "Error: ${response.statusCode}";
//         }
//         notifyListeners();
//       }
//     } on SocketException catch (_) {
//       _isLoading = false;
//       _responseMessage = "Internet connection is not available";
//       notifyListeners();
//     } catch (e) {
//       _isLoading = false;
//       _responseMessage = 'Please try again';
//       notifyListeners();
//       if (kDebugMode) {
//         print("Your error is $e");
//       }
//     }
//   }

  
//   int? get selectedTaskTypeId => _selectedTaskTypeId;
//   int? _selectedTaskTypeId;  
//   void setSelectedTaskTypeId(int? id) {
//     _selectedTaskTypeId = id;
//      print("select Task Type Id: $selectedTaskTypeId");
//     notifyListeners();
//   }

  

//   Future<TaskTypeModel?> fetchTaskType() async {
//     try {
//       final token = await DatabaseControllerProvider().getToken();
//       const urlTaskType = AppUrl.taskTypeUri;
//       final response = await dio.get(
//         urlTaskType,
//         options: Options(
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );
//       return TaskTypeModel.fromJson(response.data);
//     } catch (error) {
//       if (kDebugMode) {
//         print('Error fetching task type: $error');
//       }
//       return null;
      
//     }
//   }

//   int? get selectedReasonListId => _selectedReasonListId;
//   int? _selectedReasonListId;  
//   void setSelectedReasonListId(int? id) {
//     _selectedReasonListId = id;
//      print("select ReasonList Id: $selectedReasonListId");
//     notifyListeners();
//   }


//   Future<DeleteReasonModel?> fetchDeleteRason() async {
//     try {
//       final token = await DatabaseControllerProvider().getToken();
//       const urlDeleteReason = AppUrl.deleteReasonUri;
//       final response = await dio.get(
//         urlDeleteReason,
//         options: Options(
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );
//       return DeleteReasonModel.fromJson(response.data);
//     } catch (error) {
//       if (kDebugMode) {
//         print('Error fetching delete reason: $error');
//       }
//       return null;
      
//     }
//   }

//   int? get selectedPaymentModeId => _selectedPaymentModeId;
//   int? _selectedPaymentModeId;  
//   void setSelectedPaymentModeId(int? id) {
//     _selectedPaymentModeId = id;
//      print("select Payment Mode Id: $selectedPaymentModeId");
//     notifyListeners();
//   }

//   Future<PaymentModeModel?> fetchPaymentMode() async {
//     try {
//       final token = await DatabaseControllerProvider().getToken();
//       const urlPaymentMode = AppUrl.paymentModeUri;
//       final response = await dio.get(
//         urlPaymentMode,
//         options: Options(
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );
//       return PaymentModeModel.fromJson(response.data);
//     } catch (error) {
//       if (kDebugMode) {
//         print('Error fetching payment mode: $error');
//       }
//       return null;
      
//     }
//   }

//    Future<ServiceDetailsModel> getServiceDetails (String serviceId)async{
//    final token = await DatabaseControllerProvider().getToken();
//    final urlServiceDetails = '${AppUrl.serviceDetailsUri}?service_id=${serviceId.toString()}';
//    final response = await dio.get(
//         urlServiceDetails,
//         options: Options(
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );
    
//     return ServiceDetailsModel.fromJson(response.data);
//   }

//    Future<void> updateBooking({required int id,String? address, required String fullName, String? email,String? phone, 
//     String? dateAndTimeOfBooking, required String tasktypeid, String? typeOfMeasurement, String? typeOfMaterial,
//     String? paymentModeId, String? remarks, String? notes, String? landmarks,String? nearestServiceCenterId, 
//      String? quantities, required String salutation_id, BuildContext? context,
     
//     required Function() onSuccess,
    
//   }) async {
//     final urlUpdateService = '${AppUrl.updateBookedServiceUri}?id=$id';
//     // print(urlUpdateService);
//     final token = await DatabaseControllerProvider().getToken();
//     _isLoading = true;
//     notifyListeners();
//     final body = {
//       'address': address,
//       'client_name': fullName,
//       'client_email_address': email,
//       'client_mobile_number': phone,
//       'date_time': dateAndTimeOfBooking,
//       'task_type_id': tasktypeid,
//       'type_of_measurement': typeOfMeasurement,
//       'type_of_material': typeOfMaterial,
//       'payment_mode_id': paymentModeId,
//       'remarks': remarks,
//       'notes': notes,
//       'landmark': landmarks,
//       'quantity': quantities,
//       'coordinate': nearestServiceCenterId,
//       'salut': salutation_id,
//     };
//     // print(body);

//     try {
//       final response = await dio.post(urlUpdateService,
//           data: body,
//           options: Options(headers: {
//             "Content-Type": "application/json",
//             "Authorization": "Bearer $token",
//           }));
//       if (response.statusCode == 200) {
//         _isLoading = false;
//         _responseMessage = "Booking updated successfully! ";
//         notifyListeners();
//         onSuccess();
//       } else {
//         _isLoading = false;
//         if (response.statusCode == 401) {
//           _responseMessage = "Something went wrong";
//         } else {
//           _responseMessage = "Error: ${response.statusCode}";
//         }
//         notifyListeners();
//       }
//     } on SocketException catch (_) {
//       _isLoading = false;
//       _responseMessage = "Internet connection is not available";
//       notifyListeners();
//     } catch (e) {
//       _isLoading = false;
//       // _responseMessage = 'Please try again';
//       notifyListeners();
//       // if (kDebugMode) {
//       //   print("Your error is $e");
//       // }
//       if (e is DioException) {
//       final errorResponse = e.response?.data;
//       if (errorResponse != null && errorResponse['address'] != null) {
//         throw _responseMessage = errorResponse['address'][0];
//       }else if (errorResponse != null && errorResponse['client_name'] != null) {
//         throw _responseMessage = errorResponse['client_name'][0];
//       }
//       else if (errorResponse != null && errorResponse['client_mobile_number'] != null) {
//         throw _responseMessage = errorResponse['client_mobile_number'][0];
//       }
//       else if (errorResponse != null && errorResponse['date_time'] != null) {
//         throw _responseMessage = errorResponse['date_time'][0];
//       }
//       else if (errorResponse != null && errorResponse['task_type_id'] != null) {
//         throw _responseMessage = errorResponse['task_type_id'][0];
//       }
//       else if (errorResponse != null && errorResponse['type_of_measurement'] != null) {
//         throw _responseMessage = errorResponse['type_of_measurement'][0];
//       }
//       else if (errorResponse != null && errorResponse['type_of_material'] != null) {
//         throw _responseMessage = errorResponse['type_of_material'][0];
//       }
//       else if (errorResponse != null && errorResponse['payment_mode_id'] != null) {
//         throw _responseMessage = errorResponse['payment_mode_id'][0];
//       }
//       else if (errorResponse != null && errorResponse['salut'] != null) {
//         throw _responseMessage = errorResponse['salut'][0];
//       }
      
     
//     }
//     throw Exception('Please try again');
    
//     }
//   }

//    Future<OnGoingServiceDetailsModel> getOnGoingServiceDetails (String serviceId)async{
//    final token = await DatabaseControllerProvider().getToken();
//    final urlServiceDetails = '${AppUrl.onGoingServiceDetailsUri}?service_id=${serviceId.toString()}';
//    final response = await dio.get(
//         urlServiceDetails,
//         options: Options(
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );
    
//     return OnGoingServiceDetailsModel.fromJson(response.data);
//   }

//   Future<BookingCompletedDetailsModel> getCompletedServiceDetails (String serviceId)async{
//    final token = await DatabaseControllerProvider().getToken();
//    final urlCompletedServiceDetails = '${AppUrl.completedServiceDetailsUri}?service_id=${serviceId.toString()}';
//    final response = await dio.get(
//         urlCompletedServiceDetails,
//         options: Options(
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );
    
//     return BookingCompletedDetailsModel.fromJson(response.data);
//   }

//    Future<void> duplicateBooking({required int id,BuildContext? context,
   
    
//   }) async {
//     final urlDuplicateService = '${AppUrl.duplicateBookedServiceUri}?booking_id=$id';
//     // print(urlUpdateService);
//     final token = await DatabaseControllerProvider().getToken();
//     _isLoading = true;
//     notifyListeners();
   

//     try {
//       final response = await dio.post(urlDuplicateService,
          
//           options: Options(headers: {
//             "Content-Type": "application/json",
//             "Authorization": "Bearer $token",
//           }));
//       if (response.statusCode == 200) {
//         _isLoading = false;
//         _responseMessage = "Booking duplicated successfully! ";
//         notifyListeners();
    
//       } else {
//         _isLoading = false;
//         if (response.statusCode == 401) {
//           _responseMessage = "Something went wrong";
//         } else {
//           _responseMessage = "Error: ${response.statusCode}";
//         }
//         notifyListeners();
//       }
//     } on SocketException catch (_) {
//       _isLoading = false;
//       _responseMessage = "Internet connection is not available";
//       notifyListeners();
//     } catch (e) {
//       _isLoading = false;
//       _responseMessage = 'Please try again';
//       notifyListeners();
//       if (kDebugMode) {
//         print("Your error is $e");
//       }
//     }
//   }

//   int? get selectedSalutationId => _selectedSalutationId;
//   int? _selectedSalutationId;  
//   void setSelectedSalutationId(int? id) {
//     _selectedSalutationId = id;
//      print("select Salutation Id: $selectedSalutationId");
//     notifyListeners();
//   }

  

//   Future<SalutationModel?> fetchSalutation() async {
//     try {
//       final token = await DatabaseControllerProvider().getToken();
//       const urlSalutation = AppUrl.salutationUri;
//       final response = await dio.get(
//         urlSalutation,
//         options: Options(
//           headers: {
//             'Content-Type': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         ),
//       );
//       return SalutationModel.fromJson(response.data);
//     } catch (error) {
//       if (kDebugMode) {
//         print('Error fetching salutation: $error');
//       }
//       return null;
      
//     }
//   }

  
  

// }
// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:theinstallers/model/measurement_details_model.dart';
import '../../utils/exports.dart';
import '../model/service_booking_field.dart';
import '../model/task_type_model.dart';
import 'database/database_controller_provider.dart';

class HomeControllerProvider extends ChangeNotifier {
  final dio = Dio();
    //setter
  final bool _isLoading = false;
  String _responseMessage = '';
  //getter
  bool get isLoading => _isLoading;
  String get responseMessage => _responseMessage;

  void clear() {
    _responseMessage = '';
    notifyListeners();
  }
  
  Future<ServiceBookingFieldModel?> allServiceBookingFields() async {
    final token = await DatabaseControllerProvider().getToken();
    try {
      const urlAllBookingFieldsUri = AppUrl.allBookingFieldsUri;
      final response = await dio.get(
        urlAllBookingFieldsUri,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token",
          },
        ),
      );
      
      return ServiceBookingFieldModel.fromJson(response.data);
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching on boarding: $error');
      }
      return null;
      
    }
  }

  int? _selectedTaskTypeId;
   int? get selectedTaskTypeId => _selectedTaskTypeId;
  void setSelectedTaskTypeId(int? id) {
    _selectedTaskTypeId = id;
    //  print("selectedUserTypeId: $_selectedTaskTypeId");
    notifyListeners();
  }
  void clearSelectedTaskTypeId() {
    _selectedTaskTypeId = null;
    notifyListeners();
  }


  Future<TaskTypeModel?> fetchTasktype() async {
    
    final token = await DatabaseControllerProvider().getToken();

    try {
      
      const urlTaskType = AppUrl.taskTypeUri;
      final response = await dio.get(
        urlTaskType,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token",
            
          },
        ),
      );
      return TaskTypeModel.fromJson(response.data);
    } catch (error) {
      // Handle error
      if (kDebugMode) {
        print('Error fetching user type: $error');
      }
      return null;
      
    }
  }

  Future<MeasurementDetailsModel?> allMeasurementDetailsFields() async {
    final token = await DatabaseControllerProvider().getToken();
    try {
      const urlAllMeasurementDetailsFields = AppUrl.allMeasurementDetailsUri;
      final response = await dio.get(
        urlAllMeasurementDetailsFields,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            "Authorization": "Bearer $token",
          },
        ),
      );
      
      return MeasurementDetailsModel.fromJson(response.data);
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching on boarding: $error');
      }
      return null;
      
    }
  }

}
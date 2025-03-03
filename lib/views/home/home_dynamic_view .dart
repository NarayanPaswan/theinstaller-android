
// import 'package:dio/dio.dart';
// import 'package:provider/provider.dart';
// import 'package:theinstallers/model/service_booking_field.dart';
// import 'package:theinstallers/model/task_type_model.dart';
// import 'package:theinstallers/views/authentication/login_view.dart';
// import 'package:theinstallers/widgets/custom_label.dart';
// import '../../controller/database/database_controller_provider.dart';
// import '../../controller/homeControllerProvider.dart';
// import '../../utils/exports.dart';

// class HomeDynamicView extends StatefulWidget {
//   const HomeDynamicView({super.key});

//   @override
//   State<HomeDynamicView> createState() => _HomeDynamicViewState();
// }

// class _HomeDynamicViewState extends State<HomeDynamicView> {
// final _formKey = GlobalKey<FormState>();
// final homeControllerProvider = HomeControllerProvider();  
// final List<TextEditingController> _controllers = [];
// ServiceBookingFieldModel? bookingFields;
// final _taskTypeIdController = TextEditingController();

//    bool _isLoading = false;
//   String _responseMessage = '';
//   //getter

  
//   void _submitForm() async {
//   final token = await DatabaseControllerProvider().getToken();
//     _isLoading = true;
//     setState(() {
      
//     });
//   if (_formKey.currentState!.validate()) {
//     // Create a FormData object to hold the field values
//     final FormData formData = FormData();
//     formData.fields.add(MapEntry('task_type_id', _taskTypeIdController.text));
//     for (var i = 0; i < _controllers.length; i++) {
//       final fieldName = bookingFields!.fields![i].fieldName!;
//       final value = _controllers[i].text;
//       formData.fields.add(MapEntry(fieldName, value));
//     }

//     try {
//       final dio = Dio();
//       const urlstoreServiceBooking = AppUrl.storeServiceBookingUri;
//       final response = await dio.post(
//         urlstoreServiceBooking,
//           options: Options(
//           headers: {
//             'Content-Type': 'application/json',
//             "Authorization": "Bearer $token",
//           },
//         ),
//         data: formData,
//       );

//       // Handle the response as needed
//       if (response.statusCode == 200) {
//            // ignore: use_build_context_synchronously
//            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text('New booking created successfully'),
//         ));
//         setState(() {
//           _isLoading = false;
//          homeControllerProvider.clearSelectedTaskTypeId(); // Clear the selected task type ID
//           _taskTypeIdController.clear(); // Clear the text in the _taskTypeIdController
//         });
//       } else {
//         // Request failed
//         _isLoading = false;
//         // print('Error submitting data: ${response.statusCode}');
//          if (response.statusCode == 401) {
//           _responseMessage = "Something went wrong";
//         } else {
//           _responseMessage = "Error: ${response.statusCode}";
//         }
//         setState(() {
          
//         });
//       }
//     } catch (error) {
//       // Handle any error that occurred during the HTTP request
//       // print('Error submitting data: $error');
//        _isLoading = false;
//       _responseMessage = "Error submitting data: $error";
//       setState(() {
        
//       });
//     }
//   }
// }

//   @override
//   void dispose() {
//     for (var controller in _controllers) {
//       controller.dispose();
     
//     }
//      _taskTypeIdController.dispose();
//     super.dispose();
//   }



//   @override
//   Widget build(BuildContext context) {
//     homeControllerProvider.fetchTasktype();
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Home Page"),
//           actions: [
//           IconButton(
//               icon: const Icon(Icons.exit_to_app),
//               onPressed: () async{
//                 ///logout
//                 DatabaseControllerProvider().logOut();
//                 PageNavigator(ctx: context).nextPageOnly(page: const LoginView());
//               }
              
//               ),
//         ],
//       ),
//       body:  Form(
//         key: _formKey,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//               const Padding(
//                 padding: EdgeInsets.only(left:8.0),
//                 child: Align(
//                   alignment : Alignment.centerLeft,
//                   child: CustomLabel(text: "Select task type")),
//               ),
              
//               Consumer<HomeControllerProvider>(
//               builder: (context, homeControllerProvider, _) {
//                 return FutureBuilder<TaskTypeModel?>(
//                 future: homeControllerProvider.fetchTasktype(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const CircularProgressIndicator();
//                   } else
//                    if (snapshot.hasError) {
//                     return Text('Error: ${snapshot.error}');
//                   } else if (!snapshot.hasData) {
//                     return const Text('No data available');
//                   } else {
//                     final taskTypeList = snapshot.data!.items;
                
//                     return Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//                         height: 56,
//                         padding: const EdgeInsets.only(left: 6, right: 6),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           border: Border.all(
//                               color: AppColors.dropdownBorderColor, width: 1),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
                        
//                         child: DropdownButton<int>(
//                         style: AppTextStyle.textBoxInputStyle,
//                         hint: const Text("Select Task Type: "),
//                         isExpanded: true,
//                          underline: const SizedBox(),
//                           value: homeControllerProvider.selectedTaskTypeId, 
//                           items: taskTypeList!.map((taskTypeData) {
//                             return DropdownMenuItem<int>(
//                               value: taskTypeData.id,
//                               child: Text(taskTypeData.taskName ?? ''),
//                             );
//                           }).toList(),
//                           onChanged: (newTaskTypeId) async{
//                              homeControllerProvider.setSelectedTaskTypeId(newTaskTypeId);
//                             _taskTypeIdController.text = newTaskTypeId.toString();
                           
//                           },
//                         ),
                
//                       ),
                      
//                     );
                
//                   }
//                 },
//               );
//               }
//               ),
//               //try end
              
             
//             Expanded(
//               child: FutureBuilder<ServiceBookingFieldModel?>(
//               future: homeControllerProvider.allServiceBookingFields(),
//               builder: (context, AsyncSnapshot<ServiceBookingFieldModel?> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 } else {
//                   // Data has been successfully fetched
//                   bookingFields = snapshot.data;
//                   if (bookingFields != null) {
//                   _controllers.clear(); // Clear existing controllers  
//                     return ListView.builder(
//               itemCount: bookingFields!.fields?.length ?? 0,
//               itemBuilder: (context, index) {
//                  final bookingField = bookingFields!.fields?[index];
//                  final controller = TextEditingController(); 
//                   _controllers.add(controller); 
//                 return Column(
//                   children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: AppTextFormField(
//                     labelText: bookingField!.fieldName.toString(),
//                     controller: controller,
//                     hintText: bookingField.fieldName.toString(),
                    
//                   ),
//                 ),
//                   ],
//                 );
//               },
//                     );
//                   } else {
//                     return const Text('No data available');
//                   }
//                 }
//               },
//             ),
//             ),
//               const SizedBox(
//                   height: 25,
//                 ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextButton(
//             onPressed: (){
//               _submitForm();
//             }, 
//             style: TextButton.styleFrom(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               backgroundColor: AppColors.getStartbuttonColor,
//               minimumSize: const Size.fromHeight(50),
//             ),
//             child: Text("Save", style: TextStyle(color: AppColors.whiteColor, fontSize: 14),)
//             ),
//           ),

      
//           ],
//         ),
//       ),
//     );
//   }
// }
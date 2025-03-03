// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:theinstallers/model/task_type_model.dart';
// import 'package:theinstallers/views/dealer_booking/measurement_view.dart';
// import 'package:theinstallers/widgets/custom_label.dart';

// import '../../controller/authControllerProvider/auth_controller_provider.dart';
// import '../../controller/booking_controller_provider.dart';
// import '../../utils/exports.dart';
// import '../drawer/my_drawar_screen.dart';

// class HomeView extends StatefulWidget {
//   const HomeView({super.key});

//   @override
//   State<HomeView> createState() => _HomeViewState();
// }

// class _HomeViewState extends State<HomeView> {
// final _formKey = GlobalKey<FormState>();
// final authenticationProvider = AuthenticationControllerProvider();
// final bookingControllerProvider = BookingControllerProvider();
// final TextEditingController _fullName = TextEditingController();
// final TextEditingController _email = TextEditingController();
// final TextEditingController _phone = TextEditingController();
// final TextEditingController _dateAndTimeOfBooking = TextEditingController();
// final TextEditingController _remarks = TextEditingController();
// final TextEditingController _notes = TextEditingController();
// final TextEditingController _address = TextEditingController();
// final TextEditingController _taskTypeId = TextEditingController();



// @override
//   void dispose() {
//     super.dispose();
//     _fullName.dispose();
//     _email.dispose();
//     _phone.dispose();
//     _dateAndTimeOfBooking.dispose();
//     _remarks.dispose();
//     _notes.dispose();
//     _address.dispose();
//     _taskTypeId.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//      final bookingProviderVisible = Provider.of<BookingControllerProvider>(context); // Use Provider.of here

//     return Scaffold(
//       drawer: const MyDrawerScreen(),
//        appBar: AppBar(
//         title: const Text(Labels.newServiceBooking,),
        
//       ),
//       body:  SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
                
//                 TextFormField(
//                 style: AppTextStyle.textBoxInputStyle,
//                 decoration:  InputDecoration(
//                   hintText: Labels.addressSearch,
//                   filled: true,
//                   fillColor: Colors.white,
//                   focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: const BorderSide(
//                   width: 1.0,
//                   color: Colors.black,
//                   ),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide(
//                   width: 1.0,
//                   color: AppColors.dropdownBorderColor,
//                   ),
//                   ),
//                   border:  OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8)
//                   ),
//                 ),
//                 keyboardType: TextInputType.name,
//                 controller: _address,
//                ),
//                   const SizedBox(
//                       height: 5,
//                     ),
           
//               const Padding(
//                 padding: EdgeInsets.only(top:8.0, bottom: 8.0),
//                 child: Align(
//                   alignment : Alignment.centerLeft,
//                   child: CustomLabel(text: Labels.serviceType)),
//               ),
//                Consumer<BookingControllerProvider>(
//               builder: (context, bookingProvider, _) {
//                 return FutureBuilder<TaskTypeModel?>(
//                 future: bookingProvider.fetchTaskType(),
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
                
//                     return Container(
//                       height: 56,
//                       padding: const EdgeInsets.only(left: 6, right: 6),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(
//                             color: AppColors.dropdownBorderColor, width: 1),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
                      
//                       child: DropdownButton<int>(
//                       style: AppTextStyle.textBoxInputStyle,
//                       hint: const Text("Select Service Type: "),
//                       isExpanded: true,
//                        underline: const SizedBox(),
//                         value: bookingProvider.selectedTaskTypeId, 
//                         items: taskTypeList!.map((taskType) {
//                           return DropdownMenuItem<int>(
//                             value: taskType.id,
//                             child: Text(taskType.taskName ?? ''),
//                           );
//                         }).toList(),
//                         onChanged: (newTaskTypeId) async{
//                            bookingProvider.setSelectedTaskTypeId(newTaskTypeId);
//                           _taskTypeId.text = newTaskTypeId.toString();
                           
//                         },
                        
//                       ),
                      
                
//                     );
                
//                   }
//                 },
//               );
//               }
//               ),

//                 const SizedBox(
//                       height: 5,
//                     ),

               

//                   AppTextFormField(
//                     labelText: Labels.fullName,
//                     extraLabelText: " *",
//                     controller: _fullName,
//                     hintText: Labels.fullName,
//                     keyboardType: TextInputType.name,
//                     validator: (value) {
//                         return bookingControllerProvider.validateName(value!);
//                     },
                    
//                   ),
//                   const SizedBox(
//                       height: 5,
//                     ),
//                  AppTextFormField(
//                   labelText: Labels.yourEmail,
//                   extraLabelText: " *",
//                   controller: _email,
//                   hintText: Labels.email,
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) {
//                         return authenticationProvider.emailValidate(value!);
//                       },
//                 ),
//                 const SizedBox(
//                     height: 5,
//                   ),     
//                AppTextFormField(
//                   labelText: Labels.mobileNo,
//                   extraLabelText: " *",
//                   controller: _phone,
//                   hintText: Labels.mobileNoHint,
//                   keyboardType: TextInputType.number,
//                   validator: (value) {
//                         return bookingControllerProvider.validateMobile(value!);
//                       },
//                 ),
                
//                 const SizedBox(
//                     height: 5,
//                   ), 
                
      
//                 AppTextFormField(
//                 labelText: Labels.dateAndTime,
//                 extraLabelText: " *",   
//                 readOnly: true,
//                 controller: _dateAndTimeOfBooking,
//                 suffixIcon: Icons.calendar_today_rounded,
//                 hintText: 'DD/MM/YYYY',
//                 onTap: () async {
//                   DateTime? pickedDate = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime.now(),
//                     lastDate: DateTime(2030),
//                   );
      
//                   if (pickedDate != null) {
//                     // ignore: use_build_context_synchronously
//                     TimeOfDay? pickedTime = await showTimePicker(
//                       context: context,
//                       initialTime: TimeOfDay.now(),
//                     );
      
//                     if (pickedTime != null) {
//                       DateTime selectedDateTime = DateTime(
//                         pickedDate.year,
//                         pickedDate.month,
//                         pickedDate.day,
//                         pickedTime.hour,
//                         pickedTime.minute,
//                       );
      
//                       bookingControllerProvider.updateSelectedDateTime(selectedDateTime);
//                       _dateAndTimeOfBooking.text = DateFormat('dd/MM/yyyy HH:mm').format(selectedDateTime);
//                     }
//                   }
//                 },
//                 validator: (value) {
//                         return bookingControllerProvider.validateDateTime(value!);
//                       },
//               ),

       

//                Visibility(
//                   visible: bookingProviderVisible.selectedTaskTypeId == 1 ? true : false,
//                   child: Padding(
//                     padding: const EdgeInsets.only(top:16.0),
//                     child: TextFormField(
//                       onTap: (){
//                          PageNavigator(ctx: context).nextPage(
//                       page: const MeasurementView(),
//                     );
//                       },
//                     readOnly: true,  
//                     style: AppTextStyle.textBoxInputStyle,
//                     decoration:  InputDecoration(
//                       hintText: Labels.measurementDetails,
                      
//                       filled: true,
//                       fillColor: Colors.white,
//                       focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: const BorderSide(
//                       width: 1.0,
//                       color: Colors.black,
//                       ),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide(
//                       width: 1.0,
//                       color: AppColors.dropdownBorderColor,
//                       ),
//                       ),
//                       border:  OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8)
//                       ),
//                       suffixIcon: Container(
//                         margin: const EdgeInsets.only(right: 10),
//                                     width: 20,
//                                     decoration:  BoxDecoration(
//                                       borderRadius: const BorderRadius.all(Radius.circular(5)),
//                                       color: AppColors.ligthGreyColor, 
//                                     ),
                              
//                                     child: const Center(
//                                       child: Icon(
//                                         Icons.arrow_forward_ios,
//                                         size: 25,
//                                       ),
//                                     ),
//                                   ),
//                     ),
                          
//                                  ),
//                   ),
//                 ),

//                 Visibility(
//                   visible: bookingProviderVisible.selectedTaskTypeId == 1 ? true : false,
//                   child: Padding(
//                     padding: const EdgeInsets.only(top:16.0),
//                     child: TextFormField(
//                     readOnly: true,  
//                     style: AppTextStyle.textBoxInputStyle,
//                     decoration:  InputDecoration(
//                       hintText: Labels.measurementTable,
                      
//                       filled: true,
//                       fillColor: Colors.white,
//                       focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: const BorderSide(
//                       width: 1.0,
//                       color: Colors.black,
//                       ),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide(
//                       width: 1.0,
//                       color: AppColors.dropdownBorderColor,
//                       ),
//                       ),
//                       border:  OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8)
//                       ),
//                       suffixIcon: Container(
//                         margin: const EdgeInsets.only(right: 10),
//                                     width: 20,
//                                     decoration:  BoxDecoration(
//                                       borderRadius: const BorderRadius.all(Radius.circular(5)),
//                                       color: AppColors.ligthGreyColor, 
//                                     ),
                              
//                                     child: const Center(
//                                       child: Icon(
//                                         Icons.arrow_forward_ios,
//                                         size: 25,
//                                       ),
//                                     ),
//                                   ),
//                     ),
                          
//                                  ),
//                   ),
//                 ),


               
//                 const SizedBox(
//                       height: 5,
//                     ),

                    
      
//                AppTextFormField(
//                   labelText: Labels.remarks,
//                   controller: _remarks,
//                   hintText: Labels.typeHere,
//                   keyboardType: TextInputType.multiline,
//                   maxLines: 4,
                  
//                 ),
                
//                 const SizedBox(
//                     height: 5,
//                   ), 

//                  AppTextFormField(
//                   labelText: Labels.notes,
//                   controller: _notes,
//                   hintText: Labels.typeHere,
//                   keyboardType: TextInputType.multiline,
//                   maxLines: 4,
                  
//                 ),
                
//                 const SizedBox(
//                     height: 5,
//                   ),
//                 Consumer<BookingControllerProvider>(
//                 builder: (context, book, child) {
//                        WidgetsBinding.instance.addPostFrameCallback((_) {
//                           if (book.responseMessage != '') {
//                             showMessage(
//                                 message: book.responseMessage, context: context);
//                             book.clear();
//                           }
//                         });
          
//                   return customButton(
//                     text: Labels.bookService.toUpperCase(),
//                        ontap: () async {
//                       if (_formKey.currentState!.validate()) {
          
//                           try {
//                           await  book.newBooking(
//                           fullName: _fullName.text.trim(),
//                           email: _email.text.trim(), 
//                           phone: _phone.text.trim(),
//                           dateAndTimeOfBooking: _dateAndTimeOfBooking.text,
//                           remarks: _remarks.text.trim(), 
//                           notes: _notes.text.trim(),
//                           address: _address.text.trim(),
//                           tasktypeid: _taskTypeId.text.trim(),
//                               onSuccess: () {
//                               // Clear the text form field values here
//                               _fullName.clear();
//                               _email.clear();
//                               _phone.clear();
//                               _dateAndTimeOfBooking.clear();
//                               _remarks.clear();
//                               _notes.clear();
//                               _address.clear();
//                               _taskTypeId.clear();
//                             },
//                           );
                          
//                           } catch (e) {
//                             AppErrorSnackBar(context).error(e);
//                           }
          
          
//                       }
//                     },
              
//                   context: context,
//                   status: book.isLoading,
              
//                   );
//                 }
//               ),      
           
//               ],
//             ),
//           ),
//         ),
//       ),

    
//     );
//   }
// }
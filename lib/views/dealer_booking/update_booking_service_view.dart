import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_dropdown_flutter/multiselect_dropdown_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theinstallers/model/salutation_model.dart';
import 'package:theinstallers/widgets/dropdown_label.dart';
import '../../controller/authControllerProvider/auth_controller_provider.dart';
import '../../controller/booking_controller_provider.dart';
import '../../model/payment_mode_model.dart';
import '../../model/product_type_model.dart';
import '../../model/sub_product_type_model.dart';
import '../../model/task_type_model.dart';
import '../../utils/exports.dart';
import '../../widgets/custom_label.dart';
import '../google_map_address/add_address_view.dart';
import '../home/home_view.dart';
import 'package:dio/dio.dart';

class UpdateBookingServiceView extends StatefulWidget {
  int id; int taskTypeId; String address; String fullName; String? email; String phone;
  String dateAndTimeOfBooking; String typeOfMeasurement; String typeOfMaterial;
  int paymentModeId; String remarks; String notes; String? landmark;String? quantity;
  int? salutationId; int? productTypeId;
  final List<int>? subProductIds;
  

  UpdateBookingServiceView({super.key, required this.id, required this.taskTypeId, 
  required this.address, required this.fullName, this.email, required this.phone,
  required this.dateAndTimeOfBooking, required this.typeOfMeasurement,
  required this.typeOfMaterial, required this.paymentModeId, required this.remarks,
  required this.notes, this.landmark, this.quantity, this.salutationId, this.productTypeId,
  this.subProductIds,
  });
  
  @override
  State<UpdateBookingServiceView> createState() => _UpdateBookingServiceViewState();
}

class _UpdateBookingServiceViewState extends State<UpdateBookingServiceView> {
  final _formKey = GlobalKey<FormState>();
  final authenticationProvider = AuthenticationControllerProvider();
  final bookingControllerProvider = BookingControllerProvider();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _dateAndTimeOfBooking = TextEditingController();
  final TextEditingController _taskTypeId = TextEditingController();
  // final TextEditingController _typeOfMeasurement = TextEditingController();
  final TextEditingController _typeOfMaterial = TextEditingController();
  final TextEditingController _paymentModeId = TextEditingController();
  final TextEditingController _remarks = TextEditingController();
  final TextEditingController _notes = TextEditingController();
  final TextEditingController _landmark = TextEditingController();
  final TextEditingController _quantity = TextEditingController();
  final TextEditingController _salutationId = TextEditingController();
  final TextEditingController _productTypeId = TextEditingController();
  SalutationModel? _salutationsData;
  TaskTypeModel? _serviceTypeData;
  PaymentModeModel? _paymentModeData;
  ProductTypeModel? _productTypeData;
  SubProductTypeModel? _subProductTypeData;
  List<int> _selectedSubProductIds = [];
  bool _isDataFetched = false;
  bool _isFetchingDataForLoader = false;

  final dio = Dio();
  double? latitude;
  double? longitude;
  int? nearestId;


    
  @override
  void initState() {
    super.initState();
    // print("Your address is ${widget.address}");
    print("Your task type id is ${widget.taskTypeId}");
    print('you salution id is: ${widget.salutationId}');
    print('sub product id: ${widget.subProductIds}');
    _productTypeId.text = widget.productTypeId?.toString() ?? '';
    _selectedSubProductIds = widget.subProductIds ?? [];
    _fetchInitialData();
    setState(() {
      _address.text = widget.address.toString();
      _fullName.text = widget.fullName.toString();
      _email.text = widget.email.toString();
      _phone.text = widget.phone.toString();
      _dateAndTimeOfBooking.text = widget.dateAndTimeOfBooking.toString();
      _taskTypeId.text = widget.taskTypeId.toString();
      // _typeOfMeasurement.text = widget.typeOfMeasurement.toString();
      _typeOfMaterial.text = widget.typeOfMaterial.toString();
      _paymentModeId.text = widget.paymentModeId.toString();
      _remarks.text = widget.remarks.toString();
      _notes.text = widget.notes.toString();
      _landmark.text = widget.landmark.toString();
      _quantity.text = widget.quantity.toString();
      _salutationId.text = widget.salutationId != null ? widget.salutationId.toString() : '';
      // _productTypeId.text = widget.productTypeId != null ? widget.productTypeId.toString() : '';
      // _selectedSubProductIds = widget.subProductIds ?? [];   
    });
  }

   @override
  void dispose() {
    _address.dispose();
    _fullName.dispose();
    _email.dispose();
    _phone.dispose();
    _dateAndTimeOfBooking.dispose();
    _taskTypeId.dispose();
    // _typeOfMeasurement.dispose();
    _typeOfMaterial.dispose();
    _paymentModeId.dispose();
    _remarks.dispose();
    _notes.dispose();
    _landmark.dispose();
    _quantity.dispose();
    _salutationId.dispose();
    _productTypeId.dispose();
    super.dispose();
  }

   Future<void> _fetchInitialData() async {
    setState(() {
      _isFetchingDataForLoader = true;
    });

    _productTypeData = await bookingControllerProvider.fetchProductType();
    if (widget.productTypeId != null) {
      await _fetchSubProductTypeData(widget.productTypeId.toString());
    }

    setState(() {
      _isFetchingDataForLoader = false;
    });
  }


  Future<Position?> getCurrentLocation() async {
     LocationPermission permission = await Geolocator.requestPermission();
     if (permission == LocationPermission.denied) {
      return null;
     }else if(permission == LocationPermission.deniedForever){
      return null;
     }
      return await Geolocator.getCurrentPosition();
   }

    Future<String?> getLatitudeValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('latitude');
  }

  Future<String?> getLongitudeValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('longitude');
  }

  Future<void> convertAddressToLocations() async {
    String address = _address.text;
    if (address.isNotEmpty) {
      try {
        List<Location> locations = await locationFromAddress(address);
        if (locations.isNotEmpty) {
          setState(() {
            latitude = locations.first.latitude;
            longitude = locations.first.longitude;

            print("my lat" + latitude.toString());
            print("my lat" + longitude.toString());
          });
        } else {
          debugPrint("Location list is empty");
        }
      } catch (e) {
        debugPrint("Error fetching location: $e");
      }
    } else {
      debugPrint("Address is null or empty");
    }
  }

   Future<int?> fetchNearestServiceCenter() async {
     // Call convertAddressToLocations to ensure latitude and longitude are set
  await convertAddressToLocations();
  
    if (latitude != null && longitude != null) {
      final urlGetNearestServiceCenter =
          '${AppUrl.nearestServiceCenter}?latitude=$latitude&longitude=$longitude';
      final response = await dio.get(
        urlGetNearestServiceCenter,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      int? nearestId = response.data['items']['id'];
      print(nearestId.toString());
      return nearestId;
    } else {
      debugPrint("Did not get any nearest id");
      return null;
    }
  }
  bool isBooking = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch data only if it hasn't been fetched yet
    if (!_isDataFetched) {
      _fetchData();
      _fetchServiceTypeData();
      _fetchPaymentModeData();
      // _fetchProductTypeData();
      _isDataFetched = true;
    }
  }

  Future<void> _fetchData() async {
    setState(() {
      _isFetchingDataForLoader = true; 
    });
    _salutationsData = await bookingControllerProvider.fetchSalutation();
    setState(() {
      _isFetchingDataForLoader = false; 
    });
  }
  
  Future<void> _fetchSubProductTypeData(String productTypeId) async {
  setState(() {
    _isFetchingDataForLoader = true;
    _subProductTypeData = null;
    
  });
  _subProductTypeData = await bookingControllerProvider.fetchSubProductType(productTypeId);
  setState(() {
    _isFetchingDataForLoader = false;
  });
  }
  Future<void> _fetchServiceTypeData() async {
    setState(() {
      _isFetchingDataForLoader = true; 
    });
    _serviceTypeData = await bookingControllerProvider.fetchTaskType();
    setState(() {
      _isFetchingDataForLoader = false; 
    });
  }
  Future<void> _fetchPaymentModeData() async {
    setState(() {
      _isFetchingDataForLoader = true; 
    });
    _paymentModeData = await bookingControllerProvider.fetchPaymentMode();
    setState(() {
      _isFetchingDataForLoader = false; 
    });
  }

  @override
  Widget build(BuildContext context) {
     final bookingProviderVisible =
        Provider.of<BookingControllerProvider>(context);
    return  Scaffold(
   appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Update booking',
          style: AppTextStyle.ongoingBooking,
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              
                TextFormField(
                  style: AppTextStyle.textBoxInputStyle,
                  decoration: InputDecoration(
                    hintText: Labels.addressSearch,
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        width: 1.0,
                        color: Colors.black,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        width: 1.0,
                        color: AppColors.dropdownBorderColor,
                      ),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    suffixIcon: InkWell(
                    // onTap: () async {
                    //      PageNavigator(ctx: context).nextPage(
                    //       page:  AddAddressView(
                    //         onAddressSelected: (address) async {
                    //         List<Location> locations = await locationFromAddress(address);
                    //         if (locations.isNotEmpty) {
                    //           setState(() {
                    //             latitude = locations.first.latitude;
                    //             longitude = locations.first.longitude;
                    //             _address.text = address;
                    //           });
                    //         }
                    //       },
                           
                    //       ),
                    //     ); 
                    // },

                    onTap: () async {
                         PageNavigator(ctx: context).nextPage(
                          page:  AddAddressView(
                            onAddressSelected: (address) async {
                                setState(() {
                                _address.text = address;
                              });
                          
                          },
                           
                          ),
                        ); 
                    },

                       

                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 25,
                        decoration: const BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.circular(5)),
                          
                        ),
                        child:  Center(
                          child: Image.asset(
                            AssetsPath.loc,
                            width: 48.0,
                            height: 38.0,
                            fit: BoxFit.cover,
                          ),
                        
                        ),
                      ),
                    ),
                  ),
                  
                  keyboardType: TextInputType.name,
                  controller: _address,
                  validator: (value) {
                    return bookingControllerProvider.validateBlankField(value!);
                  },
                ),

                 const SizedBox(
                  height: 5,
                ),
                AppTextFormField(
                  labelText: Labels.landmark,
                  controller: _landmark,
                  hintText: Labels.landmark,
                  keyboardType: TextInputType.name,
                 
                ),
                
                const SizedBox(
                  height: 5,
                ),
                // Padding(
                //     padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                //     child: Align(
                //     alignment: Alignment.centerLeft,
                //     child: RichText(
                //     textAlign: TextAlign.left,
                //     text: TextSpan(
                //         text: Labels.customerName,
                //         style: AppTextStyle.continueWith,
                //         children: [
                //           TextSpan(
                //             text: " *",
                //             style: AppTextStyle.extraLabelTextColor,
                //           )
                //         ]),
                //         ),
                        
                //         ),
                //   ),
                const DropdownLabel(
                  text: Labels.customerName,
                  ),
                Row(
                  children: [
                    if (_isFetchingDataForLoader)
                  const CircularProgressIndicator()
                  else
                    SizedBox(
                       width: MediaQuery.of(context).size.width * 0.2,
                     height: 58,
                      child: Consumer<BookingControllerProvider>(
                                      builder: (context, bookingProvider, _) {

                                        return Container(
                          height: 56,
                          padding: const EdgeInsets.only(left: 6, right: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: AppColors.dropdownBorderColor,
                                width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<int>(
                            style: AppTextStyle.textBoxInputStyle,
                            hint: const Text(""),
                            isExpanded: true,
                            underline: const SizedBox(),
                            value: bookingProvider.selectedSalutationId ?? widget.salutationId,
                            items: _salutationsData?.items!.map((salutation) {
                              return DropdownMenuItem<int>(
                                value: salutation.id,
                                child: Text(salutation.salutationList ?? ''),
                              );
                            }).toList(),
                            onChanged: (newSalutationId) async {
                              bookingProvider
                                  .setSelectedSalutationId(newSalutationId);
                              _salutationId.text = newSalutationId.toString();
                            },
                          ),
                        );
                      
                                  }),

                                  
                    ),

                    const SizedBox(width: 3,),
                  
                  Expanded(
                  child: TextFormField(
                  controller: _fullName,
                    keyboardType: TextInputType.name,
                    // validator: (value) {
                    //   return bookingControllerProvider.validateName(value!);
                    // },
                    
                  style: AppTextStyle.textBoxInputStyle,
                  decoration:  InputDecoration(
                    hintText: Labels.customerName,
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                    width: 1.0,
                    color: Colors.black,
                    ),
                    ),
                    enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                    width: 1.0,
                    color: AppColors.dropdownBorderColor,
                    ),
                    ),
                    border:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)
                    ),
                                 
                                 
                  ),
                                 
                                 
                  ),
                                  ),

                  ],
                ),
                /*
                 AppTextFormField(
                  labelText: Labels.customerName,
                  extraLabelText: " *",
                  controller: _fullName,
                  hintText: Labels.customerName,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    return bookingControllerProvider.validateName(value!);
                  },
                ),
                */
                const SizedBox(
                  height: 5,
                ),
                AppTextFormField(
                  labelText: Labels.customerEmailIfany,
                  controller: _email,
                  hintText: Labels.email,
                  keyboardType: TextInputType.emailAddress,
                  
                ),
                const SizedBox(
                  height: 5,
                ),
                 AppTextFormField(
                  labelText: Labels.customerContactNo,
                  extraLabelText: " *",
                  controller: _phone,
                  hintText: Labels.mobileNoHint,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    return bookingControllerProvider.validateMobile(value!);
                  },
                ),
                const SizedBox(
                  height: 5,
                ),

                  AppTextFormField(
                  labelText: Labels.dateAndTime,
                  extraLabelText: " *",
                  readOnly: true,
                  controller: _dateAndTimeOfBooking,
                  suffixIcon: Icons.calendar_today_rounded,
                  hintText: 'DD/MM/YYYY',
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2030),
                    );

                    if (pickedDate != null) {
                      // ignore: use_build_context_synchronously
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (pickedTime != null) {
                        DateTime selectedDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );

                        bookingControllerProvider
                            .updateSelectedDateTime(selectedDateTime);
                        _dateAndTimeOfBooking.text =
                            DateFormat('dd/MM/yyyy HH:mm')
                                .format(selectedDateTime);
                      }
                    }
                  },
                  validator: (value) {
                    return bookingControllerProvider.validateDateTime(value!);
                  },
                ),
               
                 const Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomLabel(text: Labels.serviceType)),
                ),
                if (_isFetchingDataForLoader)
                  const CircularProgressIndicator()
                  else
                Consumer<BookingControllerProvider>(
                    builder: (context, bookingProvider, _) {
                  return Container(
                            height: 56,
                            padding: const EdgeInsets.only(left: 6, right: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: AppColors.dropdownBorderColor,
                                  width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButton<int>(
                              style: AppTextStyle.textBoxInputStyle,
                              hint: const Text("Select Service Type: "),
                              isExpanded: true,
                              underline: const SizedBox(),
                              value: bookingProvider.selectedTaskTypeId ?? widget.taskTypeId,
                              items: _serviceTypeData?.items!.map((taskType) {
                                return DropdownMenuItem<int>(
                                  value: taskType.id,
                                  child: Text(taskType.taskName ?? ''),
                                );
                              }).toList(),
                              onChanged: (newTaskTypeId) async {
                                bookingProvider
                                    .setSelectedTaskTypeId(newTaskTypeId);
                                _taskTypeId.text = newTaskTypeId.toString();
                              },
                            ),
                          );
                }),

                // const SizedBox(
                //   height: 5,
                // ),
                //  AppTextFormField(
                //   labelText: Labels.typeOfMeasurement,
                //   extraLabelText: " *",
                //   controller: _typeOfMeasurement,
                //   hintText: Labels.typeOfMeasurement,
                //   keyboardType: TextInputType.name,
                //   validator: (value) {
                //     return bookingControllerProvider.validateBlankField(value!);
                //   },
                // ),

                const SizedBox(
                  height: 5,
                ),

                  const Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomLabel(text: Labels.productType)),
                ),
              if (_isFetchingDataForLoader)
                  const CircularProgressIndicator()
                else
                  Consumer<BookingControllerProvider>(
                    builder: (context, bookingProvider, _) {
                      return Container(
                        height: 56,
                        padding: const EdgeInsets.only(left: 6, right: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: AppColors.dropdownBorderColor,
                              width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<int>(
                          style: AppTextStyle.textBoxInputStyle,
                          hint: const Text("Choose one: "),
                          isExpanded: true,
                          underline: const SizedBox(),
                          value: bookingProvider.selectedProductTypeId ?? widget.productTypeId,
                          items: _productTypeData?.items!.map((productMode) {
                            return DropdownMenuItem<int>(
                              value: productMode.id,
                              child: Text(productMode.productList ?? ''),
                            );
                          }).toList(),
                          onChanged: (newProductTypeId) async {
                            bookingProvider.setSelectedProductTypeId(newProductTypeId);
                            _productTypeId.text = newProductTypeId.toString();
                             // Clear the selected sub-product ids when product type changes
                            setState(() {
                              _selectedSubProductIds.clear();
                            });

                            await _fetchSubProductTypeData(_productTypeId.text);
                          },
                        ),
                      );
                    },
                  ),

                 const SizedBox(
                  height: 5,
                ),

                  //show product list start

                
                 if (_subProductTypeData != null && _subProductTypeData!.items != null) ...[
                  const DropdownLabel(text: Labels.subProductType),
                  SizedBox(
                    height: 65,
                    child: MultiSelectDropdown(
                      textStyle: AppTextStyle.textBoxInputStyle,
                      listTextStyle: AppTextStyle.textBoxInputStyle,
                      list: _subProductTypeData!.items!.map((subProductType) {
                        return {'id': subProductType.id.toString(), 'label': subProductType.subProductList ?? ''};
                      }).toList(),
                      initiallySelected: _selectedSubProductIds.map((id) {
                        try {
                          final subProduct = _subProductTypeData!.items!.firstWhere((item) => item.id == id);
                          return {'id': id.toString(), 'label': subProduct.subProductList ?? ''};
                        } catch (e) {
                          return {'id': id.toString(), 'label': 'Unknown'};
                        }
                      }).toList(),
                      onChange: (newList) {
                        setState(() {
                          _selectedSubProductIds = newList.map((item) => int.parse(item['id'])).toList();
                        });
                      },
                      numberOfItemsLabelToShow: 2,
                      whenEmpty: 'Choose from the list',
                    ),
                  ),
                ],

                  //show product list end
             
                const SizedBox(
                  height: 5,
                ),

                AppTextFormField(
                  labelText: Labels.typeOfMaterial,
                  extraLabelText: " *",
                  controller: _typeOfMaterial,
                  hintText: Labels.typeOfMaterial,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    return bookingControllerProvider.validateBlankField(value!);
                  },
                ),

                 const SizedBox(
                  height: 5,
                ),

                AppTextFormField(
                  labelText: Labels.quantity,
                  controller: _quantity,
                  hintText: Labels.quantity,
                  keyboardType: TextInputType.text,
                 
                ),
             
                const SizedBox(
                  height: 5,
                ),

                  const Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: CustomLabel(text: Labels.paymentMode)),
                ),
                if (_isFetchingDataForLoader)
                  const CircularProgressIndicator()
                  else
                Form(
                  child: Consumer<BookingControllerProvider>(
                      builder: (context, bookingProvider, _) {
                    return Container(
                              height: 56,
                              padding: const EdgeInsets.only(left: 6, right: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: AppColors.dropdownBorderColor,
                                    width: 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: DropdownButton<int>(
                                style: AppTextStyle.textBoxInputStyle,
                                hint: const Text("Choose one: "),
                                isExpanded: true,
                                underline: const SizedBox(),
                                value: bookingProvider.selectedPaymentModeId ?? widget.paymentModeId,
                                items: _paymentModeData?.items!.map((paymentMode) {
                                  return DropdownMenuItem<int>(
                                    value: paymentMode.id,
                                    child: Text(paymentMode.paymentMethodName ?? ''),
                                  );
                                }).toList(),
                                onChanged: (newPaymentModeId) async {
                                  bookingProvider
                                      .setSelectedPaymentModeId(newPaymentModeId);
                                  _paymentModeId.text = newPaymentModeId.toString();
                                },
                              ),
                            );
                  }),
                ),
                const SizedBox(
                  height: 5,
                ),

                 AppTextFormField(
                  labelText: Labels.remarks,
                  controller: _remarks,
                  hintText: Labels.typeHere,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                ),
                const SizedBox(
                  height: 5,
                ),
                  AppTextFormField(
                  labelText: Labels.notes,
                  controller: _notes,
                  hintText: Labels.typeHere,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                ),


                const SizedBox(
                  height: 5,
                ),

                

                

                 Consumer<BookingControllerProvider>(
                builder: (context, book, child) {
                       WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (book.responseMessage != '') {
                            showMessage(
                                message: book.responseMessage, context: context);
                            book.clear();
                          }
                        });
          
                  return customButton(
                    text: Labels.updateBookService.toUpperCase(),
                       ontap:isBooking // Disable the button if booking is in progress
                          ? null
                          : 
                        () async {
                      if (_formKey.currentState!.validate()) {
                         setState(() {
                                  isBooking = true; // Start booking process
                                });
          
                          try {
                    
                          int? nearestServiceCenterId = await fetchNearestServiceCenter();
                          if (nearestServiceCenterId != null) {
                             await  book.updateBooking(
                          id: widget.id,
                          address: _address.text.trim(),  
                          fullName: _fullName.text.trim(),
                          email: _email.text.trim(), 
                          phone: _phone.text.trim(),
                          dateAndTimeOfBooking: _dateAndTimeOfBooking.text,
                          tasktypeid: _taskTypeId.text.trim(),
                          // typeOfMeasurement: _typeOfMeasurement.text.trim(),
                          typeOfMaterial: _typeOfMaterial.text.trim(),
                          paymentModeId: _paymentModeId.text.trim(),
                          remarks: _remarks.text.trim(), 
                          notes: _notes.text.trim(),
                          landmarks: _landmark.text.trim(),
                          quantities: _quantity.text.trim(),
                          nearestServiceCenterId: nearestServiceCenterId.toString(),
                          salutation_id: _salutationId.text.trim(),
                          productTypeId: _productTypeId.text.trim(),
                          subProductIds: _selectedSubProductIds,
                              onSuccess: () {
                              // Clear the text form field values here
                               _address.clear();
                              _fullName.clear();
                              _email.clear();
                              _phone.clear();
                              _dateAndTimeOfBooking.clear();
                               _taskTypeId.clear();
                              //  _typeOfMeasurement.clear();
                               _typeOfMaterial.clear();
                              _paymentModeId.clear();
                              _remarks.clear();
                              _notes.clear();
                              _landmark.clear();
                              _quantity.clear();
                              _productTypeId.clear();
                            },
                         
                          );
                           } 
                          
                         

                            // ignore: use_build_context_synchronously
                            PageNavigator(ctx: context)
                              .nextPageOnly(page: const HomeView());
                          
                          } catch (e) {
                            AppErrorSnackBar(context).error(e);
                          }finally {
                                  setState(() {
                                    isBooking = false; // End booking process
                                  });
                                }
          
         
                      }
                    },
              
                  context: context,
                  // status: book.isLoading,
                   status: isBooking, // Pass booking status to the button
              
                  );
                }
              ),   
               
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
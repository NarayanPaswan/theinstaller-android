import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:theinstallers/model/payment_mode_model.dart';
import 'package:theinstallers/model/task_type_model.dart';
import 'package:theinstallers/views/dealer_booking/image_gallery_view.dart';
import 'package:theinstallers/views/dealer_booking/video_gallery_view.dart';
import 'package:theinstallers/views/google_map_address/add_address_view.dart';
import 'package:theinstallers/widgets/dropdown_label.dart';
import '../../controller/authControllerProvider/auth_controller_provider.dart';
import '../../controller/booking_controller_provider.dart';
import '../../model/product_type_model.dart';
import '../../model/salutation_model.dart';
import '../../model/sub_product_type_model.dart';
import '../../utils/exports.dart';
import '../home/home_view.dart';
import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:io';
import 'package:multiselect_dropdown_flutter/multiselect_dropdown_flutter.dart';

class ServiceBookingView extends StatefulWidget {
  const ServiceBookingView({super.key});

  @override
  State<ServiceBookingView> createState() => _ServiceBookingViewState();
}

class _ServiceBookingViewState extends State<ServiceBookingView> {
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
  final TextEditingController _productTypeId = TextEditingController();

  List<String> selectedImagePaths = [];
  List<String> selectedVideoPaths = [];

  final TextEditingController _salutationId = TextEditingController();
  SalutationModel? _salutationsData;
  TaskTypeModel? _serviceTypeData;
  ProductTypeModel? _productTypeData;
  SubProductTypeModel? _subProductTypeData;
  PaymentModeModel? _paymentModeData;
  bool _isDataFetched = false;
  bool _isFetchingDataForLoader = false;
  List<int> _selectedSubProductIds = [];

  final dio = Dio();
  double? latitude;
  double? longitude;
  int? nearestId;

  @override
  void dispose() {
    super.dispose();
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
  }

  Future<int?> fetchNearestServiceCenter() async {
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
      _fetchProductTypeData();
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

  Future<void> _fetchServiceTypeData() async {
    setState(() {
      _isFetchingDataForLoader =
          true; // Set to true when starting data fetching
    });
    _serviceTypeData = await bookingControllerProvider.fetchTaskType();
    setState(() {
      _isFetchingDataForLoader = false;
    });
  }

  Future<void> _fetchPaymentModeData() async {
    setState(() {
      _isFetchingDataForLoader =
          true; // Set to true when starting data fetching
    });
    _paymentModeData = await bookingControllerProvider.fetchPaymentMode();
    setState(() {
      _isFetchingDataForLoader = false;
    });
  }

  Future<void> _fetchProductTypeData() async {
    setState(() {
      _isFetchingDataForLoader =
          true; // Set to true when starting data fetching
    });
    _productTypeData = await bookingControllerProvider.fetchProductType();
    setState(() {
      _isFetchingDataForLoader = false;
    });
  }

  Future<void> _fetchSubProductTypeData(String productTypeId) async {
    setState(() {
      _isFetchingDataForLoader = true;
      _subProductTypeData = null;
    });
    _subProductTypeData =
        await bookingControllerProvider.fetchSubProductType(productTypeId);
    setState(() {
      _isFetchingDataForLoader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingController = Provider.of<BookingControllerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          Labels.newServiceBooking,
          style: AppTextStyle.ongoingBooking,
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: WillPopScope(
        onWillPop: () async {
          // Reset selectedPaymentModeId to null when back button is pressed
          bookingController.setSelectedPaymentModeId(null);
          bookingController.setSelectedTaskTypeId(null);
          bookingController.setSelectedSalutationId(null);
          bookingController.setSelectedProductTypeId(null);

          return true; // Allow back navigation
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    onTap: () {
                      PageNavigator(ctx: context).nextPage(
                        page: AddAddressView(
                          onAddressSelected: (address) async {
                            List<Location> locations =
                                await locationFromAddress(address);
                            if (locations.isNotEmpty) {
                              setState(() {
                                latitude = locations.first.latitude;
                                longitude = locations.first.longitude;
                                _address.text = address;
                              });
                            }
                          },
                        ),
                      );
                    },
                    readOnly: true,
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
                      suffixIcon: Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 25,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Center(
                          child: Image.asset(
                            AssetsPath.loc,
                            width: 48.0,
                            height: 38.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.name,
                    controller: _address,
                    validator: (value) {
                      return bookingControllerProvider
                          .validateBlankField(value!);
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
                            return DropdownButtonFormField<int>(
                              style: AppTextStyle.textBoxInputStyle,
                              hint: const Text(""),
                              isExpanded: true,
                              value: bookingProvider.selectedSalutationId,
                              items: _salutationsData?.items!
                                  .map((salutationData) {
                                return DropdownMenuItem<int>(
                                  value: salutationData.id,
                                  child:
                                      Text(salutationData.salutationList ?? ''),
                                );
                              }).toList(),
                              onChanged: (newSalutationId) async {
                                bookingProvider
                                    .setSelectedSalutationId(newSalutationId);
                                _salutationId.text = newSalutationId.toString();
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppColors.dropdownBorderColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppColors.dropdownBorderColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    width: 1.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      const SizedBox(
                        width: 3,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _fullName,
                          keyboardType: TextInputType.name,
                          // validator: (value) {
                          //   return bookingControllerProvider.validateName(value!);
                          // },

                          style: AppTextStyle.textBoxInputStyle,
                          decoration: InputDecoration(
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
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
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
                    // validator: (value) {
                    //   return authenticationProvider.emailValidate(value!);
                    // },
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
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                            text: Labels.serviceType,
                            style: AppTextStyle.continueWith,
                            children: [
                              TextSpan(
                                text: " *",
                                style: AppTextStyle.extraLabelTextColor,
                              )
                            ]),
                      ),
                    ),
                  ),
                  if (_isFetchingDataForLoader)
                    const CircularProgressIndicator()
                  else
                    Consumer<BookingControllerProvider>(
                        builder: (context, bookingProvider, _) {
                      return DropdownButtonFormField<int>(
                        validator: (value) {
                          if (value == null) {
                            return 'Select service type';
                          }
                          return null; // No error message if a value is selected
                        },
                        style: AppTextStyle.textBoxInputStyle,
                        hint: const Text("Select service type: "),
                        isExpanded: true,
                        value: bookingProvider.selectedTaskTypeId,
                        items: _serviceTypeData?.items!.map((taskType) {
                          return DropdownMenuItem<int>(
                            value: taskType.id,
                            child: Text(taskType.taskName ?? ''),
                          );
                        }).toList(),
                        onChanged: (newTaskTypeId) async {
                          bookingProvider.setSelectedTaskTypeId(newTaskTypeId);
                          _taskTypeId.text = newTaskTypeId.toString();
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.dropdownBorderColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.dropdownBorderColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              width: 1.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    }),
                  const SizedBox(
                    height: 5,
                  ),
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

                  //show product list
                  // label here
                  const DropdownLabel(
                    text: Labels.productType,
                  ),
                  if (_isFetchingDataForLoader)
                    const CircularProgressIndicator()
                  else
                    Consumer<BookingControllerProvider>(
                        builder: (context, bookingProvider, _) {
                      return DropdownButtonFormField<int>(
                        validator: (value) {
                          if (value == null) {
                            return 'Select product type';
                          }
                          return null; // No error message if a value is selected
                        },
                        style: AppTextStyle.textBoxInputStyle,
                        hint: const Text("Select product type: "),
                        isExpanded: true,
                        value: bookingProvider.selectedProductTypeId,
                        items: _productTypeData?.items!.map((productType) {
                          return DropdownMenuItem<int>(
                            value: productType.id,
                            child: Text(productType.productList ?? ''),
                          );
                        }).toList(),
                        onChanged: (newProductTypeId) async {
                          bookingProvider
                              .setSelectedProductTypeId(newProductTypeId);
                          _productTypeId.text = newProductTypeId.toString();
                          await _fetchSubProductTypeData(
                              _productTypeId.text); // Fetch sub-product types
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.dropdownBorderColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.dropdownBorderColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              width: 1.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    }),

                  const SizedBox(
                    height: 5,
                  ),
                  //show product list start

                  if (_subProductTypeData != null &&
                      _subProductTypeData!.items != null)
                    const DropdownLabel(
                      text: Labels.subProductType,
                    ),
                  if (_subProductTypeData != null &&
                      _subProductTypeData!.items != null)
                    SizedBox(
                      height: 65,
                      child: MultiSelectDropdown(
                        textStyle: AppTextStyle.textBoxInputStyle,
                        listTextStyle: AppTextStyle.textBoxInputStyle,
                        list: _subProductTypeData!.items!.map((subProductType) {
                          return {
                            'id': subProductType.id.toString(),
                            'label': subProductType.subProductList ?? ''
                          };
                        }).toList(),
                        initiallySelected: const [],
                        onChange: (newList) {
                          setState(() {
                            _selectedSubProductIds = newList
                                .map((item) => int.parse(item['id']))
                                .toList();
                          });
                        },
                        numberOfItemsLabelToShow: 2,
                        whenEmpty: 'Choose from the list',
                      ),
                    ),

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
                      return bookingControllerProvider
                          .validateBlankField(value!);
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

                  const DropdownLabel(
                    text: Labels.paymentMode,
                  ),
                  if (_isFetchingDataForLoader)
                    const CircularProgressIndicator()
                  else
                    Consumer<BookingControllerProvider>(
                        builder: (context, bookingProvider, _) {
                      return DropdownButtonFormField<int>(
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a payment mode';
                          }
                          return null; // No error message if a value is selected
                        },
                        style: AppTextStyle.textBoxInputStyle,
                        hint: const Text("select a payment mode"),
                        isExpanded: true,
                        value: bookingProvider.selectedPaymentModeId,
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.dropdownBorderColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.dropdownBorderColor,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              width: 1.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    }),
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
                    height: 10,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //upload image
                      GestureDetector(
                        onTap: () async {
                          // Navigate to FormGalleryView and wait for the result
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageGalleryView(
                                initialImagePaths: selectedImagePaths,
                              ),
                            ),
                          );

                          // Check if the result is not null and update the state if needed
                          if (result != null) {
                            setState(() {
                              // selectedImagePaths = result['selectedImagePaths'];
                              selectedImagePaths = List<String>.from(
                                  result['selectedImagePaths']);
                            });
                          }
                        },
                        child: Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(
                                8.0,
                              ),
                              child: Column(
                                children: [
                                  Image.asset(
                                    AssetsPath.gallery,
                                    height: 60,
                                    width: 80,
                                  ),
                                  Text(
                                    'Add Image',
                                    style: AppTextStyle.continueWith,
                                  ),
                                ],
                              ),
                            )),
                      ),
                      //upload video

                      GestureDetector(
                        onTap: () async {
                          // Navigate to VideoGalleryView and wait for the result
                          final resultVideo = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoGalleryView(
                                  initialVideoPaths: selectedVideoPaths),
                            ),
                          );

                          // Check if the result is not null and update the state if needed
                          if (resultVideo != null) {
                            setState(() {
                              selectedVideoPaths = List<String>.from(
                                  resultVideo['selectedVideoPaths']);
                            });
                          }
                        },
                        child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  AssetsPath.gallery,
                                  height: 60,
                                  width: 80,
                                ),
                                Text('Add Video',
                                    style: AppTextStyle.continueWith),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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
                      text: Labels.bookService.toUpperCase(),
                      ontap:
                          isBooking // Disable the button if booking is in progress
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      isBooking = true; // Start booking process
                                    });

                                    try {
                                      int? nearestServiceCenterId =
                                          await fetchNearestServiceCenter();
                                      if (nearestServiceCenterId != null) {
                                        await book.newBooking(
                                          address: _address.text.trim(),

                                          fullName: _fullName.text.trim(),
                                          email: _email.text.trim(),
                                          phone: _phone.text.trim(),
                                          dateAndTimeOfBooking:
                                              _dateAndTimeOfBooking.text,
                                          tasktypeid: _taskTypeId.text.trim(),
                                          // typeOfMeasurement: _typeOfMeasurement.text.trim(),
                                          typeOfMaterial:
                                              _typeOfMaterial.text.trim(),
                                          paymentModeId:
                                              _paymentModeId.text.trim(),
                                          remarks: _remarks.text.trim(),
                                          notes: _notes.text.trim(),
                                          nearestServiceCenterId:
                                              nearestServiceCenterId.toString(),
                                          landmark: _landmark.text.trim(),
                                          quantity: _quantity.text.trim(),
                                          formFileImages: selectedImagePaths
                                              .map((path) => File(path))
                                              .toList(),
                                          salutation_id:
                                              _salutationId.text.trim(),
                                          productTypeId:
                                              _productTypeId.text.trim(),
                                          subProductIds: _selectedSubProductIds,
                                          formFileVideos: selectedVideoPaths
                                              .map((path) => File(path))
                                              .toList(),

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
                                            _salutationId.clear();
                                            _productTypeId.clear();
                                          },
                                        );
                                      }

                                      // ignore: use_build_context_synchronously
                                      PageNavigator(ctx: context)
                                          .nextPageOnly(page: const HomeView());
                                    } catch (e) {
                                      AppErrorSnackBar(context).error(e);
                                    } finally {
                                      setState(() {
                                        isBooking =
                                            false; // End booking process
                                      });
                                    }
                                  }
                                },

                      context: context,
                      // status: book.isLoading,
                      status: isBooking,
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:provider/provider.dart';
import 'package:theinstallers/controller/agent_controller_provider.dart';
import 'package:theinstallers/model/status_model.dart';
import 'package:theinstallers/model/yes_no_model.dart';
import 'package:theinstallers/views/agent/agent_home_view.dart';
import 'package:intl/intl.dart';
import '../../controller/authControllerProvider/auth_controller_provider.dart';
import '../../controller/booking_controller_provider.dart';
import '../../utils/exports.dart';
import '../../widgets/custom_label.dart';
import 'photo_editor/form_gallery_view.dart';
import 'dart:io';

import 'photo_editor/site_gallery_view.dart';



class ServiceUpdatedByAgentView extends StatefulWidget {
  int? id;
 String? serviceAmount;
 int? paymentMode;

 ServiceUpdatedByAgentView({super.key, this.id, this.serviceAmount, 
 this.paymentMode,

 });

  @override
  State<ServiceUpdatedByAgentView> createState() => _ServiceUpdatedByAgentViewState();
}

class _ServiceUpdatedByAgentViewState extends State<ServiceUpdatedByAgentView> {
  final _formKey = GlobalKey<FormState>();
  final authenticationProvider = AuthenticationControllerProvider();
  final bookingControllerProvider = BookingControllerProvider();
  final agentControllerProvider = AgentControllerProvider();
  final TextEditingController _statusId = TextEditingController();
  final TextEditingController _serviceAmount = TextEditingController();
  final TextEditingController _yesNoId = TextEditingController();
  final TextEditingController _remarks = TextEditingController();
  
  final TextEditingController _reason = TextEditingController();
  YesNoModel? _yesNoData;
  StatusModel? _statusData;
  bool _isDataFetched = false;
  bool _isFetchingDataForLoader = false;
  
   List<String> selectedImagePaths = [];
   List<String> imageCaptions = [];
   List<String> selectedSiteImagePaths = [];
   List<String> siteCaptions = [];

  
  @override
  void initState() {
    print("Task id: ${widget.id.toString()}");
    print("Service amount: ${widget.serviceAmount.toString()}");
    print("Payment mode: ${widget.paymentMode.toString()}");
    super.initState();
    setState(() {
      _serviceAmount.text = widget.serviceAmount.toString();
   
      
    });
  }


  @override
  void dispose() {
    super.dispose();
    _remarks.dispose();
    _statusId.dispose();
    _serviceAmount.dispose();
    _yesNoId.dispose();
    _reason.dispose();
    
    
  }
bool isBooking = false; 

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch data only if it hasn't been fetched yet
    if (!_isDataFetched) {
      _fetchYesNoData();
      _fetchStatusData();
      _isDataFetched = true;
    }
  }

  Future<void> _fetchYesNoData() async {
    setState(() {
      _isFetchingDataForLoader = true; // Set to true when starting data fetching
    });
    _yesNoData = await agentControllerProvider.fetchYesNo();
     setState(() {
      _isFetchingDataForLoader = false; // Set to false when data fetching is complete
    });
  }

  Future<void> _fetchStatusData() async {
    setState(() {
      _isFetchingDataForLoader = true; // Set to true when starting data fetching
    });
    _statusData = await agentControllerProvider.fetchStatus();
     setState(() {
      _isFetchingDataForLoader = false; // Set to false when data fetching is complete
    });
  }

  @override
  Widget build(BuildContext context) {
final agentProvider = Provider.of<AgentControllerProvider>(context);   


    return Scaffold(
    
        appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          Labels.serviceUpdate,
          style: AppTextStyle.ongoingBooking,
        ),
        centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      ),
      body:  WillPopScope(
         onWillPop: () async {
          // Reset selectedPaymentModeId to null when back button is pressed
          agentProvider.setSelectedYesNoId(null);
          agentProvider.setSelectedStatusId(null);
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       GestureDetector(
  onTap: () async {
    // Navigate to FormGalleryView and wait for the result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormGalleryView(
          initialImagePaths: selectedImagePaths,
          initialImageCaptions: imageCaptions,
        ),
      ),
    );

    // Check if the result is not null and update the state if needed
    if (result != null) {
      setState(() {
        selectedImagePaths = List<String>.from(result['selectedImagePaths']);
        imageCaptions = List<String>.from(result['imageCaptions']);
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
          Text('Add Form', style: AppTextStyle.continueWith),
        ],
      ),
    ),
  ),
),

        
                               GestureDetector(
  onTap: () async {
    final resultSite = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SiteGalleryView(
          initialSiteImagePaths: selectedSiteImagePaths,
          initialSiteCaptions: siteCaptions,
        ),
      ),
    );

    if (resultSite != null) {
      setState(() {
        selectedSiteImagePaths = List<String>.from(resultSite['selectedSiteImagePaths']);
        siteCaptions = List<String>.from(resultSite['siteCaptions']);
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
          Text('Add Site', style: AppTextStyle.continueWith),
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
        
                  AppTextFormField(
                    labelText: Labels.remarks,
                    controller: _remarks,
                    hintText: Labels.typeHere,
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                  ),
        
                  Visibility(
                     visible: widget.paymentMode == 1 ? true : false,
                      child: const SizedBox(
                        height: 5,
                      ),
                    ),     
                  Visibility(
                     visible: widget.paymentMode == 1 ? true : false,
                    child: AppTextFormField(
                       labelText: 'Service Charge',
                      readOnly: true,
                      controller: _serviceAmount,
                      
                    ),
                  ),
        
                  
                    Visibility(
                     visible: widget.paymentMode == 1 ? true : false,
                     child: const Padding(
                      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: CustomLabel(text: Labels.selectYesNo)),
                                   ),
                   ),
                   if (_isFetchingDataForLoader)
                  const CircularProgressIndicator()
                  else
                  Consumer<AgentControllerProvider>(
                      builder: (context, agentProvider, _) {
                      return Visibility(
                     visible: widget.paymentMode == 1 ? true : false,
                            child: DropdownButtonFormField<int>(
                               validator: (value) {
                                if (value == null) {
                                  return 'Please select yes/no';
                                }
                                return null; // No error message if a value is selected
                              },
                             style: AppTextStyle.textBoxInputStyle,
                              hint: const Text("Choose Yes/No: "),
                              isExpanded: true,
                              value: agentProvider.selectedYesNoId,
                              items: _yesNoData?.items!.map((yesNo) {
                                return DropdownMenuItem<int>(
                                  value: yesNo.id,
                                  child: Text(yesNo.yesNoList ?? ''),
                                );
                              }).toList(),
                              onChanged: (newYesNoId) async {
                                agentProvider
                                    .setSelectedYesNoId(newYesNoId);
                                _yesNoId.text = newYesNoId.toString();
                              },
                            decoration:  InputDecoration(
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
        
                            ),
                          );
                  }),
        
                
                   const Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: CustomLabel(text: Labels.selectStatus)),
                  ),
                  if (_isFetchingDataForLoader)
                  const CircularProgressIndicator()
                  else
                  Consumer<AgentControllerProvider>(
                      builder: (context, agentProvider, _) {
                    return DropdownButtonFormField<int>(
                          validator: (value) {
                            if (value == null) {
                              return 'Please select status';
                            }
                            return null; // No error message if a value is selected
                          },
                           style: AppTextStyle.textBoxInputStyle,
                           hint: const Text("Choose status: "),
                           isExpanded: true,
                           value: agentProvider.selectedStatusId,
                           items: _statusData?.items!.map((status) {
                             return DropdownMenuItem<int>(
                               value: status.id,
                               child: Text(status.statusList ?? ''),
                             );
                           }).toList(),
                           onChanged: (newStatusId) async {
                             agentProvider
                                 .setSelectedStatusId(newStatusId);
                             _statusId.text = newStatusId.toString();
                           },
                            decoration:  InputDecoration(
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

                

                      Visibility(
                     visible: agentProvider.selectedStatusId == 5 ? true : false,
                      child: const SizedBox(
                        height: 5,
                      ),
                    ),     
        
                  Visibility(
                    visible: agentProvider.selectedStatusId == 5 ? true : false,
                    child: AppTextFormField(
                      labelText: Labels.reason,
                      extraLabelText: " *",
                      controller: _reason,
                      hintText: Labels.typeHere,
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                    ),
                  ),
        
                  const SizedBox(
                    height: 5,
                  ),
                  
                  Consumer<AgentControllerProvider>(
                  builder: (context, agentBook, child) {
                         WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (agentBook.responseMessage != '') {
                              showMessage(
                                  message: agentBook.responseMessage, context: context);
                              agentBook.clear();
                            }
                          });
        
                          String? serviceCharges;
                          if (widget.paymentMode == 1) {
                            serviceCharges = _serviceAmount.text.trim();
                          }
            
                    return customButton(
                      text: Labels.updateService.toUpperCase(),
                        ontap: isBooking // Disable the button if booking is in progress
                            ? null
                            : 
                         () async {
                        if (_formKey.currentState!.validate()) {
                           setState(() {
                                    isBooking = true; // Start booking process
                                  });
            
                            try {
                            await  agentBook.updateServiceByAgent(
                            id: widget.id!.toInt(),
                           
                            formFileImages: selectedImagePaths.map((path) => File(path)).toList(),
                            imageCaptions: imageCaptions,
                            formFileSiteImages: selectedSiteImagePaths.map((path) => File(path)).toList(),
                            siteCaptions: siteCaptions,
                            remarks: _remarks.text.trim(), 
                            status: _statusId.text.trim(),
                            yeNoId: _yesNoId.text.trim(),
                            serviceCharge: serviceCharges,
                            reason: _reason.text.trim(), 
                            
                                onSuccess: () {
                                // Clear the text form field values here
                                _remarks.clear();
                                _statusId.clear();
                                _yesNoId.clear();
                                _serviceAmount.clear();
                                _reason.clear();
                              },
                           
                            );
        
                              // ignore: use_build_context_synchronously
                              PageNavigator(ctx: context)
                                .nextPageOnly(page: const AgentHomeView());
                            
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
                    // status: agentBook.isLoading,
                    status: isBooking,
                
                    );
                  }
                ),   
                
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


 




}
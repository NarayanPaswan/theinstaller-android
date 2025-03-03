import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:theinstallers/controller/homeControllerProvider.dart';
import 'package:theinstallers/views/authentication/login_view.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../controller/authControllerProvider/auth_controller_provider.dart';
import '../../model/service_centre_model.dart';
import '../../notificationservice/local_notification_service.dart';
import '../../utils/exports.dart';
import '../../widgets/custom_label.dart';


class AgentRegisterView extends StatefulWidget {
  const AgentRegisterView({super.key});

  @override
  State<AgentRegisterView> createState() => _AgentRegisterViewState();
}

class _AgentRegisterViewState extends State<AgentRegisterView> {
  LocalNotificationService localNotificationService = LocalNotificationService();
  final _formKey = GlobalKey<FormState>();
  final authenticationProvider = AuthenticationControllerProvider();
   final TextEditingController _name = TextEditingController();
   final TextEditingController _mobileNo = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _aadhaarCard = TextEditingController();
  final TextEditingController _drivingLicense = TextEditingController();
  final TextEditingController _nearestService = TextEditingController();
  String deviceTokenToSendPushNotification = "";
  final TextEditingController _aadhaarCardBack = TextEditingController();
  final TextEditingController _serviceCenter = TextEditingController();
  
  File? _imageAadhaarFile;
  final _picker = ImagePicker();

  Future<void> getAadhaarImage() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    AndroidDeviceInfo android = await plugin.androidInfo;
    if (android.version.sdkInt < 33) {
      var status = await Permission.storage.status;

      if (status.isGranted) {
        try {
          final pickedFile = await _picker.pickImage(
              source: ImageSource.gallery, imageQuality: 80);
          if (pickedFile != null) {
            setState(() {
              _imageAadhaarFile = File(pickedFile.path);
              print('Your aadhaar path is: $_imageAadhaarFile');
              _aadhaarCard.text = pickedFile.path.split('/').last;
            });
          }
        } catch (e) {
          print('Exception occurred: $e');
        }
      } else {
        // If permission is not granted, request it
        await Permission.storage.request();

        // Check the permission status again
        status = await Permission.storage.status;

        if (status.isGranted) {
          // Permission granted, try picking the image again
          await getAadhaarImage();
        } else {
          // Permission still not granted, show an alert
          showAlertDialog(context);
        }
      }
    } else {
      var status = await Permission.photos.status;

      if (status.isGranted) {
        try {
          final pickedFile = await _picker.pickImage(
              source: ImageSource.gallery, imageQuality: 80);
          if (pickedFile != null) {
            setState(() {
              _imageAadhaarFile = File(pickedFile.path);
              print('Your aadhaar path is: $_imageAadhaarFile');
              _aadhaarCard.text = pickedFile.path.split('/').last;
            });
          }
        } catch (e) {
          print('Exception occurred: $e');
        }
      } else {
        // If permission is not granted, request it
        await Permission.photos.request();

        // Check the permission status again
        status = await Permission.photos.status;

        if (status.isGranted) {
          // Permission granted, try picking the image again
          await getAadhaarImage();
        } else {
          // Permission still not granted, show an alert
          showAlertDialog(context);
        }
      }
    }
  }
  

//   Future<void> getAadhaarImage() async {
//   var status = await Permission.storage.status;

//   if (status.isGranted) {
//     try {
//       final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
//       if (pickedFile != null) {
//         setState(() {
//           _imageAadhaarFile = File(pickedFile.path);
//           print('Your aadhaar path is: $_imageAadhaarFile');
//           _aadhaarCard.text = pickedFile.path.split('/').last;
//         });
//       }
//     } catch (e) {
//       print('Exception occurred: $e');
//     }
//   } else {
//     // If permission is not granted, request it
//     await Permission.storage.request();
    
//     // Check the permission status again
//     status = await Permission.storage.status;

//     if (status.isGranted) {
//       // Permission granted, try picking the image again
//       await getAadhaarImage();
//     } else {
//       // Permission still not granted, show an alert
//       showAlertDialog(context);
//     }
//   }
// }




  showAlertDialog(context) => showCupertinoDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Permission Denied'),
        content: const Text('Allow access to gallery and photos'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => openAppSettings(),
            child: const Text('Settings'),
          ),
        ],
      ),
    );

 File? _imageAadhaarBackFile;
  final _pickerAadhaarBack = ImagePicker();

  Future getAadhaarBackFile()async{
    final pickedAadhaarBackFile = await _pickerAadhaarBack.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if(pickedAadhaarBackFile != null){
      setState(() {
        _imageAadhaarBackFile = File(pickedAadhaarBackFile.path);
        print('your AadhaarBack path is: $_imageAadhaarBackFile');
        _aadhaarCardBack.text = pickedAadhaarBackFile.path.split('/').last; 
      });
    }
  }

  File? _imagePanCardFile;
  final _pickerPanCard = ImagePicker();

  Future getDrivingFile()async{
    final pickedPanCardFile = await _pickerPanCard.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if(pickedPanCardFile != null){
      setState(() {
        _imagePanCardFile = File(pickedPanCardFile.path);
        print('your driving path is: $_imagePanCardFile');
        _drivingLicense.text = pickedPanCardFile.path.split('/').last; 
      });
    }
  }

  
  
  @override
  void dispose() {
    _name.dispose();
    _mobileNo.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _aadhaarCard.dispose();
    _drivingLicense.dispose();
    _serviceCenter.dispose();
    super.dispose();
  }

  @override
  void initState() {
    authenticationProvider.fetchUsertype();
      localNotificationService.getDeviceTokenToSendNotification().then((value){
      	deviceTokenToSendPushNotification = value.toString();
        // print("Token Value $deviceTokenToSendPushNotification");
    });
    super.initState();
  }

    // regular expression to check if string
  RegExp pass_valid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
  //A function that validate user entered password
  bool validatePassword(String pass){
    String _password = pass.trim();
    if(pass_valid.hasMatch(_password)){
      return true;
    }else{
      return false;
    }
  }

 
  @override
  Widget build(BuildContext context) {
    //  final authentication =
    //     Provider.of<AuthenticationControllerProvider>(context);

    //   if (authentication.nearestPlace != null) {
    //    _nearestService.text = authentication.nearestPlace.toString();
       
    //   } 
      final authProviderVisible =
        Provider.of<AuthenticationControllerProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  const SizedBox(height: 10,),
                
                const Image(
                    height: 160.0,
                    width: 160.0,
                    fit: BoxFit.cover,
                    image: AssetImage(AssetsPath.splashLogo),
                  ),
          
                    Text(
                    Labels.register,
                    style: AppTextStyle.signIn,
                  ),

                  const SizedBox(height: 10,),
                 

              AppTextFormField(
                labelText: "Name",
                extraLabelText: " *",
                controller: _name,
                hintText: Labels.name,
                keyboardType: TextInputType.name,
                 validator: (value) {
                            return authenticationProvider.validateBlankField(value!);
                          },  
              ), 
               const SizedBox(
                  height: 5,
                ),
                AppTextFormField(
                labelText: "Your Mobile No",
                extraLabelText: " *",
                controller: _mobileNo,
                hintText: Labels.mobileNo,
                keyboardType: TextInputType.number,
                validator: (value) {
                      return authenticationProvider.mobileNumberValidator(value!);
                    },
              ),    
           const SizedBox(
                  height: 5,
                ),
                  Consumer<AuthenticationControllerProvider>(
              builder: (context, auth, child) {
              return AppTextFormField(
               labelText: "Password ",   
               extraLabelText: " *",  
              controller: _password,
              hintText: Labels.password,
            
              suffixIcon: auth.obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
              suffixIconOnPressed: () {
                    auth.obscurePassword =
                        !auth.obscurePassword;
                  },
               obscureText: auth.obscurePassword,
                 onChanged: (newPasswordValue) {
                      auth.passwordValue = newPasswordValue;
                    },
                     validator: (value){
                      if(value!.isEmpty){
                        return "Please enter password";
                      }else{
                       //call function to check password
                        bool result = validatePassword(value);
                        if(result){
                          // create account event
                         return null;
                        }else{
                          return " Password should contain capital, small letter & number & symbol";
                        }
                      }
                  },           
              
            );
            }),
            const SizedBox(
                  height: 5,
                ),  

                  GestureDetector(
                  child: Row(
                    children: [
                     const Icon(Icons.info, color: Colors.blue), // Info icon
                      const SizedBox(width: 5), // Spacer between icon and text
                      Expanded( // Wrap the RichText with Expanded
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            text: "Create a strong password with a mixture of capital & small letters, numbers and symbols with minimum 8 characters.",
                            style: AppTextStyle.smallTextStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(
                  height: 5,
                ),
             Consumer<AuthenticationControllerProvider>(
              builder: (context, auth, child) {
              return AppTextFormField(
               labelText: "Confirm Password",   
               extraLabelText: " *",    
              controller: _confirmPassword,
              hintText: Labels.password,
              
              suffixIcon: auth.obscureConfirmPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
              suffixIconOnPressed: () {
                    auth.obscureConfirmPassword =
                        !auth.obscureConfirmPassword;
                  },
               obscureText: auth.obscureConfirmPassword,
                validator: (value) {
                    return auth.validateConfirmPassword(value!);
                  },             
             
            );
            }),

            const SizedBox(height: 5,),
                
            

           Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                      text: Labels.pickNarestServiceCenter,
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

            Consumer<AuthenticationControllerProvider>(
              builder: (context, authProvider, _) {
                return FutureBuilder<ServiceCentreModel?>(
                  future: authProvider.fetchServiceCentre(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return const Text('No data available');
                    } else {
                      final serviceCentreList = snapshot.data!.items;

                      return DropdownButtonFormField<int>(
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a service center';
                          }
                          return null; // No error message if a value is selected
                        },
                        style: AppTextStyle.textBoxInputStyle,
                        hint: const Text("Select Service Centre: "),
                        isExpanded: true,
                        value: authProvider.selectedServiceCentreListId,
                        items: serviceCentreList!.map((serviceCentreListData) {
                          return DropdownMenuItem<int>(
                            value: serviceCentreListData.id,
                            child: Text(serviceCentreListData.place ?? ''),
                          );
                        }).toList(),
                        onChanged: (newServiceCentreListId) async {
                          authProvider.setSelectedServiceCentreListId(newServiceCentreListId);
                          _serviceCenter.text = newServiceCentreListId.toString();
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
                    }
                  },
                );
              },
            ),

              const SizedBox(height: 5,),
             
                AppTextFormField(
                onTap: () {
                  getAadhaarImage();
                 
                },  
                
                labelText: Labels.aadhaarCardFront,
                extraLabelText: " *",
                controller: _aadhaarCard,
                hintText: Labels.aadhaarCard,
                keyboardType: TextInputType.none,
                prefixIcon: Icons.image,
                validator: (value) {
                      return authenticationProvider.validateBlankField(value!);
                    },  
                readOnly: true,
              ),

              const SizedBox(height: 5,),
             
                AppTextFormField(
                onTap: () {
                  getAadhaarBackFile();
                },  
                labelText: Labels.aadhaarCardBack,
                controller: _aadhaarCardBack,
                hintText: Labels.aadhaarCardBack,
                keyboardType: TextInputType.none,
                prefixIcon: Icons.image,
                readOnly: true,
              ),

              const SizedBox(height: 5,),
             
                AppTextFormField(
                onTap: () {
                  getDrivingFile();
                },  
                labelText: "Pan Card",
                controller: _drivingLicense,
                hintText: Labels.drivingLicense,
                keyboardType: TextInputType.none,
                prefixIcon: Icons.image,
                readOnly: true,
              ),
              
               

                
            const SizedBox(
                  height: 25,
                ),  

            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "By signing up you agree to ",
                style: AppTextStyle.smallTextStyle,
                children: [
                  TextSpan(
                    text: "term and conditions ",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xff003DFC)),
                         recognizer: TapGestureRecognizer()
                          ..onTap = () async{
                               String websitelink = 'https://theinstallers.in/terms-and-condition/';
                            if (await canLaunchUrlString(websitelink)) {
                              launchUrlString(websitelink, mode: LaunchMode.inAppWebView);
                            } 
                          },
                  ),
                   const TextSpan(
                    text: "at the installers.",
                    
                  )
                ]
                ),
            ),  
              
               

              
                Consumer<AuthenticationControllerProvider>(
                builder: (context, auth, child) {
                       WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (auth.responseMessage != '') {
                            showMessage(
                                message: auth.responseMessage, context: context);
                            auth.clear();
                          }
                        });
          
                  return customButton(
                    text: Labels.register.toUpperCase(),
                       ontap: () async {
                      if (_formKey.currentState!.validate()) {
          
                          try {
                          await  auth.agentRegister(
                          name: _name.text.trim(),
                          mobile: _mobileNo.text.trim(), 
                          password: _password.text.trim(),
                          confirmPassword: _confirmPassword.text.trim(),
                          aadhaarCard: _imageAadhaarFile,
                          aadhaarCardBack: _imageAadhaarBackFile,
                          
                          drivingLicense: _imagePanCardFile,
                          // nearestPlaceId: auth.nearestId,
                           nearestPlaceId: int.tryParse(_serviceCenter.text),
                          deviceToken: deviceTokenToSendPushNotification
                          );
                           // ignore: use_build_context_synchronously
                           PageNavigator(ctx: context).nextPageOnly(page: const LoginView());
                          } catch (e) {
                            AppErrorSnackBar(context).error(e);
                          }
          
          
                      }
                    },
              
                  context: context,
                  status: auth.isLoading,
              
                  );
                }
              ),
              
                
               
                GestureDetector(
                  onTap: (){
                       PageNavigator(ctx: context).nextPageOnly(
                        page: const LoginView(),
                     );
                  },
                  child:  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: Labels.alreadyHaveAccount,
                       style: AppTextStyle.smallTextStyle.copyWith(
                          decoration: TextDecoration.underline,

                        ),
                       
                        ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
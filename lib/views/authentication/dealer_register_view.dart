import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:theinstallers/views/authentication/login_view.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../controller/authControllerProvider/auth_controller_provider.dart';
import '../../controller/booking_controller_provider.dart';
import '../../model/service_centre_model.dart';
import '../../notificationservice/local_notification_service.dart';
import '../../utils/exports.dart';



class DealerRegisterView extends StatefulWidget {
  const DealerRegisterView({super.key});

  @override
  State<DealerRegisterView> createState() => _DealerRegisterViewState();
  
}

class _DealerRegisterViewState extends State<DealerRegisterView> {
  LocalNotificationService localNotificationService = LocalNotificationService();
  String deviceTokenToSendPushNotification = "";
  final _formKey = GlobalKey<FormState>();
  final authenticationProvider = AuthenticationControllerProvider();
  final bookingControllerProvider = BookingControllerProvider();
   final TextEditingController _companyName = TextEditingController();
   final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _nearestService = TextEditingController();
  final TextEditingController _serviceCenter = TextEditingController();
  @override
  void dispose() {
    _companyName.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _phone.dispose();
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
    //  authenticationProvider.setSelectedServiceCentreListId(null);
    //  _serviceCenter.text = ''; 
    //   print("Service Center Text Cleared: ${_serviceCenter.text}");
 
     
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
    // final auth =
    //     Provider.of<AuthenticationControllerProvider>(context);

    //   if (auth.nearestPlace != null) {
    //    _nearestService.text = auth.nearestPlace.toString();
       
    //   } 
     
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
                  // const SizedBox(height: 40,),
                
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

                  // const SizedBox(height: 5,),
                  // Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Text(
                  //       Labels.continueWith,
                  //       style: AppTextStyle.continueWith,
                  //     )),
                  // const SizedBox(
                  //   height: 5,
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     InkWell(
                  //       onTap: () {},
                  //       child: const Image(
                  //         height: 56.0,
                  //         width: 99.0,
                  //         fit: BoxFit.cover,
                  //         image: AssetImage(AssetsPath.facbookIcon),
                  //       ),
                  //     ),
                  //     InkWell(
                  //       onTap: () {},
                  //       child: const Image(
                  //         height: 56.0,
                  //         width: 99.0,
                  //         fit: BoxFit.cover,
                  //         image: AssetImage(AssetsPath.googleIcon),
                  //       ),
                  //     ),
                  //     InkWell(
                  //       onTap: () {},
                  //       child: const Image(
                  //         height: 56.0,
                  //         width: 99.0,
                  //         fit: BoxFit.cover,
                  //         image: AssetImage(AssetsPath.appleIcon),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 5,),
                  // Row(children: [
                  //   Expanded(
                  //     child: Container(
                  //       height: 1,
                        
                  //       color: AppColors.lineColor,
                  //     ),
                  //   ),
                  // Text("Or", style: TextStyle(color: AppColors.lineColor),),
                  // Expanded(
                  //   child: Container(
                  //       height: 1,
                        
                  //       color: AppColors.lineColor,
                  //     ),
                  // ),
                  // ],),
              //     Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
                  
              //   children: [
              //    Container(
              //     width: 10,
              //     height: 10,
              //     decoration: const BoxDecoration(
              //       shape: BoxShape.circle,
              //       color: Colors.black,
              //     ),
              //   ),
              //  const SizedBox(width: 3,),
              //   Container(
              //     width: 10,
              //     height: 10,
              //     decoration: const BoxDecoration(
              //       shape: BoxShape.circle,
              //       color: Colors.black,
              //     ),
              //   ),
              // const SizedBox(width: 3,),
              //   Container(
              //     width: 10,
              //     height: 10,
              //     decoration: const BoxDecoration(
              //       shape: BoxShape.circle,
              //       color: Colors.black,
              //     ),
              //   ),
              //     ],
              //     ),

              AppTextFormField(
                labelText: "Company Name",
                extraLabelText: " *",
                controller: _companyName,
                hintText: Labels.companyName,
                keyboardType: TextInputType.name,
                 validator: (value) {
                    return bookingControllerProvider.validateBlankField(value!);
                  },
              ), 
               const SizedBox(
                  height: 5,
                ),
                AppTextFormField(
                labelText: "Your E mail",
                extraLabelText: " *",
                controller: _email,
                hintText: Labels.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                      return authenticationProvider.emailValidate(value!);
                    },
              ),    
           const SizedBox(
                  height: 5,
                ),
              Consumer<AuthenticationControllerProvider>(
              builder: (context, auth, child) {
              return AppTextFormField(
                onTap: (){
                  
                },
               labelText: "Password",   
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
                            value: serviceCentreListData.id ,
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

            /*
              AppTextFormField(
                      onTap: (){
                        auth.getLatLong();
                      },
                        labelText: Labels.pickNarestServiceCenter,
                         extraLabelText: " *",
                        hintText: Labels.pickNarestServiceCenter,
                        controller: _nearestService,
                        keyboardType: TextInputType.none,
                        prefixIcon: Icons.location_on,
                        readOnly: true,
                        validator: (value) {
                            return authenticationProvider.validateBlankField(value!);
                          },  
                         ),
                    */     

            const SizedBox(
                  height: 5,
                ),  

            GestureDetector(
                  // onTap: (){
                  //      PageNavigator(ctx: context).nextPageOnly(
                  //       page: const LoginView(),
                  //    );
                  // },
                  child: RichText(
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
                         const  TextSpan(
                          text: "at the installers.",
                          
                        )
                      ]
                      ),
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
                          await  auth.dealerRegister(
                          companyName: _companyName.text.trim(),
                          email: _email.text.trim(), 
                          password: _password.text.trim(),
                          confirmPassword: _confirmPassword.text.trim(),
                          deviceToken: deviceTokenToSendPushNotification,
                          // nearestPlaceId: auth.nearestId,
                          nearestPlaceId: _serviceCenter.text.trim(),
                          
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
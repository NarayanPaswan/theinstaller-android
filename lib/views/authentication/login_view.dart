import 'package:provider/provider.dart';
import 'package:theinstallers/views/agent/agent_home_view.dart';
import 'package:theinstallers/views/authentication/forgot_password_view.dart';
import 'package:theinstallers/views/home/home_view.dart';
import '../../controller/authControllerProvider/auth_controller_provider.dart';
import '../../notificationservice/local_notification_service.dart';
import '../../utils/exports.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'select_role_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  LocalNotificationService localNotificationService = LocalNotificationService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final authenticationProvider = AuthenticationControllerProvider();
  bool isCheckRememberMe = false;
  String deviceTokenToSendPushNotification = "";

  void rememberMe(bool? value){
    isCheckRememberMe = value!;
    SharedPreferences.getInstance().then((prefs){
      prefs.setBool("remember_me", value);
      prefs.setString("user_email", _email.text);
      prefs.setString("user_password", _password.text);
    });
    setState(() {
      isCheckRememberMe = value;
    });
  }

  @override
  void initState() {
    localNotificationService.getDeviceTokenToSendNotification().then((value){
      	deviceTokenToSendPushNotification = value.toString();
        print("Device Token Value $deviceTokenToSendPushNotification");
    });
    super.initState();
  }


  @override
  void dispose() {
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      // Retrieve the saved values from SharedPreferences

  SharedPreferences.getInstance().then((prefs) {
    setState(() {
      isCheckRememberMe = prefs.getBool("remember_me") ?? false;
      if (isCheckRememberMe) {
        _email.text = prefs.getString("user_email") ?? "";
        _password.text = prefs.getString("user_password") ?? "";
      }
    });
  });
  
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
               const SizedBox(height: 60,),
                const Image(
                  height: 160.0,
                  width: 160.0,
                  fit: BoxFit.cover,
                  image: AssetImage(AssetsPath.splashLogo),
                ),
               
                Text(
                  Labels.signIn,
                  style: AppTextStyle.signIn,
                ),
                  const SizedBox(height: 10,),
                // Align(
                //     alignment: Alignment.centerLeft,
                //     child: Text(
                //       Labels.continueWith,
                //       style: AppTextStyle.continueWith,
                //     )),
                const SizedBox(
                  height: 5,
                ),
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
                // const SizedBox(height: 10,),
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
                labelText: "Your E mail or Mobile No",
                extraLabelText: " *",
                controller: _email,
                hintText: Labels.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                      return authenticationProvider.emailOrMobileValidate(value!);
                    },
              ),
              const SizedBox(
                  height: 5,
                ),
              Consumer<AuthenticationControllerProvider>(
                builder: (context, auth, child) {
                return AppTextFormField(
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
                  validator: (value) {
                      return auth.validatePassword(value!);
                    },             
                
              );
              }),

             const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: (){
                    
                     PageNavigator(ctx: context)
                              .nextPageOnly(page: const ForgotPasswordView());
                  },
                  child: Text(Labels.forgotPassword, style:AppTextStyle.forgoPassword)), 
              
               Row(
               children: [

              //remember me  
              Checkbox(
                value: isCheckRememberMe, 
               onChanged: rememberMe,
                ),
                 Text(Labels.rememberMe,  style:AppTextStyle.forgoPassword) 
               ],
             ), 

            ],),
                
                const SizedBox(
                  height: 25,
                ),
                Consumer<AuthenticationControllerProvider>(
                    builder: (context, auth, child) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (auth.responseMessage != '') {
                      showMessage(
                          message: auth.responseMessage, context: context);
        
                      ///Clear the response message to avoid duplicate
                      auth.clear();
                    }
                  });
        
                  return customButton(
                    text: Labels.signIn.toUpperCase(),
                    ontap: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          await auth.login(
                              email: _email.text.trim(),
                              password: _password.text.trim(),
                              deviceToken: deviceTokenToSendPushNotification
                              );
                          // ignore: use_build_context_synchronously
                           
                          if (auth.newRoleId == '3') {
                           
                           
                            // Navigate to AgentHomeView
                            Future.delayed(const Duration(seconds: 1), () {
                              PageNavigator(ctx: context).nextPageOnly(page: const AgentHomeView());
                            });
                          } else {
                           
                            // Navigate to HomeView
                            PageNavigator(ctx: context).nextPageOnly(page: const HomeView());
                          }

                           
                          
                        } catch (e) {
                          AppErrorSnackBar(context).error(e);
                        }
                      }
                    },
                    context: context,
                    status: auth.isLoading,
                  );
                }),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    PageNavigator(ctx: context).nextPageOnly(
                      page: const SelectRoleView(),
                    );
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: Labels.dontHaveAccount,
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

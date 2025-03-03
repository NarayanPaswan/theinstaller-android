import 'package:provider/provider.dart';
import 'package:theinstallers/views/home/home_view.dart';
import '../../controller/authControllerProvider/auth_controller_provider.dart';
import '../../utils/exports.dart';


class DealerEmployeeRegisterView extends StatefulWidget {
  const DealerEmployeeRegisterView({super.key});

  @override
  State<DealerEmployeeRegisterView> createState() => _DealerEmployeeRegisterViewState();
}

class _DealerEmployeeRegisterViewState extends State<DealerEmployeeRegisterView> {
  final _formKey = GlobalKey<FormState>();
  final authenticationProvider = AuthenticationControllerProvider();
   final TextEditingController _name = TextEditingController();
   final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _aadhaarCard = TextEditingController();
  
  
  
  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _phone.dispose();
    _aadhaarCard.dispose();
    super.dispose();
  }

  @override
  void initState() {
    authenticationProvider.fetchUsertype();
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
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          "Create new employee",
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

                  const SizedBox(height: 5,),
               
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
                AppTextFormField(
                labelText: "Phone",
                extraLabelText: " *",
                controller: _phone,
                hintText: Labels.phone,
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

               const SizedBox(
                  height: 5,
                ),

            //  AppTextFormField(
            //     labelText: "Aadhaar Card No",
            //     extraLabelText: " *",
            //     controller: _aadhaarCard,
            //     hintText: "Aadhaar Card No",
            //     keyboardType: TextInputType.name,
            //   ), 

            // const SizedBox(
            //       height: 5,
            //     ),  

            GestureDetector(
                
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "By signing up you agree to ",
                      style: AppTextStyle.smallTextStyle,
                      children: const[
                        TextSpan(
                          text: "term and conditions ",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff003DFC)),
                        ),
                          TextSpan(
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
                          await  auth.dealerEmployeeRegister(
                          name: _name.text.trim(),
                          email: _email.text.trim(), 
                          phone: _phone.text.trim(),
                          password: _password.text.trim(),
                          confirmPassword: _confirmPassword.text.trim(),
                          aadhaarCard: _aadhaarCard.text.trim(),
                          );
                           // ignore: use_build_context_synchronously
                           PageNavigator(ctx: context).nextPageOnly(page: const HomeView());
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
                
               
               
              ],
            ),
          ),
        ),
      ),
    );
  }
}
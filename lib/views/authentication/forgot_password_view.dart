import 'package:provider/provider.dart';
import 'package:theinstallers/views/authentication/login_view.dart';

import '../../controller/authControllerProvider/auth_controller_provider.dart';
import '../../utils/exports.dart';
import '../../widgets/custom_label.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final authenticationProvider = AuthenticationControllerProvider();
  @override
  Widget build(BuildContext context) {
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
               const SizedBox(height: 120,), 
               CustomLabel(text:  Labels.resetPassword,textStyle: AppTextStyle.signIn,),
              const SizedBox(height: 10,),
              Text(Labels.toResetYourPassword, textAlign: TextAlign.center, style: AppTextStyle.toResetYourPasswordStyle,),  
               const SizedBox(height: 40,),
                const Image(
                  height: 93.0,
                  width: 118.0,
                  fit: BoxFit.cover,
                  image: AssetImage(AssetsPath.forgotPassword),
                ),
                 const SizedBox(height: 80,),
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
                    text: Labels.resetPassword.toUpperCase(),
                    ontap: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          await auth.forgotPassword(
                              email: _email.text.trim(),
                             );
                          // ignore: use_build_context_synchronously
                          PageNavigator(ctx: context)
                              .nextPageOnly(page: const LoginView());
                        } catch (e) {
                          AppErrorSnackBar(context).error(e);
                        }
                      }
                    },
                    context: context,
                    status: auth.isLoading,
                  );
                }),
                const SizedBox(height: 20,),

               InkWell(
                onTap: (){
                  PageNavigator(ctx: context)
                .nextPageOnly(page: const LoginView());
                },
                 child: Container(
                   height: 48,
                   width: MediaQuery.of(context).size.width,
                   margin: const EdgeInsets.symmetric(vertical: 15),
                   alignment: Alignment.center,
                    decoration: BoxDecoration(
                    color: const Color(0xff9E88FF),
                    
                 borderRadius: BorderRadius.circular(8)),
                 child: Text(
                  Labels.backToSignIn.toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 18),
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
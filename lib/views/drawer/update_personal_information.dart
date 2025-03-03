import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../controller/authControllerProvider/auth_controller_provider.dart';
import '../../controller/booking_controller_provider.dart';
import '../../controller/database/database_controller_provider.dart';
import '../../controller/show_user_details_controller_provider.dart';
import '../../model/user_details.dart';
import '../../utils/exports.dart';
import '../agent/agent_home_view.dart';
import '../home/home_view.dart';


class UpdatePersonalInformationView extends StatefulWidget {
  String profilePic;
  UpdatePersonalInformationView({super.key, 
  required this.profilePic,
  });
  
  @override
  State<UpdatePersonalInformationView> createState() => _UpdatePersonalInformationViewState();
}

class _UpdatePersonalInformationViewState extends State<UpdatePersonalInformationView> {
  final _formKey = GlobalKey<FormState>();
  UserDetails? showData;
  final authenticationProvider = AuthenticationControllerProvider();
  final bookingControllerProvider = BookingControllerProvider();
  final userDetailsControllerProvider = UserDetailsControllerProvider();
  
  
  
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _password = TextEditingController();
   String roleId = '';
    bool _isLoading = true;
    
  @override
  void initState() {
    super.initState();
     _fetchData();
     _fetchRoleId();
    // print("Your profile pic url ${widget.profilePic}");
    // setState(() {
    //  userDetailsControllerProvider.UserDetailsShow().then((data) {

    //   showData = data;
    //   _fullName.text = showData?.name?.toString() ?? '';
    //   _address.text = showData?.address?.toString() ?? '';
    //   _email.text = showData?.email?.toString() ?? '';
    //   _phone.text = showData?.mobileNumber?.toString() ?? '';
     
    // });
         
    // });
  }

   Future<void> _fetchData() async {
    try {
      UserDetails? data = await userDetailsControllerProvider.UserDetailsShow();
      setState(() {
        showData = data;
        _fullName.text = showData?.name?.toString() ?? '';
        _address.text = showData?.address?.toString() ?? '';
        _email.text = showData?.email?.toString() ?? '';
        _phone.text = showData?.mobileNumber?.toString() ?? '';
        _isLoading = false; // Set to false when data is fetched
      });
    } catch (e) {
      // Handle error
      print(e);
      setState(() {
        _isLoading = false; // Set to false even on error
      });
    }
  }


  Future<void> _fetchRoleId() async {
  String roleId = await DatabaseControllerProvider().getRoleId();
  setState(() {
    this.roleId = roleId;
  });
  }

   @override
  void dispose() {
    _fullName.dispose();
    _address.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }


 File? _avatarImageFile;
  final _picker = ImagePicker();
  Future<void> getAvatarImage()async{
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if(pickedFile != null){
      setState(() {
        _avatarImageFile = File(pickedFile.path);
        print('your Avatar path is: $_avatarImageFile');
        
      });
    }
  }

 

  @override
  Widget build(BuildContext context) {
   
    return  Scaffold(
   appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Update personal information',
          style: AppTextStyle.ongoingBooking,
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(), // Show circular progress indicator while loading
            )
          : 
        SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 80,
                        width: 90,
                        decoration: _avatarImageFile == null  ?
                          BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(widget.profilePic)
                                
                                )
                                )
                            : 
                        BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: FileImage(_avatarImageFile!)
                                ),
                                )
                       
                      ),
        
                       
                    
                      
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: (){
                          getAvatarImage();
                        },
                          child: const Icon(Icons.edit))
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                   AppTextFormField(
                    labelText: Labels.fullName,
                    extraLabelText: " *",
                    controller: _fullName,
                    hintText: Labels.fullName,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      return bookingControllerProvider.validateName(value!);
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                     AppTextFormField(
                    labelText: Labels.address,
                    extraLabelText: " *",
                    controller: _address,
                    hintText: Labels.address,
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      return bookingControllerProvider.validateBlankField(value!);
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  AppTextFormField(
                    labelText: Labels.yourEmail,
                    // extraLabelText: " *",
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
                    labelText: Labels.mobileNo,
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
        
                  Consumer<AuthenticationControllerProvider>(
                  builder: (context, auth, child) {
                  return AppTextFormField(
                labelText: Labels.updatePassword,
                
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
                             
                  
                );
                }),
        
                const SizedBox(
                    height: 5,
                  ),
        
                   
                   Consumer<UserDetailsControllerProvider>(
                  builder: (context, userDetail, child) {
                         WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (userDetail.responseMessage != '') {
                              showMessage(
                                  message: userDetail.responseMessage, context: context);
                              userDetail.clear();
                            }
                          });
            
                    return customButton(
                      text: Labels.updateProfile.toUpperCase(),
                         ontap: () async {
                        if (_formKey.currentState!.validate()) {
            
                            try {
                            await  userDetail.updateUserProfile(
                            id: showData!.id!.toInt(),
                            address: _address.text.trim(),  
                            fullName: _fullName.text.trim(),
                            email: _email.text.trim(), 
                            phone: _phone.text.trim(),
                            profileImage: _avatarImageFile,
                            password: _password.text.trim(),
                            
                                onSuccess: () {
                                // Clear the text form field values here
                                 _address.clear();
                                _fullName.clear();
                                _email.clear();
                                _phone.clear();
                                _password.clear();
                              
                                
                              },
                           
                            );
        
                             
                             if(roleId == '3'){
                               // ignore: use_build_context_synchronously
                                PageNavigator(ctx: context)
                                .nextPageOnly(page: const AgentHomeView());
                             }else{
                               // ignore: use_build_context_synchronously
                                PageNavigator(ctx: context)
                                .nextPageOnly(page: const HomeView());
                             }  
                              
                            
                            } catch (e) {
                              AppErrorSnackBar(context).error(e);
                            }
            
           
                        }
                      },
                
                    context: context,
                    status: userDetail.isLoading,
                
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
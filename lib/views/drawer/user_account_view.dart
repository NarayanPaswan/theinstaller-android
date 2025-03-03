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


class UserAccountView extends StatefulWidget {
  String profilePic;
  UserAccountView({super.key, 
  required this.profilePic,
  });
  
  @override
  State<UserAccountView> createState() => _UserAccountViewState();
}

class _UserAccountViewState extends State<UserAccountView> {
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
    
  @override
  void initState() {
    super.initState();
     _fetchRoleId();
    // print("Your profile pic url ${widget.profilePic}");
    setState(() {
     userDetailsControllerProvider.UserDetailsShow().then((data) {

      showData = data;
      _fullName.text = showData?.name?.toString() ?? '';
      _address.text = showData?.address?.toString() ?? '';
      _email.text = showData?.email?.toString() ?? '';
      _phone.text = showData?.mobileNumber?.toString() ?? '';
     
    });
         
    });
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
          'User Account Information',
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

                  
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                 AppTextFormField(
                  readOnly: true,
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
                  maxLines: 4,
                  readOnly: true,  
                  labelText: Labels.address,
                  extraLabelText: " *",
                  controller: _address,
                  hintText: Labels.address,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    return bookingControllerProvider.validateName(value!);
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                AppTextFormField(
                  readOnly: true,
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
                  readOnly: true,
                  labelText: Labels.mobileNo,
                  extraLabelText: " *",
                  controller: _phone,
                  hintText: Labels.mobileNoHint,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    return bookingControllerProvider.validateMobile(value!);
                  },
                ),
                 const SizedBox(height: 150.0,),
                  Text(Labels.version,style: AppTextStyle.drawerFontstyle,),
                
              ],
            ),
            
          ),
          
        ),
      
      ),
    );
  }
}
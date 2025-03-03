import 'package:flutter/material.dart';
import 'package:theinstallers/views/drawer/update_personal_information.dart';
import 'package:theinstallers/views/drawer/user_account_view.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../controller/database/database_controller_provider.dart';
import '../../controller/show_user_details_controller_provider.dart';
import '../../model/user_details.dart';
import '../../utils/assets_path.dart';
import '../../utils/components/app_url.dart';
import '../../utils/components/routers.dart';
import '../../utils/labels.dart';
import '../../utils/style/app_colors.dart';
import '../../utils/style/app_text_style.dart';
import '../agent/completed_booking_of_agent_view.dart';
import '../authentication/dealer_employee_register_view.dart';
import '../authentication/login_view.dart';
import '../dealer_booking/acknowledged_booking_view.dart';
import '../dealer_booking/completed_booking_view.dart';
import '../dealer_booking/dealer_employee_list_view.dart';
import '../dealer_booking/on_going_booking_view.dart';
import 'delete_account_view.dart';

class MyDrawerScreen extends StatefulWidget {
  const MyDrawerScreen({Key? key}) : super(key: key);

  @override
  State<MyDrawerScreen> createState() => _MyDrawerScreenState();
}

class _MyDrawerScreenState extends State<MyDrawerScreen> {

  final backendDataProvider = UserDetailsControllerProvider();
  String roleId = '';
  UserDetails? showData;

  @override
  void initState() {
    super.initState();
     _fetchRoleId();
    backendDataProvider.UserDetailsShow().then((data) {
      setState(() {
        showData = data ;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('roll id is $roleId');
    return Scaffold(

        body:
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 25,top: 60,right: 25),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                            height: 80,
                            width: 80,
                            child: showData?.avatar == null  ?
                            const Image(image: AssetImage(AssetsPath.blankprofile)):
                           
                             ClipOval(
                      child: Image.network(
                        AppUrl.profileUrl + showData?.avatar,
                        fit: BoxFit.cover,
                      ),
                    ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      
                        Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            if (showData?.name != null || showData?.companyName != null)
                              SizedBox(
                                width: 200,
                                child: Text(
                                  ' Hey 👋 \n ${showData?.companyName ?? ""} ${showData?.name ?? ""}',
                                  style: AppTextStyle.userNamestyle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            else
                              Text(
                                ' Hey 👋 \n',
                                style: AppTextStyle.userNamestyle,
                              ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(width: 30),
                    InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child:  Text('X',style: AppTextStyle.xtextStyle,))
                  ],
                ),
                const SizedBox(height: 30),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(Labels.worksaarEnterprises,style: AppTextStyle.worksaarStyle,),
                    InkWell(
                        onTap: (){
                            // Future.delayed(const Duration(seconds: 2), () {
                            //   PageNavigator(ctx: context).nextPage(page: UpdatePersonalInformationView(
                            //     profilePic: AppUrl.profileUrl+showData?.avatar,
                            //   ));
                            // });
                           
                              PageNavigator(ctx: context).nextPage(page: UpdatePersonalInformationView(
                                profilePic: AppUrl.profileUrl+showData?.avatar,
                              ));
                           
                        },
                        child: Text(Labels.profileEdit  ,style: AppTextStyle.profileEditStyle,))
                  ],
                ),
                if(roleId != '5' && roleId != '3')
                const SizedBox(height: 40),

                
                 
                 Visibility(
                  visible: roleId != '5' && roleId != '3',
                   child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const DealerEmployeeRegisterView()));
                    },
                    child: Row(
                      children: [
                        const SizedBox(
                            height: 20,
                            width: 20,
                            child: Image(image: AssetImage(AssetsPath.contactUs))),
                        const SizedBox(width: 15),
                        Text(Labels.createEmployee,style: AppTextStyle.drawerFontstyle,)
                      ],
                    ),
                                 ),
                 ),
               
               if(roleId != '3')
                const SizedBox(height: 35),
                if(roleId != '3')
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const AcknowledgedBookingView()));
                  },
                  child: Row(
                    children: [
                      const SizedBox( 
                          height: 20,
                          width: 20,
                          child: Image(image: AssetImage(AssetsPath.ongoingBooking))),
                      const SizedBox(width: 15),
                      Text(Labels.acknowledgedBooking,style: AppTextStyle.drawerFontstyle,)
                    ],
                  ),
                ),

               if(roleId != '3')
                const SizedBox(height: 35),
                if(roleId != '3')
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const OnGoingBookingView()));
                  },
                  child: Row(
                    children: [
                      const SizedBox( 
                          height: 20,
                          width: 20,
                          child: Image(image: AssetImage(AssetsPath.ongoingBooking))),
                      const SizedBox(width: 15),
                      Text(Labels.ongoingbooking,style: AppTextStyle.drawerFontstyle,)
                    ],
                  ),
                ),
              
                if(roleId != '3')
                const SizedBox(height: 35),
               if(roleId != '3')
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const CompletedBookingView()));
                  },
                  child: Row(
                    children: [
                      const SizedBox(
                          height: 20,
                          width: 20,
                          child: Image(image: AssetImage(AssetsPath.completeBooking))),
                      const SizedBox(width: 15),
                      Text(Labels.completedbooking,style: AppTextStyle.drawerFontstyle,)
                    ],
                  ),
                ),
                //it's for agent only
              if(roleId == '3')
                const SizedBox(height: 35),
               if(roleId == '3')
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const CompletedBookingOfAgentView()));
                  },
                  child: Row(
                    children: [
                      const SizedBox(
                          height: 20,
                          width: 20,
                          child: Image(image: AssetImage(AssetsPath.completeBooking))),
                      const SizedBox(width: 15),
                      Text(Labels.completedbooking,style: AppTextStyle.drawerFontstyle,)
                    ],
                  ),
                ),

                // if(roleId != '5' && roleId != '3')
                const SizedBox(height: 35),
                // if(roleId != '5' && roleId != '3')
                InkWell(
                   onTap: (){
                            Future.delayed(const Duration(seconds: 2), () {
                              PageNavigator(ctx: context).nextPage(page: UserAccountView(
                                profilePic: AppUrl.profileUrl+showData?.avatar,
                              ));
                            });
                        },
                  child: Row(
                    children: [
                      const SizedBox(
                          height: 20,
                          width: 20,
                          child: Image(image: AssetImage(AssetsPath.account))),
                      const SizedBox(width: 15),
                      Text(Labels.account,style: AppTextStyle.drawerFontstyle,)
                    ],
                  ),
                ),
                if(roleId != '5' && roleId != '3')
                 const SizedBox(height: 35),
                if(roleId != '5' && roleId != '3')
                InkWell(
                   onTap: (){
                            PageNavigator(ctx: context).nextPage(page: DealerEmployeeListView(
                               
                              ));
                        },
                  child: Row(
                    children: [
                      const SizedBox(
                          height: 20,
                          width: 20,
                          child: Image(image: AssetImage(AssetsPath.account))),
                      const SizedBox(width: 15),
                      Text(Labels.dealerEmployee,style: AppTextStyle.drawerFontstyle,)
                    ],
                  ),
                ),
             
                
                const SizedBox(height: 35),
                
                InkWell(
                   onTap: ()async{
                     String websitelink = 'https://theinstallers.in/faq/';
                    if (await canLaunchUrlString(websitelink)) {
                      launchUrlString(websitelink, mode: LaunchMode.inAppWebView);
                    } 
                  
                  },
                  child: Row(
                    children: [
                      const SizedBox(
                          height: 20,
                          width: 20,
                          child: Image(image: AssetImage(AssetsPath.question))),
                      const SizedBox(width: 15),
                      Text(Labels.questions,style: AppTextStyle.drawerFontstyle,)
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                InkWell(
                  onTap: ()async{
                     String websitelink = 'https://theinstallers.in/terms-and-condition/';
                    if (await canLaunchUrlString(websitelink)) {
                      launchUrlString(websitelink, mode: LaunchMode.inAppWebView);
                    } 
                  
                  },
                  child: Row(
                    children: [
                      const SizedBox(
                          height: 20,
                          width: 20,
                          child: Image(image: AssetImage(AssetsPath.termsAndCondtion))),
                      const SizedBox(width: 15),
                      Text(Labels.termsAndConditions,style: AppTextStyle.drawerFontstyle,)
                    ],
                  ),
                ),

                 const SizedBox(height: 35),
                InkWell(
                  onTap: ()async{
                     String websitelink = 'https://theinstallers.in/privacy-policy/';
                    if (await canLaunchUrlString(websitelink)) {
                      launchUrlString(websitelink, mode: LaunchMode.inAppWebView);
                    } 
                  
                  },
                  child: Row(
                    children: [
                      const SizedBox(
                          height: 20,
                          width: 20,
                          child: Image(image: AssetImage(AssetsPath.termsAndCondtion))),
                      const SizedBox(width: 15),
                      Text(Labels.privacyPolicy,style: AppTextStyle.drawerFontstyle,)
                    ],
                  ),
                ),
                
                
                const SizedBox(height: 35),
                InkWell(
                   onTap: ()async{
                     String websitelink = 'https://theinstallers.in/contact-us/';
                    if (await canLaunchUrlString(websitelink)) {
                      launchUrlString(websitelink, mode: LaunchMode.inAppWebView);
                    } 
                  
                  },
                  child: Row(
                    children: [
                      const SizedBox(
                          height: 20,
                          width: 20,
                          child: Image(image: AssetImage(AssetsPath.contactUs))),
                      const SizedBox(width: 15),
                      Text(Labels.contactUs,style: AppTextStyle.drawerFontstyle,)
                    ],
                  ),
                ),
                
                const SizedBox(height: 35),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> DeleteAccountView()));
                  },
                  child: Row(
                    children: [
                      const SizedBox( 
                          height: 20,
                          width: 20,
                          child: Image(image: AssetImage(AssetsPath.ongoingBooking))),
                      const SizedBox(width: 15),
                      Text(Labels.deleteAccount,style: AppTextStyle.drawerFontstyle,)
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    InkWell(
                      onTap: (){
                        DatabaseControllerProvider().logOut();
                        PageNavigator(ctx: context).nextPageOnly(page: const LoginView());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: const BorderRadius.all(Radius.circular(10))
                        ),
                        width: 200,
                        height: 50,
                        child:  Center(
                          child: Text(Labels.signOut,style: AppTextStyle.signOutButtonStyle,),
                        ),
                      ),
                    ),
                  ],
                ),
               
                const SizedBox(height: 20),
            
                Row(
                  children: [
                    InkWell(
                     onTap: ()async{
                     String websitelink = 'https://theinstallers.in/services/';
                    if (await canLaunchUrlString(websitelink)) {
                      launchUrlString(websitelink, mode: LaunchMode.inAppWebView);
                    } 
                  
                    },
                      child: Container(
                        decoration:  BoxDecoration(
                            color: AppColors.supportServiceButtonColor,
                            borderRadius: const BorderRadius.all(Radius.circular(10))
                        ),
                        width: 200,
                        height: 50,
                        child:  Center(
                          child: Text(Labels.supportService,style: AppTextStyle.supportServiceButtonStyle,),
                        ),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(Labels.version,style: AppTextStyle.drawerFontstyle,)),

               

              ],
            ),
          ),
        )

    );
  }
}

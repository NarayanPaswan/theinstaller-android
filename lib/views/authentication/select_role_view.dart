import 'package:theinstallers/views/authentication/agent_register_view.dart';
import 'package:theinstallers/views/authentication/dealer_register_view.dart';
import '../../controller/authControllerProvider/auth_controller_provider.dart';
import '../../utils/exports.dart';
import '../../widgets/custom_label.dart';

class SelectRoleView extends StatefulWidget {
  const SelectRoleView({super.key});

  @override
  State<SelectRoleView> createState() => _SelectRoleViewState();
}

class _SelectRoleViewState extends State<SelectRoleView> {
  final authenticationProvider = AuthenticationControllerProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          
          children: [
            const SizedBox(height: 120,), 
            CustomLabel(text:  Labels.selectRole,textStyle: AppTextStyle.signIn,),
           
              GestureDetector(
                onTap: ()async{
                     Future.delayed(const Duration(seconds: 1), () {
                        PageNavigator(ctx: context)
                            .nextPageOnly(page: const DealerRegisterView());
                      });
                },
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                   border: Border.all(
                    color: AppColors.agentLineColor,
                    width: 1,
                  ),
                  ),
                  
                  child:  Row(
                    children: [
                      
                      Expanded(
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                            alignment: Alignment.centerLeft,
                            child: CustomLabel(text: Labels.lookingAsaDealer, textStyle: AppTextStyle.dealerstyle,),),
                          ),
                          
                          Padding(
                            padding: const EdgeInsets.only(bottom:8.0, left: 8.0, right: 8.0),
                            child: Text(Labels.toPlaceAny, textAlign: TextAlign.justify, style: AppTextStyle.toPlaceAnyTypeStyle,),
                          ),
                        
                          ],
                        ),
                      ),
                     const Align(
                        alignment: Alignment.bottomCenter,
                        child: Image(
                        height: 120.0,
                        width: 105.0,
                        fit: BoxFit.cover,
                        image: AssetImage(AssetsPath.dealerImage),),
                      ),
                    ],
                  ),
                  
                ),
              ),
               
     
              GestureDetector(
                onTap: ()async{
               
                      Future.delayed(const Duration(seconds: 1), () {
                        PageNavigator(ctx: context)
                            .nextPageOnly(page: const AgentRegisterView());
                      });
                },
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                   border: Border.all(
                    color: AppColors.agentLineColor,
                    width: 1,
                  ),
                  ),
                  
                  child:  Row(
                    children: [
                      
                      Expanded(
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                                              
                          
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                            alignment: Alignment.centerLeft,
                            child: CustomLabel(text: Labels.lookingAsAnAgent, textStyle: AppTextStyle.dealerstyle,),),
                          ),
                          
                          Padding(
                            padding: const EdgeInsets.only(bottom:8.0, left: 8.0, right: 8.0),
                            child: Text(Labels.searchAndExecuteOrders, textAlign: TextAlign.justify, style: AppTextStyle.toPlaceAnyTypeStyle,),
                          ),
                        
                          ],
                        ),
                      ),
                     const Align(
                        alignment: Alignment.bottomCenter,
                        child: Image(
                        height: 120.0,
                        width: 105.0,
                        fit: BoxFit.cover,
                        image: AssetImage(AssetsPath.agentImage),),
                      ),
                    ],
                  ),
                  
                ),
              ),
            
             const SizedBox(height: 100,), 
          ],
        ),
      ),
    );
  }
}
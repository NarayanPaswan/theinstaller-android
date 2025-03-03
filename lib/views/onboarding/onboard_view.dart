import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:theinstallers/views/authentication/login_view.dart';
import 'package:theinstallers/views/onboarding/build_onboard_page.dart';
import '../../controller/authControllerProvider/auth_controller_provider.dart';
import '../../model/onboarding_model.dart';
import '../../utils/exports.dart';

class OnboardView extends StatefulWidget {
  const OnboardView({super.key});

  @override
  State<OnboardView> createState() => _OnboardViewState();
}

class _OnboardViewState extends State<OnboardView> {
  final authenticationProvider = AuthenticationControllerProvider();
  final _pageController = PageController();
  OnboardingModel? onboardingData;
  // ignore: prefer_typing_uninitialized_variables
  var lastIndex;
  bool isLastpage = false;
  @override
  void initState() {
    super.initState();
    
    authenticationProvider.fetchOnboarding().then((data) {
    if (mounted) { // Check if the widget is still mounted
    setState(() {
      onboardingData = data;
      if (onboardingData != null && onboardingData!.data != null) {
         lastIndex = onboardingData!.data!.length - 1;
        
      }
    });
    }
  });
 authenticationProvider.getUserCurrentLocation(context);
//  authenticationProvider.getCameraAndStorage(context);
 
      
  }

   
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
       
   if (onboardingData != null && onboardingData!.data != null) {
    return Scaffold(
      
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom:190.0),
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index){
              setState(() {
                isLastpage = index == lastIndex;
              });
            },
            itemCount: onboardingData?.data?.length ?? 0,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index){
              final onboardData = onboardingData!.data![index];
              final urlImage = AppUrl.imageUrl + (onboardData.image ?? ''); 
               return BuildOnboardPage(
                color: AppColors.whiteColor, 
                urlImage: urlImage, 
                title: onboardData.title ?? '', 
                subtitle: onboardData.subTitle ?? '');
            
            },
            
          
          ),
        ),
      ),
      bottomSheet: isLastpage ? Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom:32.0),
        child: TextButton(
          onPressed: (){
            PageNavigator(ctx: context).nextPageOnly(page: const LoginView());
          }, 
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: AppColors.getStartbuttonColor,
            minimumSize: const Size.fromHeight(50),
          ),
          child: Text("SIGN IN", style: TextStyle(color: AppColors.whiteColor, fontSize: 14),)
          ),
      ):
      
      Container(
        color: AppColors.whiteColor,
        height: 190.0,
        child:  Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: 10,
              left: 15,
              child: SmoothPageIndicator(controller: _pageController, count: onboardingData?.data?.length ?? 0,
              onDotClicked: (index)=>_pageController.animateToPage(index, duration: const Duration(milliseconds: 500), 
              curve: Curves.easeInOut),
            ),
            ),
           
            Positioned(
              top: 71,
              left: 15,
              child: TextButton(onPressed: (){
                      return _pageController.jumpToPage(lastIndex);
                    }, child:  Text("Skip", style: TextStyle(color: AppColors.skipColor),)),
            ),
             const Positioned(
              bottom: 0,
              right: 0,
               child: Align(
                alignment: Alignment.bottomRight,
                 child: Image(
                        image:  AssetImage(AssetsPath.onboardingbottom),
                        ),
               ),
             ),

             Positioned(
              top: 71,
              right: 31,
               child: IconButton(onPressed: ()=>_pageController.nextPage(duration: const Duration(milliseconds: 500),
                           curve: Curves.easeInOut),
                           icon:  Icon(Icons.arrow_forward, color: AppColors.whiteColor,)),
             ),
          ],
        )
      ),


    );
    
   }else{
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
   }
    
  }
}
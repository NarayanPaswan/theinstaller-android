import 'auth_wrapper.dart';
import 'utils/exports.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    navigate();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
     return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
               Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    const Image(
                      fit: BoxFit.cover,
                      width: double.infinity,
                      image:  AssetImage(AssetsPath.splashFrame),
                    ),
                    Positioned(
                      // top: 180,
                      top: MediaQuery.of(context).size.height * 0.20,
                      child: const Image(
                        image:  AssetImage(AssetsPath.splashLogo),
                      ),
                    ),
                  ],
                ),
              ),
              
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                   const Text(
                      "The Installers",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                  const SizedBox(height: 10),
                   Text("WORKING WITH EXCELLENT", style: AppTextStyle.workingWithSplash,),
                    const SizedBox(height: 80),
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.getStartbuttonColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: Text("GET START", style: AppTextStyle.getStartedSplash),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
 
  }
  
  void navigate() {
    Future.delayed(const Duration(seconds: 3), (){
      PageNavigator(ctx: context).nextPageOnly(page: const AuthWrapper(),);
    });
  }
  
}
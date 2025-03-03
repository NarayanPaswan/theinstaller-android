import '../../utils/exports.dart';

class BuildOnboardPage extends StatelessWidget {
  final Color color;
  final String urlImage;
  final String title;
  final String subtitle;
  
  const BuildOnboardPage({super.key, 
  required this.color,
  required this.urlImage,
  required this.title,
  required this.subtitle
  });

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(top:8.0, bottom: 8.0, right: 15.0, left: 15.0),
      child: Container(
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              urlImage,
              height: 200,
              fit: BoxFit.cover,
              width: 181,
              ), 
              const SizedBox(height: 32,),
              Text(
                title,
               textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24,),
              
                 Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(color:AppColors.onboardingSubTitileColor),
                ),
              
          ],
        ),
      ),
    );
  }
}

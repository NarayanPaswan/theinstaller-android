import '../utils/exports.dart';

class DropdownLabel extends StatelessWidget {
  final String text;
  
  

  const DropdownLabel({super.key, 
  required this.text,
   
  });

  @override
  Widget build(BuildContext context) {
    
    return Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                        text: text,
                        style: AppTextStyle.continueWith,
                        children: [
                          TextSpan(
                            text: " *",
                            style: AppTextStyle.extraLabelTextColor,
                          )
                        ]),
                        ),
                        
                        ),
                  );
  }
}
import '../utils/exports.dart';

class CustomLabel extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  

  const CustomLabel({super.key, 
  required this.text,
   this.textStyle,
   
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      
       style: textStyle ?? AppTextStyle.continueWith, 
    );
  }
}
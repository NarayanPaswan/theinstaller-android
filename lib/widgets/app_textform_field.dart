import '../../utils/exports.dart';

class AppTextFormField extends StatelessWidget {
  final String? hintText;
  final String labelText;
  final String? extraLabelText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;

  final VoidCallback? suffixIconOnPressed;
  final TextInputType? keyboardType; 
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final String? initialValue;
  final bool obscureText;
  final TextEditingController? controller;
  final int? maxLength; 
  final VoidCallback? onTap;
  final bool readOnly;
  final int? maxLines; 
  
  
  const AppTextFormField({super.key, 
  this.hintText = "Response",
  this.labelText = "", 
  this.extraLabelText,
  this.prefixIcon, 
  this.suffixIcon,  
  this.suffixIconOnPressed, 
  this.keyboardType,  this.validator, 
  this.obscureText = false, 
  this.onChanged, 
  this.initialValue,
  this.controller,
  this.maxLength,
  this.onTap,
  this.readOnly = false,
  this.maxLines =1,

  });

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText.isNotEmpty)
         Padding(
           padding: const EdgeInsets.only(top:8.0, bottom: 8.0),
           child: RichText(
                    textAlign: TextAlign.left,
                    text: TextSpan(
                        text: labelText,
                        style: AppTextStyle.continueWith,
                        children:  [
                          TextSpan(
                            text: extraLabelText,
                            style: AppTextStyle.extraLabelTextColor,
                          )
                        ]),
                  ),
         ),
              TextFormField(
                onTap: onTap,
                readOnly: readOnly,
                style: AppTextStyle.textBoxInputStyle,
                decoration:  InputDecoration(
                  hintText: hintText,
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                  width: 1.0,
                  color: Colors.black,
                  ),
                  ),
                  enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                  width: 1.0,
                  color: AppColors.dropdownBorderColor,
                  ),
                  ),
                  border:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)
                  ),
                  prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon): null,
                  // labelText: labelText,
                  suffixIcon: suffixIcon != null
                  ? IconButton(
                      onPressed: suffixIconOnPressed,
                      icon: Icon(suffixIcon),
                    )
                  : null,
                ),
               keyboardType: keyboardType, 
               maxLength: maxLength,
               maxLines: maxLines,
               onChanged: onChanged,
              controller: controller,
               validator: validator,
               initialValue: initialValue,
               obscureText: obscureText,
               
               ),
      ],
    );
  }
}

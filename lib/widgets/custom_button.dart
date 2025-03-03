import '../utils/exports.dart';

Widget customButton(
    {
    VoidCallback? ontap,
    bool? status = false,
    String? text = 'Save',
    BuildContext? context,
    double? width,
    double? height,
    }) {
  return GestureDetector(
    onTap: status == true ? null : ontap,
    child: Container(
      height: height ?? 48,
      width:  width ?? MediaQuery.of(context!).size.width,
      margin: const EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: status == false ? AppColors.primaryColor : AppColors.grey,
          borderRadius: BorderRadius.circular(8)),
     
      child: Text(
        status == false ? text! : 'Please wait...',
        style: AppTextStyle.textButtonstyle,
      ),
    ),
  );
}
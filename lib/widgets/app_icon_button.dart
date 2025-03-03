import '../utils/exports.dart';

class AppIconButton extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData? iconType;
  final Color? bgColor;
  const AppIconButton({
  super.key,
  this.onTap,
  this.iconType,
  this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
           onTap: onTap,
           child: Container(
           decoration:  BoxDecoration(
           shape: BoxShape.rectangle,
           color: bgColor ?? Colors.red,
           borderRadius: const BorderRadius.all(Radius.circular(10)),
           ),
           height: 35,
           width: 35,
           child: Icon(
                  iconType,
                  color: AppColors.whiteColor,
                  ),
                 ),
                 );
  }
}
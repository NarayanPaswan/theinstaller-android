import '../utils/exports.dart';

class AppBottomAppBar extends StatelessWidget {
  const AppBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        height: 70,
        notchMargin: 5.0,
        shape: const CircularNotchedRectangle(),
        color: AppColors.whiteColor,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              Labels.newServiceBooking,
              style: AppTextStyle.newServiceBooking,
            ),
          ),
        ),
      );
  }
}
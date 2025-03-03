import 'package:theinstallers/views/dealer_booking/service_booking_view.dart';

import '../utils/exports.dart';

class AppFloatingActionButton extends StatelessWidget {
  const AppFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
              PageNavigator(ctx: context)
              .nextPage(page: const ServiceBookingView());
        },
        shape: const CircleBorder(),
        child: Icon(
          Icons.add,
          color: AppColors.whiteColor,
        ),
      );
  }
}
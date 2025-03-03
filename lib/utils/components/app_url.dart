class AppUrl {
  static const String baseUrl = "https://admin.theinstallers.in/api/";
  static const String imageUrl =
      "https://admin.theinstallers.in/public/storage/images/";
  static const String usersUrl =
      "https://admin.theinstallers.in/public/storage/";
  static const String profileUrl =
      "https://admin.theinstallers.in/public/storage/";
  static const String videoUrl =
      "https://admin.theinstallers.in/public/storage/videos/";

  // static const String baseUrl ="https://admin.theinstallers.in/stage/api/";
  // static const String imageUrl ="https://admin.theinstallers.in/stage/public/storage/images/";
  // static const String usersUrl ="https://admin.theinstallers.in/stage/public/storage/";
  // static const String profileUrl ="https://admin.theinstallers.in/stage/public/storage/";
  // static const String videoUrl ="https://admin.theinstallers.in/stage/public/storage/videos/";

  static const String registrationUri = "${baseUrl}auth/register";
  static const String loginUri = "${baseUrl}auth/login";
  static const String logoutUri = "${baseUrl}auth/logout";
  static const String userUri = "${baseUrl}auth/me";
  static const String allBookingFieldsUri =
      "${baseUrl}auth/all-service-booking-fields";
  static const String storeServiceBookingUri =
      "${baseUrl}auth/store-service-booking";
  static const String genderDataUri = '${baseUrl}gender';
  static const String allSatateUri = '${baseUrl}auth/all-states';
  static const String userTypesUri = '${baseUrl}user-types';
  static const String onBoardingUri = '${baseUrl}on-boarding';
  static const String forgotPasswordUri = '${baseUrl}forgot-password';
  static const String updateRoleUri = '${baseUrl}update-role';
  static const String citySatesWise = '${baseUrl}auth/state-wise-cities';
  static const String taskTypeUri = '${baseUrl}auth/task-type';
  static const String allMeasurementDetailsUri =
      "${baseUrl}auth/all-measurement-details-fields";
  static const String updateUserDetails =
      '${baseUrl}auth/update-dealer-details';
  static const String allPendingBookingUri =
      '${baseUrl}auth/all-pending-booking';
  static const String paymentModeUri = '${baseUrl}auth/payment-mode';
  static const String placeApiAutoCompleteUri =
      '${baseUrl}place-api-autocomplete';

  static const String serviceDetailsUri = '${baseUrl}auth/get-service-details';
  static const String updateBookedServiceUri =
      '${baseUrl}auth/update-booked-service';

  static const String allAssignedServiceUri =
      '${baseUrl}auth/all-assigned-service';
  static const String statusUri = '${baseUrl}auth/all-status';

  static const String updateServiceByAgentUri =
      "${baseUrl}auth/update-service-by-agent";
  static const String allOnGoingBookingUri =
      '${baseUrl}auth/all-on-going-booking';
  static const String onGoingServiceDetailsUri =
      '${baseUrl}auth/get-on-going-service-details';

  static const String allCompletedBookingUri =
      '${baseUrl}auth/all-completed-booking';
  static const String completedServiceDetailsUri =
      '${baseUrl}auth/get-booking-completed-details';
  static const String yesNoUri = '${baseUrl}auth/all-yes-no';
  static const String nearestServiceCenter =
      '${baseUrl}auth/nearest-service-center';
  static const String acceptDeclineTaskUri =
      "${baseUrl}auth/accept-decline-task";
  static const String allCompletedServiceOfAgentUri =
      '${baseUrl}auth/all-completed-service-of-agent';
  static const String deleteReasonUri = '${baseUrl}auth/delete-reason';
  static const String storeDeleteAccountRequestUri =
      "${baseUrl}auth/delete-account-request";
  static const String serviceCentreUri = '${baseUrl}service-centre';
  static const String dealerEmployeeListUri =
      '${baseUrl}auth/dealer-employee-list';
  static const String duplicateBookedServiceUri =
      '${baseUrl}auth/duplicate-service-booking';
  static const String installerCallingTheCustomerUri =
      '${baseUrl}auth/installer-calling-the-customer';
  static const String salutationUri = '${baseUrl}auth/all-salutation';
  static const String produtTypeUri = '${baseUrl}auth/type-of-product';
  static const String subProdutTypeUri = '${baseUrl}auth/type-of-sub-product';
  static const String allAcknowledgedBookingUri =
      '${baseUrl}auth/all-acknowledged-booking';
  static const String cancelServiceUri = '${baseUrl}auth/cancel-service';
}

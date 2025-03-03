import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:theinstallers/views/dealer_booking/completed_booking_view.dart';
import 'package:upgrader/upgrader.dart';
import '../../controller/booking_controller_provider.dart';
import '../../controller/database/database_controller_provider.dart';
import '../../notificationservice/local_notification_service.dart';
import '../../utils/exports.dart';
import '../../widgets/custom_label.dart';
import '../dealer_booking/booking_details_view.dart';
import '../dealer_booking/on_going_booking_details_view.dart';
import '../dealer_booking/on_going_booking_view.dart';
import '../dealer_booking/update_booking_service_view.dart';
import '../drawer/my_drawar_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final scrollController = ScrollController();
  final bookingController = BookingControllerProvider();
  TextEditingController searchController = TextEditingController();
  final TextEditingController _fromDate = TextEditingController();
  final TextEditingController _toDate = TextEditingController();

  int page = 1;
  List pendingService = [];
  bool isLoadingMore = false;
  bool hasMoreData = true;
  bool isLoading = true;

  @override
  void initState() {
    scrollController.addListener(scrollListener);
    allPendingBookingData();

    // // 1. This method call when app in terminated state and you get a notification
    // // when you click on notification app open from terminated state and you can get notification data in this method

    // FirebaseMessaging.instance.getInitialMessage().then(
    //   (message) {
    //     print("App terminated hai");
    //     if (message != null) {
    //       print("New Notification");
    //       if (message.data['_id'] != null) {
    //         Navigator.of(context).push(
    //           MaterialPageRoute(
    //             builder: (context) => OnGoingBookingDetailsView(
    //               serviceId: message.data['_id'],
    //               serviceCode: message.data['_serviceCode'],
    //             ),
    //           ),
    //         );
    //       }
    //     }
    //   },
    // );

    // // // 2. This method only call when App in forground it mean app must be opened
    // FirebaseMessaging.onMessage.listen(
    //   (message) {
    //     print("App me kam kar raha hai");
    //     if (message.notification != null) {
    //       print(message.notification!.title);
    //       print(message.notification!.body);
    //       print("message.data11 ${message.data}");

    //       LocalNotificationService.createanddisplaynotification(message);

    //       if (message.data['_id'] != null) {
    //         Navigator.of(context).push(
    //           MaterialPageRoute(
    //             builder: (context) => OnGoingBookingDetailsView(
    //               serviceId: message.data['_id'],
    //               serviceCode: message.data['_serviceCode'],
    //             ),
    //           ),
    //         );
    //       }
    //       //notification_message = accepted
    //       if (message.data['notification_message'] == 'accepted') {
    //         print(
    //             "Navigating to HomeView because notification_message is accepted");
    //         Navigator.of(context).push(
    //           MaterialPageRoute(
    //             builder: (context) => const OnGoingBookingView(),
    //           ),
    //         );
    //       }

    //       //notification_message = completed
    //       if (message.data['notification_message'] == 'completed') {
    //         print(
    //             "Navigating to HomeView because notification_message is completed");
    //         Navigator.of(context).push(
    //           MaterialPageRoute(
    //             builder: (context) => const CompletedBookingView(),
    //           ),
    //         );
    //       }
    //     }
    //   },
    // );

    // // 3. This method only call when App in background and not terminated(not closed)
    // FirebaseMessaging.onMessageOpenedApp.listen(
    //   (message) {
    //     print("App Backgournd me hai");
    //     if (message.notification != null) {
    //       print(message.notification!.title);
    //       print(message.notification!.body);
    //       print("message.data22 ${message.data['_id']}");
    //       print("message.data22 ${message.data['_serviceCode']}");
    //     }

    //     if (message.data['_id'] != null) {
    //       Navigator.of(context).push(
    //         MaterialPageRoute(
    //           builder: (context) => OnGoingBookingDetailsView(
    //             serviceId: message.data['_id'],
    //             serviceCode: message.data['_serviceCode'],
    //           ),
    //         ),
    //       );
    //     }
    //   },
    // );

    super.initState();
  }

    String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    _fromDate.dispose();
    _toDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor:
              Colors.white, // Set the background color of the drawer to white
        ),
        child: const MyDrawerScreen(),
      ),
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          Labels.allPendingBooking,
          style: AppTextStyle.ongoingBooking,
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                isLoading = true;
                pendingService = [];
                page = 1;
                isLoadingMore = false;
                hasMoreData = true;
                searchController.text = "";
                _fromDate.text = "";
                _toDate.text = "";
              });
              allPendingBookingData();
            },
          ),
        ],
      ),
      body: UpgradeAlert(
        showIgnore: false,
        showLater: false,
        showReleaseNotes: false,
        upgrader: Upgrader(
          durationUntilAlertAgain: const Duration(days: 1),
          // durationUntilAlertAgain : const Duration(minutes: 1),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppTextFormField(
                      readOnly: true,
                      controller: _fromDate,
                      suffixIcon: Icons.calendar_today_rounded,
                      hintText: 'dd/MM/yyyy',
                      onTap: () async {
                        DateTime? selectedFromDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100));
                        if (selectedFromDate != null) {
                          _fromDate.text =
                              DateFormat('dd/MM/yyyy').format(selectedFromDate);
                          print(DateFormat('dd/MM/yyyy')
                              .format(selectedFromDate));
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AppTextFormField(
                      readOnly: true,
                      controller: _toDate,
                      suffixIcon: Icons.calendar_today_rounded,
                      hintText: 'dd/MM/yyyy',
                      onTap: () async {
                        DateTime? selectedToDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100));
                        if (selectedToDate != null) {
                          _toDate.text =
                              DateFormat('dd/MM/yyyy').format(selectedToDate);
                          print(
                              DateFormat('dd/MM/yyyy').format(selectedToDate));
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: AppTextFormField(
                      controller: searchController,
                      hintText: "Search by name, email, mobile or code",
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      updateSearchResults(
                        searchController.text,
                        _fromDate.text,
                        _toDate.text,
                      );
                    },
                    child: const Text('Search'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : pendingService.isEmpty
                      ? const SingleChildScrollView(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image(image: AssetImage(AssetsPath.emptyBox)),
                                CustomLabel(text: Labels.noPendingService),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          controller: scrollController,
                          itemCount: isLoadingMore
                              ? pendingService.length + 1
                              : pendingService.length,
                          itemBuilder: (context, i) {
                            if (i < pendingService.length) {
                              return GestureDetector(
                                onTap: () {
                                  PageNavigator(ctx: context).nextPage(
                                    page: BookingDetailsView(
                                      serviceId:
                                          pendingService[i]['id'].toString(),
                                      serviceCode: pendingService[i]
                                              ['service_code']
                                          .toString(),
                                    ),
                                  );
                                },
                                child: Card(
                                  color: AppColors.whiteColor,
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Positioned(
                                              top: 5,
                                              right: 5,
                                              child: InkWell(
                                                onTap: () {
                                                  PageNavigator(ctx: context)
                                                      .nextPage(
                                                          page:
                                                              UpdateBookingServiceView(
                                                    id: pendingService[i]['id']
                                                        .toInt(),
                                                    taskTypeId:
                                                        pendingService[i]
                                                                ['task_type_id']
                                                            .toInt(),
                                                    address: pendingService[i]
                                                            ['address']
                                                        .toString(),
                                                    fullName: pendingService[i]
                                                            ['client_name']
                                                        .toString(),
                                                    email: pendingService[i][
                                                            'client_email_address']
                                                        .toString(),
                                                    phone: pendingService[i][
                                                            'client_mobile_number']
                                                        .toString(),
                                                    dateAndTimeOfBooking:
                                                        pendingService[i]
                                                                ['date_time']
                                                            .toString(),
                                                    typeOfMeasurement:
                                                        pendingService[i][
                                                                'type_of_measurement']
                                                            .toString(),
                                                    typeOfMaterial: pendingService[
                                                                i]
                                                            ['type_of_material']
                                                        .toString(),
                                                    paymentModeId: pendingService[
                                                                i]
                                                            ['payment_mode_id']
                                                        .toInt(),
                                                    remarks: pendingService[i]
                                                            ['remarks']
                                                        .toString(),
                                                    notes: pendingService[i]
                                                            ['notes']
                                                        .toString(),
                                                    landmark: pendingService[i]
                                                            ['landmark']
                                                        .toString(),
                                                    quantity: pendingService[i]
                                                            ['quantity']
                                                        .toString(),
                                                    salutationId:
                                                        pendingService[i]
                                                                    ['salut'] !=
                                                                null
                                                            ? pendingService[i]
                                                                    ['salut']
                                                                .toInt()
                                                            : null,
                                                    productTypeId: pendingService[
                                                                    i][
                                                                'type_of_product_id'] !=
                                                            null
                                                        ? pendingService[i][
                                                                'type_of_product_id']
                                                            .toInt()
                                                        : null,
                                                    subProductIds: pendingService[
                                                                    i][
                                                                'sub_product_id'] !=
                                                            null
                                                        ? pendingService[i][
                                                                'sub_product_id']
                                                            .split(',')
                                                            .map((id) =>
                                                                int.tryParse(
                                                                    id.trim()))
                                                            .where((id) =>
                                                                id != null)
                                                            .cast<int>()
                                                            .toList()
                                                        : [],
                                                  ));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.rectangle,
                                                      color:
                                                          AppColors.greenColor,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  10))),
                                                  height: 35,
                                                  width: 35,
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: AppColors.whiteColor,
                                                  ),
                                                ),
                                              )),

                                          //create duplicate service start
                                          Positioned(
                                              top: 5,
                                              right: 50,
                                              child: InkWell(
                                                onTap: () async {
                                                  // Show AlertDialog to confirm duplication
                                                  final shouldDuplicate =
                                                      await showDialog<bool>(
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    AlertDialog(
                                                              title: const Text(
                                                                  'Duplicate Service'),
                                                              content: const Text(
                                                                  'Do you want to duplicate this service?'),
                                                              actions: [
                                                                OutlinedButton(
                                                                  style: OutlinedButton
                                                                      .styleFrom(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                            vertical:
                                                                                8,
                                                                            horizontal:
                                                                                32,
                                                                          ),
                                                                          foregroundColor: const Color(
                                                                              0xffEC5B5B),
                                                                          side:
                                                                              const BorderSide(
                                                                            color:
                                                                                Color(0xffEC5B5B),
                                                                          )),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(
                                                                            false);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'No'),
                                                                ),
                                                                ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        AppColors
                                                                            .greenColor,
                                                                    foregroundColor:
                                                                        const Color(
                                                                            0xff2A303E),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(
                                                                            true);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'Yes'),
                                                                )
                                                              ],
                                                            ),
                                                          ) ??
                                                          false; // In case the dialog is dismissed

                                                  if (shouldDuplicate) {
                                                    try {
                                                      if (pendingService[i]
                                                              ['id'] !=
                                                          null) {
                                                        await bookingController
                                                            .duplicateBooking(
                                                          id: pendingService[i]
                                                                  ['id']
                                                              .toInt(),
                                                        );
                                                      }
                                                      // Using ScaffoldMessenger to avoid using build context synchronously
                                                      // ignore: use_build_context_synchronously
                                                      showMessage(
                                                          message:
                                                              'Service duplicated successfully',
                                                          context: context);

                                                      // Navigate back to the HomeView
                                                      // ignore: use_build_context_synchronously
                                                      Navigator
                                                          .pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const HomeView()),
                                                        ModalRoute.withName(
                                                            '/'),
                                                      );
                                                    } catch (e) {
                                                      AppErrorSnackBar(context)
                                                          .error(e);
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.rectangle,
                                                      color:
                                                          AppColors.greenColor,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                              Radius.circular(
                                                                  10))),
                                                  height: 35,
                                                  width: 35,
                                                  child: Icon(
                                                    Icons.copy,
                                                    color: AppColors.whiteColor,
                                                  ),
                                                ),
                                              )),
                                          //create duplicate service end

                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12, top: 12),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                      decoration: const BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10))),
                                                      height: 60,
                                                      width: 60,
                                                      child: pendingService[i]['image'] == null
                                                          ? const Image(
                                                              image: AssetImage(
                                                                  AssetsPath
                                                                      .searchImage))
                                                          : Image(
                                                              image: NetworkImage(
                                                                  AppUrl.imageUrl +
                                                                      pendingService[i]
                                                                          ['image']))),
                                                ),
                                                const SizedBox(width: 15),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    if (pendingService[i]
                                                            ['client_name'] ==
                                                        null)
                                                      const SizedBox()
                                                    else
                                                      Text(
                                                        // pendingService[i]
                                                        //         ['client_name']
                                                        //     .toString(),
                                                        // '${pendingService[i]['salutation_data'] != null ? pendingService[i]['salutation_data']['salutation_list'] ?? "" : ""} ${pendingService[i]['client_name'] ?? ""}',
                                                        // 
                                                        _truncateText(
                                                      '${pendingService[i]['salutation_data'] != null ? pendingService[i]['salutation_data']['salutation_list'] ?? "" : ""} ${pendingService[i]['client_name'] ?? ""}',
                                                      25),
                                                        style: AppTextStyle
                                                            .customerName,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    const SizedBox(height: 15),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              100,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .cleaning_services_outlined,
                                                                color: AppColors
                                                                    .black26Color,
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              if (pendingService[
                                                                          i][
                                                                      'tasktype'] ==
                                                                  null)
                                                                const SizedBox()
                                                              else
                                                                Text(
                                                                  pendingService[
                                                                              i]
                                                                          [
                                                                          'tasktype']
                                                                      [
                                                                      'task_name'],
                                                                  style: AppTextStyle
                                                                      .meddileStyle,
                                                                ),
                                                            ],
                                                          ),
                                                          // SizedBox(width: 35),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                'Date: ',
                                                                style: AppTextStyle
                                                                    .meddileStyle,
                                                              ),
                                                              if (pendingService[
                                                                          i][
                                                                      'date_time'] ==
                                                                  null)
                                                                const SizedBox()
                                                              else
                                                                Text(
                                                                  pendingService[
                                                                          i][
                                                                      'date_time'],
                                                                  style:
                                                                      AppTextStyle
                                                                          .time,
                                                                )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      Divider(
                                        thickness: 1,
                                        color: AppColors.black12Color,
                                      ),
                                      // SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              const SizedBox(width: 10),
                                              Text(
                                                'Address: ',
                                                style: AppTextStyle.address1,
                                              ),
                                              if (pendingService[i]
                                                      ['address'] ==
                                                  null)
                                                const SizedBox()
                                              else
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      160,
                                                  child: Text(
                                                    pendingService[i]['address']
                                                        .toString(),
                                                    style:
                                                        AppTextStyle.address2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              const SizedBox(
                                                  height: 25,
                                                  width: 25,
                                                  child: Image(
                                                      image: AssetImage(
                                                          AssetsPath
                                                              .location))),
                                            ],
                                          ),
                                          const SizedBox(
                                              height: 38,
                                              width: 38,
                                              child: Image(
                                                image: AssetImage(
                                                    AssetsPath.persion),
                                              ))
                                        ],
                                      ),

                                      //creator

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(width: 10),
                                          Text(
                                            'Created By: ',
                                            style: AppTextStyle.address1,
                                          ),
                                          if (pendingService[i]
                                                  ['service_creator'] !=
                                              null)
                                            if (pendingService[i]
                                                        ['service_creator']
                                                    ['name'] ==
                                                null)
                                              Flexible(
                                                child: Text(
                                                  pendingService[i][
                                                              'service_creator']
                                                          ['company_name']
                                                      .toString(),
                                                  style: AppTextStyle.address2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              )
                                            else
                                              Flexible(
                                                child: Text(
                                                  pendingService[i][
                                                              'service_creator']
                                                          ['name']
                                                      .toString(),
                                                  style: AppTextStyle.address2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ),
                                          const Spacer(),
                                          ElevatedButton(
                                              onPressed: () async{

                                              final shouldCancel =
                                                      await showDialog<bool>(
                                                            context: context,
                                                            builder:
                                                                (context) =>
                                                                    AlertDialog(
                                                              title: const Text(
                                                                  'Cancel Service'),
                                                              content: const Text(
                                                                  'Do you want to cancel this service?'),
                                                              actions: [
                                                                OutlinedButton(
                                                                  style: OutlinedButton
                                                                      .styleFrom(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                            vertical:
                                                                                8,
                                                                            horizontal:
                                                                                32,
                                                                          ),
                                                                          foregroundColor: const Color(
                                                                              0xffEC5B5B),
                                                                          side:
                                                                              const BorderSide(
                                                                            color:
                                                                                Color(0xffEC5B5B),
                                                                          )),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(
                                                                            false);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'No'),
                                                                ),
                                                                ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        AppColors
                                                                            .greenColor,
                                                                    foregroundColor:
                                                                        const Color(
                                                                            0xff2A303E),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(
                                                                            true);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'Yes'),
                                                                )
                                                              ],
                                                            ),
                                                          ) ??
                                                          false; // In case the dialog is dismissed

                                                  if (shouldCancel) {
                                                    try {
                                                      if (pendingService[i]
                                                              ['id'] !=
                                                          null) {
                                                        await bookingController
                                                            .cancelBooking(
                                                          id: pendingService[i]
                                                                  ['id']
                                                              .toInt(),
                                                        );
                                                      }
                                                      // Using ScaffoldMessenger to avoid using build context synchronously
                                                      // ignore: use_build_context_synchronously
                                                      showMessage(
                                                          message:
                                                              'Service canceled successfully',
                                                          context: context);

                                                      // Navigate back to the HomeView
                                                      // ignore: use_build_context_synchronously
                                                      Navigator
                                                          .pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const HomeView()),
                                                        ModalRoute.withName(
                                                            '/'),
                                                      );
                                                    } catch (e) {
                                                      AppErrorSnackBar(context)
                                                          .error(e);
                                                    }
                                                  }  


                                              },
                                              child: Text("Cancel")),
                                        ],
                                      ),

                                      
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return const Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(child: CircularProgressIndicator()),
                                  SizedBox(
                                    height: 40,
                                  ),
                                ],
                              );
                            }
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: const AppFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const AppBottomAppBar(),
    );
  }

  final dio = Dio();
  Future<void> allPendingBookingData({
    String? searchQuery,
    String? fromDate,
    String? toDate,
  }) async {
    String token;
    token = await DatabaseControllerProvider().getToken();
    try {
      const urlUserDetails = AppUrl.allPendingBookingUri;

      String apiUrl = searchQuery != null
          ? '$urlUserDetails?page=$page&search=$searchQuery'
          : '$urlUserDetails?page=$page';

      // Include fromDate and toDate in the API URL
      apiUrl += fromDate != null ? '&fromDate=$fromDate' : '';
      apiUrl += toDate != null ? '&toDate=$toDate' : '';

      final response = await dio.get(
        // '$urlUserDetails?page=$page',
        apiUrl,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            HttpHeaders.authorizationHeader: "Bearer $token"
          },
        ),
      );

      if (kDebugMode) {
        // print('$urlUserDetails?page=$page');
      }

      final json = response.data['items']['data'];
      setState(() {
        pendingService = pendingService + json;
        hasMoreData = response.data['items']['next_page_url'] != null;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false; // Set isLoading to false in case of error too.
      });
      if (kDebugMode) {
        print('Error fetching user details: $error');
      }
      return;
    }
  }

  Future<void> scrollListener() async {
    if (isLoadingMore || !hasMoreData) return;
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      setState(() {
        isLoadingMore = true;
      });
      page = page + 1;
      await allPendingBookingData();
      if (kDebugMode) {
        print('Scroll called one time');
      }
      setState(() {
        isLoadingMore = false;
      });
    } else {}
  }

  void updateSearchResults(String query, String fromDate, String toDate) {
    setState(() {
      pendingService.clear(); // Clear existing data
      isLoading = true;
    });

    if (query.isNotEmpty || fromDate.isNotEmpty || toDate.isNotEmpty) {
      // If search query is not empty, perform search
      // Call your API with the search query
      allPendingBookingData(
        searchQuery: query,
        fromDate: fromDate,
        toDate: toDate,
      );
    } else {
      // If search query is empty, load all data
      allPendingBookingData();
    }
  }
}

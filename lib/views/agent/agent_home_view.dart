import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:theinstallers/views/agent/booking_details_view_for_agent.dart';
import 'package:theinstallers/views/agent/service_updated_by_agent_view.dart';
import 'package:upgrader/upgrader.dart';
import '../../controller/agent_controller_provider.dart';
import '../../controller/booking_controller_provider.dart';
import '../../controller/database/database_controller_provider.dart';
import '../../notificationservice/local_notification_service.dart';
import '../../utils/exports.dart';
import '../../widgets/custom_label.dart';
import '../dealer_booking/booking_details_view.dart';
import '../drawer/my_drawar_screen.dart';
import 'photo_editor/form_gallery_view.dart';

class AgentHomeView extends StatefulWidget {
  const AgentHomeView({super.key});

  @override
  State<AgentHomeView> createState() => _AgentHomeViewState();
}

class _AgentHomeViewState extends State<AgentHomeView> {
  String getNotificationText(List<dynamic> serviceAccept) {
    for (var accept in serviceAccept) {
      if (accept['notification_type'] == 'accepted') {
        return 'Accepted';
      }
    }
    return ''; // Return empty string if no 'accepted' notification is found.
  }

  final scrollController = ScrollController();
  final bookingController = BookingControllerProvider();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reason = TextEditingController();
  final TextEditingController _notificationType = TextEditingController();
  final book = AgentControllerProvider();

  List<String> listNotification = [
    "accepted",
    "reached on site",
    "task started",
    "task postponed",
    "not accepted"
  ];
  // String selectval = "accepted";

  int page = 1;
  List pendingService = [];
  bool isLoadingMore = false;
  bool hasMoreData = true;
  bool isLoading = true;

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  @override
  void initState() {
    scrollController.addListener(scrollListener);
    allAssignedServiceData();
    _notificationType.text = 'accepted';
    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        if (message != null) {
          if (message.data['_id'] != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BookingDetailsViewForAgent(
                  serviceId: message.data['_id'],
                  serviceCode: message.data['_serviceCode'],
                ),
              ),
            );
          }
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        if (message.notification != null) {
          LocalNotificationService.createanddisplaynotification(message);

          if (message.data['_id'] != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BookingDetailsViewForAgent(
                  serviceId: message.data['_id'],
                  serviceCode: message.data['_serviceCode'],
                ),
              ),
            );
          }

          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          print("service ID ${message.data['_id']}");
          print("service Code ${message.data['_serviceCode']}");
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        if (message.data['_id'] != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BookingDetailsViewForAgent(
                serviceId: message.data['_id'],
                serviceCode: message.data['_serviceCode'],
              ),
            ),
          );
        }
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    _reason.dispose();
    _notificationType.dispose();
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
          'Agent Home View',
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
              });
              allAssignedServiceData();
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
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : pendingService.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(image: AssetImage(AssetsPath.emptyBox)),
                        CustomLabel(text: Labels.noAssignedService),
                      ],
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
                              page: BookingDetailsViewForAgent(
                                serviceId: pendingService[i]['id'].toString(),
                                serviceCode: pendingService[i]['service_code']
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
                                            PageNavigator(ctx: context).nextPage(
                                                page: ServiceUpdatedByAgentView(
                                              id: pendingService[i]['id']
                                                  .toInt(),
                                              serviceAmount: pendingService[i]
                                                      ['service_charge']
                                                  .toString(),
                                              paymentMode: pendingService[i]
                                                      ['payment_mode_id']
                                                  .toInt(),
                                            ));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                color: AppColors.greenColor,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10))),
                                            height: 35,
                                            width: 35,
                                            child: Icon(
                                              Icons.edit,
                                              color: AppColors.whiteColor,
                                            ),
                                          ),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12, top: 12),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                                decoration: const BoxDecoration(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10))),
                                                height: 60,
                                                width: 60,
                                                child: pendingService[i]
                                                            ['image'] ==
                                                        null
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
                                                //  Text(

                                                // //  '${pendingService[i]['salutation_data'] != null ? pendingService[i]['salutation_data']['salutation_list'] ?? "" : ""} ${pendingService[i]['client_name'] ?? ""}',
                                                // 'sanjay kumar chaudhary narayan paswan',
                                                //   style: AppTextStyle.customerName,
                                                //   overflow: TextOverflow.ellipsis,
                                                //   maxLines: 1,
                                                // ),

                                                Text(
                                                  _truncateText(
                                                      '${pendingService[i]['salutation_data'] != null ? pendingService[i]['salutation_data']['salutation_list'] ?? "" : ""} ${pendingService[i]['client_name'] ?? ""}',
                                                      17),
                                                   
                                                  style:
                                                      AppTextStyle.customerName,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              const SizedBox(height: 15),
                                              SizedBox(
                                                width: MediaQuery.of(context)
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
                                                        if (pendingService[i]
                                                                ['tasktype'] ==
                                                            null)
                                                          const SizedBox()
                                                        else
                                                          Text(
                                                            pendingService[i]
                                                                    ['tasktype']
                                                                ['task_name'],
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
                                                        if (pendingService[i]
                                                                ['date_time'] ==
                                                            null)
                                                          const SizedBox()
                                                        else
                                                          Text(
                                                            pendingService[i]
                                                                ['date_time'],
                                                            style: AppTextStyle
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
                                        if (pendingService[i]['address'] ==
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
                                              style: AppTextStyle.address2,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        const SizedBox(
                                            height: 25,
                                            width: 25,
                                            child: Image(
                                                image: AssetImage(
                                                    AssetsPath.location))),
                                      ],
                                    ),
                                    const SizedBox(
                                        height: 38,
                                        width: 38,
                                        child: Image(
                                          image: AssetImage(AssetsPath.persion),
                                        ))
                                  ],
                                ),

                                //creator

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(width: 10),
                                        Text(
                                          'Created By: ',
                                          style: AppTextStyle.address1,
                                        ),
                                        if (pendingService[i]['service_creator']
                                                ['name'] ==
                                            null)
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                160,
                                            child: Text(
                                              pendingService[i]
                                                          ['service_creator']
                                                      ['company_name']
                                                  .toString(),
                                              style: AppTextStyle.address2,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          )
                                        else
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                160,
                                            child: Text(
                                              pendingService[i]
                                                          ['service_creator']
                                                      ['name']
                                                  .toString(),
                                              style: AppTextStyle.address2,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),

                                //accept

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    acceptButton(
                                      width: 100.0,
                                      height: 30,
                                      text: Labels.notifications,
                                      ontap: () async {
                                        typeOfNotifications(i);
                                        setState(() {});
                                      },
                                    ),
                                    if (getNotificationText(pendingService[i]
                                            ['service_accept']) ==
                                        "Accepted")
                                      Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: AppColors.greenColor,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        width: 100.0,
                                        height: 30,
                                        child: Center(
                                          child: Text(
                                            'Accepted',
                                            style: AppTextStyle.acceptedFont,
                                          ),
                                        ),
                                      ),
                                  ],
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
    );
  }

  //not acceept with reason notification start

  Future typeReasonOfNotAccept(int i) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Form(
              key: _formKey,
              child: SizedBox(
                height: 250,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Text(
                        'Not acceptance reason !',
                        style: AppTextStyle.customerName,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      AppTextFormField(
                        labelText: Labels.reason,
                        extraLabelText: " *",
                        controller: _reason,
                        hintText: Labels.reason,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          return bookingController.validateBlankField(value!);
                        },
                      ),
                      Consumer<AgentControllerProvider>(
                          builder: (context, book, child) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (book.responseMessage != '') {
                            showMessage(
                                message: book.responseMessage,
                                context: context);
                            book.clear();
                          }
                        });

                        return customButton(
                          text: Labels.submit.toUpperCase(),
                          ontap: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                await book.acceptDeclineTask(
                                  serviceId: pendingService[i]['id'].toString(),
                                  reason: _reason.text.trim(),
                                  notificationMessage: 'not accepted',
                                  //  isAccept: '0',
                                  onSuccess: () {
                                    _reason.clear();
                                  },
                                );

                                // ignore: use_build_context_synchronously
                                PageNavigator(ctx: context)
                                    .nextPageOnly(page: const AgentHomeView());
                              } catch (e) {
                                AppErrorSnackBar(context).error(e);
                              }
                            }
                          },
                          context: context,
                          status: book.isLoading,
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  //not acceept with reason notification end

  //type of notification start

  Future typeOfNotifications(int i) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Form(
              key: _formKey,
              child: SizedBox(
                height: 330,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Text(
                        'Send notifications !',
                        style: AppTextStyle.customerName,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: CustomLabel(text: Labels.notifications)),
                      ),
                      Consumer<AgentControllerProvider>(
                        builder: (context, selectedValueProvider, child) {
                          return Container(
                            height: 56,
                            padding: const EdgeInsets.only(left: 6, right: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: AppColors.dropdownBorderColor,
                                  width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButton<String>(
                              style: AppTextStyle.textBoxInputStyle,
                              hint: const Text("Select notificatioin: "),
                              isExpanded: true,
                              underline: const SizedBox(),
                              value: selectedValueProvider.selectedValue,
                              items: listNotification.map((notify) {
                                return DropdownMenuItem<String>(
                                  value: notify,
                                  child: Text(notify),
                                );
                              }).toList(),
                              onChanged: (newNotify) {
                                selectedValueProvider
                                    .updateSelectedValue(newNotify.toString());
                                _notificationType.text = newNotify.toString();
                                print(
                                    'new selected controller value is ${_notificationType.text}');
                              },
                            ),
                          );
                        },
                      ),
                      AppTextFormField(
                        labelText: Labels.reason,
                        // extraLabelText: " *",
                        controller: _reason,
                        hintText: Labels.reason,
                        keyboardType: TextInputType.name,
                        // validator: (value) {
                        //   return bookingController.validateBlankField(value!);
                        // },
                      ),
                      Consumer<AgentControllerProvider>(
                          builder: (context, book, child) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (book.responseMessage != '') {
                            showMessage(
                                message: book.responseMessage,
                                context: context);
                            book.clear();
                          }
                        });

                        return customButton(
                          text: Labels.submit.toUpperCase(),
                          ontap: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                await book.acceptDeclineTask(
                                  serviceId: pendingService[i]['id'].toString(),
                                  reason: _reason.text.trim(),
                                  notificationMessage:
                                      _notificationType.text.trim(),
                                  //  isAccept: '1',
                                  onSuccess: () {
                                    _reason.clear();
                                    _notificationType.clear();
                                  },
                                );

                                // ignore: use_build_context_synchronously
                                PageNavigator(ctx: context)
                                    .nextPageOnly(page: const AgentHomeView());
                              } catch (e) {
                                AppErrorSnackBar(context).error(e);
                              }
                            }
                          },
                          context: context,
                          status: book.isLoading,
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  //type of notification end

  final dio = Dio();
  Future<void> allAssignedServiceData() async {
    String token;
    token = await DatabaseControllerProvider().getToken();
    try {
      const urlUserDetails = AppUrl.allAssignedServiceUri;

      final response = await dio.get(
        '$urlUserDetails?page=$page',
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
      await allAssignedServiceData();
      if (kDebugMode) {
        print('Scroll called one time');
      }
      setState(() {
        isLoadingMore = false;
      });
    } else {}
  }
}

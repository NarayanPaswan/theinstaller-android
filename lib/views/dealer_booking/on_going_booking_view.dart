import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../controller/booking_controller_provider.dart';
import '../../controller/database/database_controller_provider.dart';
import '../../utils/exports.dart';
import '../../widgets/custom_label.dart';
import 'on_going_booking_details_view.dart';

class OnGoingBookingView extends StatefulWidget {
  const OnGoingBookingView({super.key});

  @override
  State<OnGoingBookingView> createState() => _OnGoingBookingViewState();
}

class _OnGoingBookingViewState extends State<OnGoingBookingView> {
  final scrollController = ScrollController();
  final bookingController = BookingControllerProvider();

  int page = 1;
  List onGoingService = [];
  bool isLoadingMore = false;
  bool hasMoreData = true;
  bool isLoading = true;

  @override
  void initState() {
    scrollController.addListener(scrollListener);
    allPendingBookingData();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          Labels.onGoingBooking,
          style: AppTextStyle.ongoingBooking,
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : onGoingService.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(image: AssetImage(AssetsPath.emptyBox)),
                      CustomLabel(text: Labels.noOnGoingService),
                    ],
                  ),
                )
              : ListView.builder(
                  controller: scrollController,
                  itemCount:
                      isLoadingMore ? onGoingService.length + 1 : onGoingService.length,
                  itemBuilder: (context, i) {
                    if (i < onGoingService.length) {
                     return GestureDetector(
                       onTap: () {
                    PageNavigator(ctx: context).nextPage(
                      page: OnGoingBookingDetailsView (
                    serviceId: onGoingService[i]['id'].toString(),
                    serviceCode: onGoingService[i]['service_code'].toString(),
                                   
                         
                      ),
                        );
                      },
                       child: Card(
                              color: AppColors.whiteColor,
                              
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
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
                                                  child: onGoingService[i]['image'] ==
                                                      null
                                                      ? const Image(
                                                      image: AssetImage(
                                                          AssetsPath
                                                              .searchImage))
                                                      : Image(
                                                      image: NetworkImage(
                                                          AppUrl.imageUrl +
                                                              onGoingService[i]['image']))),
                                            ),
                                            const SizedBox(width: 15),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                if(onGoingService[i]['client_name'] ==
                                                    null)
                                                  const SizedBox()
                                                else
                                                  Text(
                                                    // onGoingService[i]['client_name']
                                                    //     .toString(),
                                                  //  '${onGoingService[i]['salutation_data'] != null ? onGoingService[i]['salutation_data']['salutation_list'] ?? "" : ""} ${onGoingService[i]['client_name'] ?? ""}', 
                                                  _truncateText(
                                                      '${onGoingService[i]['salutation_data'] != null ? onGoingService[i]['salutation_data']['salutation_list'] ?? "" : ""} ${onGoingService[i]['client_name'] ?? ""}', 
                                                      30),
                                                    style: AppTextStyle
                                                        .customerName,
                                                   overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,     
                                                  ),
                                                const SizedBox(height: 15),
                                                SizedBox(
                                                  width:
                                                  MediaQuery.of(context).size.width - 100,
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
                                                          if(onGoingService[i]['tasktype'] ==
                                                              null)
                                                            const SizedBox()
                                                          else
                                                            Text(
                                                              onGoingService[i]['tasktype']['task_name'],
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
                                                          if(onGoingService[i]['date_time'] ==
                                                              null)
                                                            const SizedBox()
                                                          else
                                                            Text(
                                                              onGoingService[i]['date_time'],
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
                                          Text('Address: ',
                                              style: AppTextStyle.address1,
                                              ),
                                          if(onGoingService[i]['address'] == null)
                                            const SizedBox()
                                          else
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width - 160,
                                              child: Text(onGoingService[i]['address']
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
                                                      AssetsPath.location)
                                                      )
                                                      ),
                                                
                                                      
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
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const SizedBox(width: 10),
                                          Text('Created By: ',
                                              style: AppTextStyle.address1,
                                              ),
                                          if(onGoingService[i]['service_creator']['name'] == null)
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width - 160,
                                              child: Text(onGoingService[i]['service_creator']['company_name']
                                                  .toString(),
                                                  style: AppTextStyle.address2,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  ),
                                            )
                                          else
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width - 160,
                                              child: Text(onGoingService[i]['service_creator']['name']
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

                                  const SizedBox(height: 10,),
                     
                                  
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
                          SizedBox(height: 40,),
                        ],
                      );
                    }
                  },
                ),
   
    );
  }
  
  final dio = Dio();
  Future<void> allPendingBookingData() async {
    String token;
    token = await DatabaseControllerProvider().getToken();
    try {

      const urlUserDetails = AppUrl.allOnGoingBookingUri;

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
        onGoingService = onGoingService + json;
        hasMoreData = response.data['items']['next_page_url'] != null;
        isLoading = false;

      });

    } catch (error) {
      setState(() {
        isLoading = false; // Set isLoading to false in case of error too.
      });
      if (kDebugMode) {
        print('Error fetching service details: $error');
      }
      return;
    }
  }
  Future<void>  scrollListener() async {
    if(isLoadingMore || !hasMoreData) return;
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent){
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
    }
    else {
    }
  }
}


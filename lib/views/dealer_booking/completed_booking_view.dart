import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:theinstallers/views/dealer_booking/booking_completed_details_view.dart';
import '../../controller/booking_controller_provider.dart';
import '../../controller/database/database_controller_provider.dart';
import '../../utils/exports.dart';
import '../../widgets/custom_label.dart';
import 'package:intl/intl.dart';

class CompletedBookingView extends StatefulWidget {
  const CompletedBookingView({super.key});

  @override
  State<CompletedBookingView> createState() => _CompletedBookingViewState();
}

class _CompletedBookingViewState extends State<CompletedBookingView> {
  final scrollController = ScrollController();
  final bookingController = BookingControllerProvider();
  TextEditingController searchController = TextEditingController();
   final TextEditingController _fromDate = TextEditingController();
   final TextEditingController _toDate = TextEditingController();

  int page = 1;
  List completedService = [];
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
    searchController.dispose();
    _fromDate.dispose();
    _toDate.dispose();
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
          Labels.completedBooking,
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
                completedService = [];
                page = 1;
                isLoadingMore = false;
                hasMoreData = true;
                searchController.text="";
                _fromDate.text="";
                _toDate.text="";
              });
              allPendingBookingData();
              
            },
          ),
        ],
      ),
      body: Column(
        children: [

          Row(
            children: [
               Expanded(
                child: 
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: 
                  AppTextFormField(
                  readOnly: true,
                  controller: _fromDate,
                  suffixIcon: Icons.calendar_today_rounded,
                  hintText: 'dd/MM/yyyy',
                  onTap: () async {
                     DateTime? selectedFromDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100)
                      );
                      if (selectedFromDate != null) {
                        _fromDate.text = DateFormat('dd/MM/yyyy').format(selectedFromDate);
                         print(DateFormat('dd/MM/yyyy').format(selectedFromDate));
                      }
                  },
                 
                ),
                ),

               
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: 
               
                  AppTextFormField(
                  readOnly: true,
                  controller: _toDate,
                  suffixIcon: Icons.calendar_today_rounded,
                  hintText: 'dd/MM/yyyy',
                  onTap: () async {
                     DateTime? selectedToDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100)
                      );
                      if (selectedToDate != null) {
                        _toDate.text = DateFormat('dd/MM/yyyy').format(selectedToDate);
                         print(DateFormat('dd/MM/yyyy').format(selectedToDate));
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
                  child: 
                
                AppTextFormField(
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
                : completedService.isEmpty
                    ? const SingleChildScrollView(
                      child:  Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(image: AssetImage(AssetsPath.emptyBox)),
                              CustomLabel(text: Labels.noCompletedService),
                            ],
                          ),
                        ),
                    )
                    : ListView.builder(
                        controller: scrollController,
                        itemCount:
                            isLoadingMore ? completedService.length + 1 : completedService.length,
                        itemBuilder: (context, i) {
                          if (i < completedService.length) {
                           return GestureDetector(
                             onTap: () {
                          PageNavigator(ctx: context).nextPage(
                            page: BookingCompletedDetailsView (
                          serviceId: completedService[i]['id'].toString(),
                          serviceCode: completedService[i]['service_code'].toString(),
                                         
                               
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
                                                        child: completedService[i]['image'] ==
                                                            null
                                                            ? const Image(
                                                            image: AssetImage(
                                                                AssetsPath
                                                                    .searchImage))
                                                            : Image(
                                                            image: NetworkImage(
                                                                AppUrl.imageUrl +
                                                                    completedService[i]['image']))),
                                                  ),
                                                  const SizedBox(width: 15),
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      // if(completedService[i]['client_name'] ==
                                                      //     null)
                                                      //   const SizedBox()
                                                      // else
                                                        // Text(
                                                        //   completedService[i]['client_name']
                                                        //       .toString(),
                                                        //   style: AppTextStyle
                                                        //       .customerName,
                                                        //       overflow: TextOverflow.ellipsis,
                                                        //       maxLines: 1,
                                                        // ),
                                                      
                                                           Text(
                                                          
                                                          // '${completedService[i]['salutation_data'] != null ? completedService[i]['salutation_data']['salutation_list'] ?? "" : ""} ${completedService[i]['client_name'] ?? ""}',
                                                          _truncateText(
                                                      '${completedService[i]['salutation_data'] != null ? completedService[i]['salutation_data']['salutation_list'] ?? "" : ""} ${completedService[i]['client_name'] ?? ""}',
                                                      
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
                                                                if(completedService[i]['tasktype'] ==
                                                                    null)
                                                                  const SizedBox()
                                                                else
                                                                  Text(
                                                                    completedService[i]['tasktype']['task_name'],
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
                                                                if(completedService[i]['date_time'] ==
                                                                    null)
                                                                  const SizedBox()
                                                                else
                                                                  Text(
                                                                    completedService[i]['date_time'],
                                                                    style:
                                                                    AppTextStyle
                                                                        .time,
                                                                  ),
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
                                       const SizedBox(height: 5),
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
                                                if(completedService[i]['address'] == null)
                                                  const SizedBox()
                                                else
                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width - 160,
                                                    child: Text(completedService[i]['address']
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
                           
                                        // creator
                           
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
                                                if (completedService[i]['service_creator'] != null)     
                                                if(completedService[i]['service_creator']['name'] == null)
                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width - 160,
                                                    child: 
                                                    Text((completedService[i]['service_creator']['company_name'] ?? '').toString(),
                                                        style: AppTextStyle.address2,
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        ),
                                                  )
                                                else
                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width - 160,
                                                    child: 
                                                    // Text(completedService[i]['service_creator']['name']
                                                    //     .toString(),
                                                    Text((completedService[i]['service_creator']['name'] ?? '').toString(),
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
          ),
        ],
      ),
   
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
      const urlUserDetails = AppUrl.allCompletedBookingUri;

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
        completedService = completedService + json;
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

   void updateSearchResults(String query, String fromDate, String toDate) {
    setState(() {
      completedService.clear(); // Clear existing data
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


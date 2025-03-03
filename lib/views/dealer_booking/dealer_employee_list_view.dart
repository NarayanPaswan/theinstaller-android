import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../controller/database/database_controller_provider.dart';
import '../../utils/exports.dart';
import '../../widgets/custom_label.dart';




class DealerEmployeeListView extends StatefulWidget {
  const DealerEmployeeListView({super.key});

  @override
  State<DealerEmployeeListView> createState() => _DealerEmployeeListViewState();
}

class _DealerEmployeeListViewState extends State<DealerEmployeeListView> {
  final scrollController = ScrollController();
  
  int page = 1;
  List dealerEmployee = [];
  bool isLoadingMore = false;
  bool hasMoreData = true;
  bool isLoading = true;

  @override
  void initState() {
    scrollController.addListener(scrollListener);
    allDealerEmployeeData();

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
  
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          Labels.dealerEmployee,
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
              dealerEmployee = [];
              page = 1;
              isLoadingMore = false;
              hasMoreData = true;
              });
              allDealerEmployeeData(); 
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : dealerEmployee.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(image: AssetImage(AssetsPath.emptyBox)),
                      CustomLabel(text: Labels.noPendingService),
                    ],
                  ),
                )
              : ListView.builder(
                  controller: scrollController,
                  itemCount:
                      isLoadingMore ? dealerEmployee.length + 1 : dealerEmployee.length,
                  itemBuilder: (context, i) {
                    if (i < dealerEmployee.length) {
                     return Card(
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
                                                child: dealerEmployee[i]['avatar'] ==
                                                    null
                                                    ? const Image(
                                                    image: AssetImage(
                                                        AssetsPath
                                                            .searchImage))
                                                    : Image(
                                                    image: NetworkImage(
                                                        AppUrl.profileUrl +
                                                            dealerEmployee[i]['avatar']))),
                                          ),
                                          const SizedBox(width: 15),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              if(dealerEmployee[i]['name'] ==
                                                  null)
                                                const SizedBox()
                                              else
                                                Text(
                                                  dealerEmployee[i]['name']
                                                      .toString(),
                                                  style: AppTextStyle
                                                      .customerName,
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
                                                              .email,
                                                          color: AppColors
                                                              .black26Color,
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        if(dealerEmployee[i]['email'] ==
                                                            null)
                                                          const SizedBox()
                                                        else
                                                          Text(
                                                            dealerEmployee[i]['email'],
                                                            style: AppTextStyle.address2,
                                                          ),
                                                      ],
                                                    ),
                                                    // SizedBox(width: 35),
                                                   
                                                  ],
                                                ),
                                              ),

                                              
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
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
                                        const SizedBox(width: 8),
                                        // Text('Mobile number: ',
                                        //     style: AppTextStyle.address1,
                                        //     ),
                                         Icon(
                                                          Icons
                                                              .phone,
                                                          color: AppColors
                                                              .black26Color,
                                                        ),
                                      SizedBox(width: 10,),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width - 160,
                                            child: Text(dealerEmployee[i]['mobile_number']
                                                .toString(),
                                                style: AppTextStyle.address2,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                ),
                                          )
                                       
                                    
                                              
                                                    
                                      ],
                                    ),
                                   
                                  ],
                                ),
                               Column(
                                    mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      
                                     
                                  
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                             padding: const EdgeInsets.only(left: 8.0),
                                            child: Text(
                                                                            Labels.address,
                                                                            style: AppTextStyle.address1,
                                                                          ),
                                          ),
                                        ),
                             
                              Align(
                                  alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    dealerEmployee[i]['address']
                                                .toString(),
                                    // snapshot.data?.items?.first.remarks ?? '',
                                    style: AppTextStyle.address2,
                                  ),
                                ),
                              ),
                                  
                                    ],
                                  ),
                                          
                                //creator
                                          
                                
                                          
                                
                              ],
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
  Future<void> allDealerEmployeeData() async {
    String token;
    token = await DatabaseControllerProvider().getToken();
    try {

      const urlUserDetails = AppUrl.dealerEmployeeListUri;

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
        dealerEmployee = dealerEmployee + json;
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
  Future<void>  scrollListener() async {
    if(isLoadingMore || !hasMoreData) return;
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent){
      setState(() {
        isLoadingMore = true;
      });
      page = page + 1;
      await allDealerEmployeeData();
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


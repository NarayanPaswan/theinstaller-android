import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../controller/database/database_controller_provider.dart';
import '../../utils/exports.dart';


final scrollController = ScrollController();

class AllPendingBooking extends StatefulWidget {
  const AllPendingBooking({Key? key}) : super(key: key);

  @override
  State<AllPendingBooking> createState() => _AllPendingBookingState();
}

class _AllPendingBookingState extends State<AllPendingBooking> {

  final TextEditingController _searchController = TextEditingController();

  int page = 1;
  List student = [];
  bool isLoadingMore = false;
  bool hasMoreData = true;


  @override
  void initState() {
    scrollController.addListener(scrollListener);
    allPendingBookingData();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          Labels.allPendingBooking,
          style: AppTextStyle.ongoingBooking,
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.whiteColor,
          ),
        ),
        actions: const [
          SizedBox(
              height: 25,
              width: 25,
              child: Image(image: AssetImage(AssetsPath.drawericon))),
          SizedBox(width: 20)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                color: AppColors.primaryColor,
              ),
              height: 110,
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            color: AppColors.whiteColor,
                          ),
                          height: 55,
                          width: 400,
                          child: Center(
                            child: Theme(
                              data: ThemeData(
                                colorScheme:
                                Theme.of(context).colorScheme.copyWith(
                                  primary: AppColors.primaryColor,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: TextFormField(
                                  controller: _searchController,
                                  onChanged: (String? value) {
                                  },
                                  decoration: InputDecoration(
                                    // hintStyle: kBodyText12wBold(textColor),
                                      border: InputBorder.none,
                                      suffixIcon: Icon(
                                        Icons.search,
                                        color: AppColors.blackColor,
                                      ),
                                      // suffixIconColor: textColor,
                                      hintStyle: AppTextStyle.searchTextStyle,
                                      hintText: Labels.ongoingBookingSearch),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // addHorihontalSpace(10),
                        // addHorihontalSpace(10)
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 60,
                    width: 250,
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: const BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: Row(
                        children: [
                          const SizedBox(width: 20),
                          Icon(
                            Icons.list_alt_outlined,
                            color: AppColors.whiteColor,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            Labels.categorySettings,
                            style: AppTextStyle.categorySetting,
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: AppColors.blackColor, shape: BoxShape.circle),
                      child: const Center(
                          child: Icon(
                            Icons.sort,
                            color: Colors.white,
                          ))),
                  Text(
                    Labels.sort,
                    style: AppTextStyle.sort,
                  ),
                  const SizedBox(height: 15)
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 530,
              child: student.isEmpty ?
              const Center(child: CircularProgressIndicator()):
              ListView.builder(
                  controller: scrollController,
                  itemCount: isLoadingMore ? student.length + 1 : student.length,
                  itemBuilder: (context, i) {
                    if ( i < student.length )
                    {
                      return SizedBox(
                        height: 160,
                        child: Card(
                          color: AppColors.whiteColor,
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Positioned(
                                      top: 5,
                                      right: 5,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: AppColors.greenColor,
                                            borderRadius:
                                            const BorderRadius.all(
                                                Radius.circular(
                                                    10))),
                                        height: 35,
                                        width: 35,
                                        child: Icon(
                                          Icons.account_tree_outlined,
                                          color: AppColors.whiteColor,
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12, top: 12),
                                    child: Row(
                                      children: [
                                        Container(
                                            decoration: const BoxDecoration(
                                                borderRadius:
                                                BorderRadius.all(
                                                    Radius.circular(
                                                        10))),
                                            height: 60,
                                            width: 60,
                                            child: student[i]['image'] ==
                                                null
                                                ? const Image(
                                                image: AssetImage(
                                                    AssetsPath
                                                        .searchImage))
                                                : Image(
                                                image: NetworkImage(
                                                    AppUrl.imageUrl +
                                                        student[i]['image']))),
                                        const SizedBox(width: 15),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            if(student[i]['client_name'] ==
                                                null)
                                              const SizedBox()
                                            else
                                              Text(
                                                student[i]['client_name']
                                                    .toString(),
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
                                                      if(student[i]['tasktype'] ==
                                                          null)
                                                        const SizedBox()
                                                      else
                                                        Text(
                                                          student[i]['tasktype']['task_name'],
                                                          style: AppTextStyle
                                                              .meddileStyle,
                                                        ),
                                                    ],
                                                  ),
                                                  // SizedBox(width: 35),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Time: ',
                                                        style: AppTextStyle
                                                            .meddileStyle,
                                                      ),
                                                      if(student[i]['date_time'] ==
                                                          null)
                                                        const SizedBox()
                                                      else
                                                        Text(
                                                          student[i]['date_time'],
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
                                          style: AppTextStyle.address1),
                                      if(student[i]['address'] == null)
                                        const SizedBox()
                                      else
                                        Text(student[i]['address']
                                            .toString(),
                                            style: AppTextStyle.address2),
                                      const SizedBox(
                                          height: 25,
                                          width: 25,
                                          child: Image(
                                              image: AssetImage(
                                                  AssetsPath.location)))
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
                            ],
                          ),
                        ),
                      );
                    }
                    else {
                      return const Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Center(child: CircularProgressIndicator()),
                          SizedBox(height: 40,)
                        ],
                      );
                    }
                  }),

            ),
            // if(!hasMoreData)
            //   const Text("No more data avaible"),

            // }),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        child: Icon(
          Icons.add,
          color: AppColors.whiteColor,
        ),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
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
      ),
    );
  }

  final dio = Dio();
  Future<void> allPendingBookingData() async {
    String token;
    token = await DatabaseControllerProvider().getToken();
    try {

      const urlUserDetails = AppUrl.allPendingBookingUri;

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
        print('$urlUserDetails?page=$page');
      }

      final json = response.data['items']['data'];
      setState(() {
        student = student + json;
        hasMoreData = response.data['items']['next_page_url'] != null;

      });

    } catch (error) {
      // Handle error
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

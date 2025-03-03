import 'package:theinstallers/views/dealer_booking/downaload_form_image_dialog.dart';
import 'package:theinstallers/views/dealer_booking/download_site_image_dialog.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../controller/booking_controller_provider.dart';
import '../../model/booking_completed_details_model.dart';
import '../../utils/exports.dart';
import 'package:full_screen_image/full_screen_image.dart';

class BookingCompletedDetailsView extends StatefulWidget {
  String serviceId;
  String serviceCode;
  BookingCompletedDetailsView(
      {super.key, required this.serviceId, required this.serviceCode});

  @override
  State<BookingCompletedDetailsView> createState() =>
      _BookingCompletedDetailsViewState();
}

class _BookingCompletedDetailsViewState
    extends State<BookingCompletedDetailsView> {
  final bookingController = BookingControllerProvider();
  String roleId = '';

  @override
  void initState() {
    print('Your completed service id is: ${widget.serviceId}');
    print('Your completed service code is: ${widget.serviceCode}');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          '${Labels.serviceCodeIs} ${widget.serviceCode}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyle.ongoingBooking,
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future:
                bookingController.getCompletedServiceDetails(widget.serviceId),
            builder: (context,
                AsyncSnapshot<BookingCompletedDetailsModel> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                if (snapshot.data == null || snapshot.data!.items!.isEmpty) {
                  return const Center(
                    child: Text("Service detail not available !"),
                  );
                }
                var item = snapshot.data!.items!.first;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 80,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          // color: Colors.red,
                          elevation: 5.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                  height: 48,
                                  width: 48,
                                  decoration: BoxDecoration(
                                      color: AppColors.grey,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  child: const Image(
                                      image: AssetImage(AssetsPath.persion)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                100,
                                        child: Text(
                                          // snapshot.data?.items?.first
                                          //         .clientName ??
                                          //     '',
                                          '${snapshot.data?.items?.first.salutationData?.salutationList ?? ""} ${snapshot.data?.items?.first.clientName ?? ""}',
                                          style:
                                              AppTextStyle.customerNameDetail,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      
                                    
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    //customer address
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, bottom: 8.0),
                      child: Card(
                        elevation: 5.0,
                        child: IntrinsicHeight(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  100,
                                              child: Row(
                                                children: [
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  const SizedBox(
                                                      height: 16,
                                                      width: 16,
                                                      child: Image(
                                                          image: AssetImage(
                                                              'assets/images/email.png'))),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      snapshot
                                                              .data
                                                              ?.items
                                                              ?.first
                                                              .clientEmailAddress ??
                                                          '',
                                                      style: AppTextStyle
                                                          .customerNameDetail,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  100,
                                              child: GestureDetector(
                                                 onTap: () async {
                                                      String mobileNumber = snapshot.data?.items?.first.clientMobileNumber ?? '';
                                                      String telurl = 'tel:$mobileNumber';
                                                    if (await canLaunchUrlString(telurl)) {
                                                      launchUrlString(telurl);
                                                    } else {
                                                      print("can't launch $telurl");
                                                    }
                                                  },
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons
                                                          .mobile_screen_share_outlined,
                                                      color: Colors.blueAccent,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              right: 8.0,
                                                              bottom: 8.0),
                                                      child: Text(
                                                        snapshot
                                                                .data
                                                                ?.items
                                                                ?.first
                                                                .clientMobileNumber ??
                                                            '',
                                                        style: AppTextStyle
                                                            .customerNameDetail,
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 13.0, right: 8.0, bottom: 8.0),
                                  child: Text(
                                    "${snapshot.data?.items?.first.address ?? ''} ${'. '} ${snapshot.data?.items?.first.landmark ?? ''}",
                                    style: AppTextStyle.customerNameDetail,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    //booking details
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, bottom: 8.0),
                      child: Card(
                        elevation: 5.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 48,
                                    width: 48,
                                    decoration: BoxDecoration(
                                        color: AppColors.grey,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: const Image(
                                        image:
                                            AssetImage(AssetsPath.searchImage)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                100,
                                            child: Row(
                                              children: [
                                                Text(
                                                  Labels.postedBy,
                                                  style: AppTextStyle
                                                      .veryGoodDetail,
                                                ),
                                                Text(
                                                  snapshot
                                                          .data
                                                          ?.items
                                                          ?.first
                                                          .serviceCreator!
                                                          .name ??
                                                      '',
                                                  style: AppTextStyle
                                                      .customerNameDetail,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            )),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                               Labels.bookingDate,
                                              style:
                                                  AppTextStyle.veryGoodDetail,
                                            ),
                                            Text(
                                              snapshot.data?.items?.first
                                                      .dateTime ??
                                                  '',
                                              style: AppTextStyle
                                                  .customerNameDetail,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                snapshot.data?.items?.first.tasktype!
                                        .taskName ??
                                    '',
                                style: AppTextStyle.tasktype,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                Labels.productType,
                                style: AppTextStyle.veryGoodDetail,
                              ),
                              Text(
                                 snapshot.data?.items?.first.typeOfProduct?.productList ?? '',    
                                style: AppTextStyle.customerNameDetail,
                              ),
                              // ----------sub prodduct try start-----
                              if (item.subProducts != null && item.subProducts!.isNotEmpty)
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                Labels.subProductType,
                                style: AppTextStyle.veryGoodDetail,
                              ),
                            if (item.subProducts != null && item.subProducts!.isNotEmpty)
                    ...item.subProducts!.map((subProduct) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Text(
                            '${subProduct.subProductList}',
                            style: AppTextStyle.customerNameDetail,
                          ),
                        )).toList(),
                              
                              // ----------sub prodduct try end-----
                              const SizedBox(
                                height: 10,
                              ),

                              Text(
                              Labels.typeOfMaterial,
                                style: AppTextStyle.veryGoodDetail,
                              ),
                              Text(
                                snapshot.data?.items?.first.typeOfMaterial ??
                                    '',
                                style: AppTextStyle.customerNameDetail,
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              Text(
                                Labels.quantities,
                                style: AppTextStyle.veryGoodDetail,
                              ),
                              Text(
                                snapshot.data?.items?.first.quantity ??
                                    '',
                                style: AppTextStyle.customerNameDetail,
                              ),
                              const SizedBox(height: 15),
                              Divider(
                                thickness: 1,
                                color: AppColors.black12Color,
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              Row(
                                children: [
                                  Text(
                                    Labels.paymentModes,
                                    
                                    style: AppTextStyle.veryGoodDetail,
                                  ),
                                  Text(
                                    snapshot.data?.items?.first.paymentMode
                                            ?.paymentMethodName ??
                                        '',
                                    style: AppTextStyle.customerNameDetail,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              // if (roleId != '3')
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                 Labels.remark,
                                style: AppTextStyle.veryGoodDetail,
                              ),
                              Text(
                                snapshot.data?.items?.first.remarks ?? '',
                                style: AppTextStyle.customerNameDetail,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                 Labels.note,
                                style: AppTextStyle.veryGoodDetail,
                              ),
                              Text(
                                snapshot.data?.items?.first.notes ?? '',
                                style: AppTextStyle.customerNameDetail,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    /* Assigned Agent */

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 5.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            // mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Assigned Agent",
                                style: AppTextStyle.veryGoodDetail,
                              ),
                              // Use ListView.builder to create multiple cards for each agent update
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data?.items?.first
                                        .taskUpadatedByAgent?.length ??
                                    0,
                                itemBuilder: (context, index) {
                                  final agentUpdate = snapshot.data?.items
                                      ?.first.taskUpadatedByAgent?[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Card(
                                      elevation: 3.0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Remarks: ",
                                              style:
                                                  AppTextStyle.veryGoodDetail,
                                            ),
                                            Text(
                                              agentUpdate?.remarks ?? '',
                                              style: AppTextStyle
                                                  .customerNameDetail,
                                            ),
                                            const SizedBox(height: 16.0),
                                            Text(
                                              "Form Images: ",
                                              style:
                                                  AppTextStyle.veryGoodDetail,
                                            ),
                                            // Display form images for this agent update
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: agentUpdate
                                                      ?.formImageData?.length ??
                                                  0,
                                              itemBuilder: (context, index) {
                                                final image = agentUpdate
                                                    ?.formImageData?[index];
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0,
                                                              bottom: 8.0),
                                                      child: SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            3,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: GestureDetector(
                                                           onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              FullScreenWidget(
                                                            disposeLevel:
                                                                DisposeLevel
                                                                    .High,
                                                            child:
                                                                Image.network(
                                                              AppUrl.imageUrl +
                                                                  image
                                                                      .formImageFile
                                                                      .toString(),
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                          child: Image.network(
                                                            AppUrl.imageUrl +
                                                                image!
                                                                    .formImageFile
                                                                    .toString(),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                   
                                                    Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text(
                                                        "Comment: ",
                                                        style: AppTextStyle
                                                            .veryGoodDetail,
                                                      ),
                                                    ),
                                                    Text(
                                                      image.caption.toString(),
                                                      style: AppTextStyle
                                                          .customerNameDetail,
                                                    ),
                                                     IconButton(
                                                          onPressed: () {
                                                            // downloadImage(AppUrl.imageUrl + image.formImageFile.toString());
                                                            showDialog(
                                                              context: context,
                                                              builder: (context) => DownloadProgressDialog(
                                                                  imageUrl: AppUrl
                                                                          .imageUrl +
                                                                      image
                                                                          .formImageFile
                                                                          .toString()),
                                                            );
                                                          },
                                                          icon: const Icon(
                                                            Icons.download,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                    const SizedBox(
                                                        height: 16.0),
                                                  ],
                                                );
                                              },
                                            ),
                                            

                                            const SizedBox(height: 16.0),
                                            Text(
                                              "Site Images: ",
                                              style:
                                                  AppTextStyle.veryGoodDetail,
                                            ),

                                            const SizedBox(
                                              height: 5,
                                            ),

                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                             itemCount: agentUpdate
                                                      ?.siteImageData?.length ??
                                                  0,
                                              itemBuilder: (context, index) {
                                                final image = agentUpdate
                                                    ?.siteImageData?[index];
                                                return Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0,
                                                              bottom: 8.0),
                                                      child: SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            3,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: GestureDetector(
                                                           onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              FullScreenWidget(
                                                            disposeLevel:
                                                                DisposeLevel
                                                                    .High,
                                                            child:
                                                                Image.network(
                                                              AppUrl.imageUrl +
                                                                  image
                                                                      .siteImageFile
                                                                      .toString(),
                                                              fit: BoxFit
                                                                  .contain,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                          child: Image.network(
                                                            AppUrl.imageUrl +
                                                                image!
                                                                    .siteImageFile
                                                                    .toString(),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                   
                                                    Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text(
                                                        "Comment: ",
                                                        style: AppTextStyle
                                                            .veryGoodDetail,
                                                      ),
                                                    ),
                                                    Text(
                                                      image.caption.toString(),
                                                      style: AppTextStyle
                                                          .customerNameDetail,
                                                    ),
                                                     IconButton(
                                                          onPressed: () {
                                                            // downloadImage(AppUrl.imageUrl + image.formImageFile.toString());
                                                            showDialog(
                                                              context: context,
                                                              builder: (context) => DownloadProgressDialog(
                                                                  imageUrl: AppUrl
                                                                          .imageUrl +
                                                                      image
                                                                          .siteImageFile
                                                                          .toString()),
                                                            );
                                                          },
                                                          icon: const Icon(
                                                            Icons.download,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                    const SizedBox(
                                                        height: 16.0),
                                                  ],
                                                );
                                              },
                                            ),


                                            
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }
}

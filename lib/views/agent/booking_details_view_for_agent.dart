import 'package:full_screen_image/full_screen_image.dart';
import 'package:geocoding/geocoding.dart';
import 'package:theinstallers/views/agent/agent_home_view.dart';
import 'package:theinstallers/views/dealer_booking/downaload_form_image_dialog.dart';
import 'package:theinstallers/views/dealer_booking/downaload_video_dialog.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:video_player/video_player.dart';
import '../../controller/agent_controller_provider.dart';
import '../../controller/booking_controller_provider.dart';
import '../../controller/database/database_controller_provider.dart';
import '../../model/service_details_model.dart';
import '../../utils/exports.dart';
import 'dart:async';

class BookingDetailsViewForAgent extends StatefulWidget {
  String serviceId;
  String serviceCode;
  BookingDetailsViewForAgent(
      {super.key, required this.serviceId, required this.serviceCode});

  @override
  State<BookingDetailsViewForAgent> createState() =>
      _BookingDetailsViewForAgentState();
}

class _BookingDetailsViewForAgentState
    extends State<BookingDetailsViewForAgent> {
  final bookingController = BookingControllerProvider();
  final intallerController = AgentControllerProvider();
   List<VideoPlayerController> _videoControllers = [];


  String roleId = '';
  // Add a boolean flag to control the visibility of "Calling..." text
  bool callingInProgress = false;
  Timer? callTimer;

  @override
  void dispose() {
     for (var controller in _videoControllers) {
      controller.dispose();
    }
    callTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    print('Your service id: ${widget.serviceId}');
    // print('Your service code is: ${widget.serviceCode}');
    _fetchRoleId();
    super.initState();
  }

  Future<void> _fetchRoleId() async {
    String roleId = await DatabaseControllerProvider().getRoleId();
    setState(() {
      this.roleId = roleId;
    });
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
            future: bookingController.getServiceDetails(widget.serviceId),
            builder: (context, AsyncSnapshot<ServiceDetailsModel> snapshot) {
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
                  // Initialize video controllers
              if (_videoControllers.isEmpty) {
                for (var video in item.serviceVideoData ?? []) {
                  _videoControllers.add(VideoPlayerController.network(AppUrl.videoUrl + video.videoFile!)
                    ..initialize().then((_) {
                      setState(() {});
                    }));
                }
              }
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        // height: 80,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          // color: Colors.red,
                          elevation: 5.0,
                          child: IntrinsicHeight(
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
                                                "Cust. Name:",
                                                style:
                                                    AppTextStyle.veryGoodDetail,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '${snapshot.data?.items?.first.salutationData?.salutationList ?? ""} ${snapshot.data?.items?.first.clientName ?? ""}',
                                                  style: AppTextStyle
                                                      .customerNameDetail,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // add email

                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            // const SizedBox(
                                            //             width: 5,
                                            //           ),
                                            const SizedBox(
                                                height: 16,
                                                width: 16,
                                                child: Image(
                                                    image: AssetImage(
                                                        'assets/images/email.png'))),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Text(
                                                snapshot.data?.items?.first
                                                        .clientEmailAddress ??
                                                    '',
                                                style: AppTextStyle
                                                    .customerNameDetail,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
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
                                          // SizedBox(
                                          //     width: MediaQuery.of(context)
                                          //             .size
                                          //             .width -
                                          //         100,
                                          //     child: Row(
                                          //       children: [
                                          //         const SizedBox(
                                          //           width: 5,
                                          //         ),
                                          //         const SizedBox(
                                          //             height: 16,
                                          //             width: 16,
                                          //             child: Image(
                                          //                 image: AssetImage(
                                          //                     'assets/images/email.png'))),
                                          //         Padding(
                                          //           padding:
                                          //               const EdgeInsets.all(
                                          //                   8.0),
                                          //           child: Text(
                                          //             snapshot
                                          //                     .data
                                          //                     ?.items
                                          //                     ?.first
                                          //                     .clientEmailAddress ??
                                          //                 '',
                                          //             style: AppTextStyle
                                          //                 .customerNameDetail,
                                          //             maxLines: 1,
                                          //             overflow:
                                          //                 TextOverflow.ellipsis,
                                          //           ),
                                          //         ),
                                          //       ],
                                          //     ),
                                          //     ),

                                          const SizedBox(
                                            height: 5,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                100,
                                            child: Row(
                                              
                                              children: [
                                                
                                                const Icon(
                                                  Icons
                                                      .mobile_screen_share_outlined,
                                                  color: Colors.blueAccent,
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 8.0,
                                                      right: 8.0,
                                                    ),
                                                    child: Text(
                                                      'Click to Call Customer:',
                                                      style: AppTextStyle
                                                          .customerNameDetail,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),

                                           if ( snapshot.data?.items?.first.messageNintyOneStatus
                                    == 'active' )
                                                //try calling start
                                                callingInProgress
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Text(
                                                            "Calling...",
                                                            style: AppTextStyle
                                                                .callNow,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ],
                                                      )
                                                    : GestureDetector(
                                                        onTap: () async {
                                                          try {
                                                            setState(() {
                                                              callingInProgress =
                                                                  true; // Set flag to true when calling starts
                                                            });

                                                            // Start the timer for 15 seconds
                                                            callTimer = Timer(
                                                                const Duration(
                                                                    seconds:
                                                                        20),
                                                                () {
                                                              setState(() {
                                                                callingInProgress =
                                                                    false; // Set flag to false when timer expires
                                                              });
                                                            });
                                                            await intallerController
                                                                .installerCallingTheCustomer(
                                                              installerNo:
                                                                  await DatabaseControllerProvider()
                                                                      .getInstallerMobileNo(),
                                                              customerNo: snapshot
                                                                      .data
                                                                      ?.items
                                                                      ?.first
                                                                      .clientMobileNumber ??
                                                                  '',
                                                              onSuccess: () {},
                                                            );
                                                          } catch (e) {
                                                            AppErrorSnackBar(
                                                                    context)
                                                                .error(e);
                                                            setState(() {
                                                              callingInProgress =
                                                                  false; // Set flag to false if there's an error
                                                            });
                                                          }
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              "Call Now",
                                                              style:
                                                                  AppTextStyle
                                                                      .callNow,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            const SizedBox(
                                                              height: 23,
                                                              width: 23,
                                                              child: Image(
                                                                  image: AssetImage(
                                                                      'assets/images/call.png')),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                  //try end
                                                if ( snapshot.data?.items?.first.messageNintyOneStatus == 'inactive' )
                                                   GestureDetector(
                                                     onTap: () async {
                                                     String clientMobileNumber = snapshot.data?.items?.first.clientMobileNumber.toString() ?? '';

                                                      String telurl = 'tel:${clientMobileNumber}';
                                                      if (await canLaunchUrlString(telurl)) {
                                                        launchUrlString(telurl);
                                                      } else {
                                                        print("can't launch $telurl");
                                                      }
                                                     },
                                                     child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                "Call Now",
                                                                style:
                                                                    AppTextStyle
                                                                        .callNow,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              const SizedBox(
                                                                height: 23,
                                                                width: 23,
                                                                child: Image(
                                                                    image: AssetImage(
                                                                        'assets/images/call.png')),
                                                              ),
                                                            ],
                                                          ),
                                                   ),

                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  thickness: 1,
                                  color: AppColors.black12Color,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 13.0, right: 8.0, bottom: 8.0),
                                  child: Text(
                                    "${snapshot.data?.items?.first.address ?? ''} ${'. '} ${snapshot.data?.items?.first.landmark ?? ''}",
                                    style: AppTextStyle.customerNameDetail,
                                  ),
                                ),
                                Center(
                                  child: ElevatedButton.icon(
                                    onPressed: () async {
                                      String address =
                                          snapshot.data?.items?.first.address ??
                                              '';

                                      try {
                                        List<Location> locations =
                                            await locationFromAddress(address);

                                        if (locations.isNotEmpty) {
                                          String latitude = locations
                                              .first.latitude
                                              .toString();
                                          String longitude = locations
                                              .first.longitude
                                              .toString();

                                          String label = 'Client Address';
                                          int zoomLevel = 35;
                                          String mapUrl =
                                              'https://www.google.com/maps?q=$latitude,$longitude&z=$zoomLevel($label)';

                                          if (await canLaunchUrlString(
                                              mapUrl)) {
                                            await launchUrlString(mapUrl);
                                          } else {
                                            print("Can't launch $mapUrl");
                                          }
                                        } else {
                                          print(
                                              "Could not find coordinates for the given address");
                                        }
                                      } catch (e) {
                                        print(
                                            "Error converting address to coordinates: $e");
                                      }
                                    },
                                    icon: const Icon(Icons.directions),
                                    label: const Text('Get Directions'),
                                    style: ElevatedButton.styleFrom(
                                      // Customize the button style, if needed
                                      primary: Colors.blue, // Button color
                                      onPrimary: Colors.white, // Text color
                                    ),
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
                                            AssetImage(AssetsPath.clockImage)),
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
                              if(snapshot.data?.items?.first.descriptions != null)
                              const SizedBox(
                                height: 20,
                              ),
                              if(snapshot.data?.items?.first.descriptions != null)
                              Row(
                                children: [
                                  Text(
                                    "Rec Reason:",
                                    style: AppTextStyle.veryGoodDetail,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Text(
                                      snapshot.data?.items?.first.descriptions ??
                                          '',
                                      style: AppTextStyle.tasktype,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Service Type:",
                                    style: AppTextStyle.veryGoodDetail,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    snapshot.data?.items?.first.tasktype!
                                            .taskName ??
                                        '',
                                    style: AppTextStyle.tasktype,
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                Labels.productType,
                                style: AppTextStyle.veryGoodDetail,
                              ),
                              Text(
                                snapshot.data?.items?.first.typeOfProduct
                                        ?.productList ??
                                    '',
                                style: AppTextStyle.customerNameDetail,
                              ),
                              // ----------sub prodduct try start-----
                              if (item.subProducts != null &&
                                  item.subProducts!.isNotEmpty)
                                const SizedBox(
                                  height: 10,
                                ),
                              Text(
                                Labels.subProductType,
                                style: AppTextStyle.veryGoodDetail,
                              ),
                              if (item.subProducts != null &&
                                  item.subProducts!.isNotEmpty)
                                ...item.subProducts!
                                    .map((subProduct) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2.0),
                                          child: Text(
                                            '${subProduct.subProductList}',
                                            style:
                                                AppTextStyle.customerNameDetail,
                                          ),
                                        ))
                                    .toList(),

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
                                snapshot.data?.items?.first.quantity ?? '',
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
                              // if (roleId != '3')
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
                    /* Booking Image start */
                    if ((snapshot.data?.items?.first.serviceImageData?.length ??
                            0) >
                        0)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          elevation: 3.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Images: ",
                                  style: AppTextStyle.veryGoodDetail,
                                ),
                                // Display form images for this agent update
                                const SizedBox(
                                  height: 5,
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data?.items?.first
                                          .serviceImageData?.length ??
                                      0,
                                  itemBuilder: (context, index) {
                                    final uploadedServiceImage = snapshot.data
                                        ?.items?.first.serviceImageData?[index];
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, bottom: 8.0),
                                          child: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                3,
                                            width: MediaQuery.of(context)
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
                                                          DisposeLevel.High,
                                                      child: Image.network(
                                                        AppUrl.imageUrl +
                                                            uploadedServiceImage!
                                                                .imageFile
                                                                .toString(),
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Image.network(
                                                AppUrl.imageUrl +
                                                    uploadedServiceImage!
                                                        .imageFile
                                                        .toString(),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            // downloadImage(AppUrl.imageUrl + image.formImageFile.toString());
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  DownloadProgressDialog(
                                                imageUrl: AppUrl.imageUrl +
                                                    uploadedServiceImage!
                                                        .imageFile
                                                        .toString(),
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.download,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    /* Booking Image end */

                    // Booking Video start
                  if ((snapshot.data?.items?.first.serviceVideoData?.length ?? 0) > 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        elevation: 3.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Videos: ",
                                style: AppTextStyle.veryGoodDetail,
                              ),
                              const SizedBox(height: 5),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data?.items?.first.serviceVideoData?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final videoController = _videoControllers[index];
                                  final uploadedServiceVideo = snapshot.data?.items?.first.serviceVideoData?[index];
                                  return Column(
                                    children: [
                                      if (videoController.value.isInitialized)
                                        AspectRatio(
                                          aspectRatio: videoController.value.aspectRatio,
                                          child: VideoPlayer(videoController),
                                        ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                videoController.value.isPlaying
                                                    ? videoController.pause()
                                                    : videoController.play();
                                              });
                                            },
                                            icon: Icon(
                                              videoController.value.isPlaying
                                                  ? Icons.pause
                                                  : Icons.play_arrow,
                                            ),
                                          ),
                                         IconButton(
                                                          onPressed: () {
                                                            
                                                            showDialog(
                                                              context: context,
                                                              builder: (context) => DownloadVideoProgressDialog(
                                                                  videoUrl: AppUrl
                                                                          .videoUrl +
                                                                      uploadedServiceVideo!.videoFile.toString(),
                                                                      ),
                                                            );
                                                          },
                                                          icon: const Icon(
                                                            Icons.download,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  // Booking video end

                    /* Accept Decline Button start */

                    Visibility(
                      visible:
                          snapshot.data?.items?.first.acceptNotificationType ==
                              null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          elevation: 3.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Visibility(
                                      visible: snapshot.data?.items?.first
                                              .acceptNotificationType ==
                                          null,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          try {
                                            await intallerController
                                                .acceptDeclineTask(
                                              serviceId:
                                                  widget.serviceId.toString(),
                                              notificationMessage:
                                                  'not accepted',
                                              onSuccess: () {},
                                            );

                                            // ignore: use_build_context_synchronously
                                            PageNavigator(ctx: context)
                                                .nextPageOnly(
                                                    page:
                                                        const AgentHomeView());
                                          } catch (e) {
                                            AppErrorSnackBar(context).error(e);
                                          }
                                        },
                                        child: Text("Reject"),
                                        style: ElevatedButton.styleFrom(
                                          // Customize the button style, if needed
                                          primary: Colors.red, // Button color
                                          onPrimary: Colors.white, // Text color
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: snapshot.data?.items?.first
                                              .acceptNotificationType ==
                                          null,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          try {
                                            await intallerController
                                                .acceptDeclineTask(
                                              serviceId:
                                                  widget.serviceId.toString(),
                                              notificationMessage: 'accepted',
                                              onSuccess: () {},
                                            );

                                            // ignore: use_build_context_synchronously
                                            PageNavigator(ctx: context)
                                                .nextPageOnly(
                                                    page:
                                                        const AgentHomeView());
                                          } catch (e) {
                                            AppErrorSnackBar(context).error(e);
                                          }
                                        },
                                        child: Text("Accept"),
                                        style: ElevatedButton.styleFrom(
                                          // Customize the button style, if needed
                                          primary: Colors.green, // Button color
                                          onPrimary: Colors.white, // Text color
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    Visibility(
                      visible:
                          snapshot.data?.items?.first.acceptNotificationType !=
                              null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          elevation: 3.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        print("You accepted me");
                                      },
                                      child: Text("Accepted"),
                                      style: ElevatedButton.styleFrom(
                                        // Customize the button style, if needed
                                        primary: Colors.green, // Button color
                                        onPrimary: Colors.white, // Text color
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    /* Accept Decline Button end */
                  ],
                );
              }
            }),
      ),
    );
  }
}

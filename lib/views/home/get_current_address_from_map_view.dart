// import 'package:geolocator/geolocator.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../controller/authControllerProvider/auth_controller_provider.dart';
// import '../../controller/booking_controller_provider.dart';
// import '../../utils/exports.dart';
// import '../drawer/my_drawar_screen.dart';
// import '../google_map_address/add_current_address_of_user_view.dart';

// class GetCurrentAddressFromMapView extends StatefulWidget {
//   const GetCurrentAddressFromMapView({super.key});

//   @override
//   State<GetCurrentAddressFromMapView> createState() => _GetCurrentAddressFromMapViewState();
// }

// class _GetCurrentAddressFromMapViewState extends State<GetCurrentAddressFromMapView> {
//   final _formKey = GlobalKey<FormState>();
//   final authenticationProvider = AuthenticationControllerProvider();
//   final bookingControllerProvider = BookingControllerProvider();
//   final TextEditingController _address = TextEditingController();

  

//   @override
//   void dispose() {
//     super.dispose();
//      _address.dispose();

    
//   }

//   Future<Position?> getCurrentLocation() async {
//      LocationPermission permission = await Geolocator.requestPermission();
//      if (permission == LocationPermission.denied) {
//       return null;
//      }else if(permission == LocationPermission.deniedForever){
//       return null;
//      }
//       return await Geolocator.getCurrentPosition();
//    }

//     Future<String?> getLatitudeValue() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('latitude');
//   }

//   Future<String?> getLongitudeValue() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('longitude');
//   }


//   @override
//   Widget build(BuildContext context) {
   
//     return Scaffold(
//       drawer: const MyDrawerScreen(),
//       appBar: AppBar(
//         title: Text(
//           Labels.newServiceBooking,
//           style: AppTextStyle.titileBar,
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 TextFormField(
//                   style: AppTextStyle.textBoxInputStyle,
//                   decoration: InputDecoration(
//                     hintText: Labels.addressSearch,
//                     filled: true,
//                     fillColor: Colors.white,
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: const BorderSide(
//                         width: 1.0,
//                         color: Colors.black,
//                       ),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide(
//                         width: 1.0,
//                         color: AppColors.dropdownBorderColor,
//                       ),
//                     ),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8)),
//                     suffixIcon: InkWell(
//                     onTap: () async {

//                        String? latitude = await getLatitudeValue();
//                       String? longitude = await getLongitudeValue();
                     
//                     if (latitude == null || longitude == null) {
//                       print("Latitude or Longitude is null");

//                     Position? position = await getCurrentLocation();
//                     if (position != null) {
//                       SharedPreferences prefs = await SharedPreferences.getInstance();
//                       prefs.setString('latitude', position.latitude.toString());
//                       prefs.setString('longitude', position.longitude.toString());

//                       latitude = position.latitude.toString();
//                       longitude = position.longitude.toString();

//                       // ignore: use_build_context_synchronously
//                       String? selectedAddress = await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => AddCurrentAddressOfUserView(
//                             latitudeValue: latitude.toString(),
//                             longitudeValue: longitude.toString(),
//                             onAddressSelected: (address) {
//                               setState(() {
//                                 _address.text = address; // Set the address to the _address controller
//                               });
//                             },
//                           ),
//                         ),
//                       );

//                       if (selectedAddress != null) {
//                         setState(() {
//                           _address.text = selectedAddress; // Set the address to the _address controller
//                         });
//                       }

//                        print("new saved Latitude: $latitude");
//                       print("new saved Longitude: $longitude");

//                     }
                  
//                     }  else {
//                        // ignore: use_build_context_synchronously
//                        String? selectedAddress = await Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => AddCurrentAddressOfUserView(
//                             latitudeValue: latitude.toString(),
//                             longitudeValue: longitude.toString(),
//                             onAddressSelected: (address) {
//                               setState(() {
//                                 _address.text = address; // Set the address to the _address controller
//                               });
//                             },
//                           ),
//                         ),
//                       );

//                       if (selectedAddress != null) {
//                         setState(() {
//                           _address.text = selectedAddress; // Set the address to the _address controller
//                         });
//                       }
    
                  

//                     }
                    
                     
//                     },
//                       child: Container(
//                         margin: const EdgeInsets.only(right: 10),
//                         width: 25,
//                         decoration: const BoxDecoration(
//                           borderRadius:
//                               BorderRadius.all(Radius.circular(5)),
                          
//                         ),
//                         child:  Center(
//                           child: Image.asset(
//                             AssetsPath.location,
//                             width: 48.0,
//                             height: 38.0,
//                             fit: BoxFit.cover,
//                           ),
                        
//                         ),
//                       ),
//                     ),
//                   ),
//                   keyboardType: TextInputType.name,
//                   controller: _address,
//                   validator: (value) {
//                     return bookingControllerProvider.validateBlankField(value!);
//                   },
//                 ),
             
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:async';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
// import '../../controller/location_controller_provider.dart';
// import '../../utils/components/location_search_dialogue.dart';
// import '../../utils/style/app_colors.dart';


// class AddAddressView extends StatefulWidget {
//    final Function(String) onAddressSelected; 
//     // final Function(int?) onNearestServiceCenterIdSelected;

//   const AddAddressView({super.key,  required this.onAddressSelected,
//   //  required this.onNearestServiceCenterIdSelected,
//   });

//   @override
//   State<AddAddressView> createState() => _AddAddressViewState();
// }

// class _AddAddressViewState extends State<AddAddressView> {
//   //get map controller to access map
//   Completer<GoogleMapController> _googleMapController = Completer();

//   late CameraPosition _cameraPosition;
//   String selectedAddress = '';
//   late LatLng _defaultLatLng;
//   late LatLng _draggedLatlng;
//   String _draggedAddress = "";
  
//   @override
//   void initState(){
//     super.initState();
//      _init();  

//   }

//    _init() {
//     //set default latlng for camera position
//     _defaultLatLng = LatLng(26.7271, 88.3953);
//     _draggedLatlng = _defaultLatLng;
//     _cameraPosition = CameraPosition(
//       target: _defaultLatLng,
//       zoom: 17.5 // number of map view 
//     );
//     //map will redirect to my current location when loaded
//     _gotoUserCurrentPosition();

//    }


//   late GoogleMapController _mapController;

//    //get user's current location and set the map's camera to that location
//   Future _gotoUserCurrentPosition() async {
//     Position currentPosition = await _determineUserCurrentPosition();
//     _gotoSpecificPosition(LatLng(currentPosition.latitude, currentPosition.longitude));
//   }

//    //go to specific position by latlng
//   Future _gotoSpecificPosition(LatLng position) async {
//     GoogleMapController mapController = await _googleMapController.future;
//     mapController.animateCamera(CameraUpdate.newCameraPosition(
//       CameraPosition(
//         target: position,
//         zoom: 17.5
//       )
//     ));
//     //every time that we dragged pin , it will list down the address here
//     await _getAddress(position);
//   }


//   Future _determineUserCurrentPosition() async {
//     LocationPermission locationPermission;
//     bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
//     //check if user enable service for location permission
//     if(!isLocationServiceEnabled) {
//       print("user don't enable location permission");
//     }

//     locationPermission = await Geolocator.checkPermission();

//     //check if user denied location and retry requesting for permission
//     if(locationPermission == LocationPermission.denied) {
//       locationPermission = await Geolocator.requestPermission();
//       if(locationPermission == LocationPermission.denied) {
//         print("user denied location permission");
//       }
//     }

//     //check if user denied permission forever
//     if(locationPermission == LocationPermission.deniedForever) {
//       print("user denied permission forever");
//     }

//     return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
//   }

//    Future<void> _getCoordinatesFromAddress(String address) async {
//     try {
//       List<Location> locations = await locationFromAddress(address);
//       if (locations.isNotEmpty) {
//         LatLng newPosition = LatLng(locations[0].latitude, locations[0].longitude);
//         _gotoSpecificPosition(newPosition);
//       } else {
//         print('No coordinates found for the address: $address');
//       }
//     } catch (e) {
//       print('Error converting address to coordinates: $e');
//     }
//   }

//    //get address from dragged pin 
//   Future _getAddress(LatLng position) async {
//     //this will list down all address around the position
//     List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
//     Placemark address = placemarks[0]; // get only first and closest address
//     String addresStr = "${address.name ?? ''}, ${address.locality ?? ''}, ${address.administrativeArea ?? ''}, ${address.postalCode ?? ''}, ${address.country}";
    
    
//     setState(() {
//       // _draggedAddress = addresStr;
//       selectedAddress = addresStr;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
      
//      return Scaffold(
//       // appBar:AppBar(
//       //   title: const Text("Search address"),
//       // ),
//          appBar: AppBar(
//         backgroundColor: AppColors.primaryColor,
      
//       iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Stack(
//         children: <Widget>[
          
//           Consumer<LocationControllerProvider>(
//             builder: (context, locationController, child) {
//               return GoogleMap(
//                 onMapCreated: (GoogleMapController mapController) {
//                   _mapController = mapController;

//                    if (!_googleMapController.isCompleted) {
//                     //set controller to google map when it is fully loaded
//                     _googleMapController.complete(mapController);
//                   }
                  
//                 },

                
//                 initialCameraPosition: _cameraPosition,
                
//                 mapType: MapType.normal,
//                 onCameraIdle: () {
//                   //this function will trigger when user stop dragging on map
//                   //every time user drag and stop it will display address 

//                   _getAddress(_draggedLatlng);
//                 },
//                   onCameraMove: (cameraPosition) {
//                   //this function will trigger when user keep dragging on map
//                   //every time user drag this will get value of latlng

//                   _draggedLatlng = cameraPosition.target;
//                 },

//               );
//             },
//           ),
//           Consumer<LocationControllerProvider>(
//             builder: (context, locationController, child) {
//               return Positioned(
//                 top: 0,
//                 left: 5,
//                 right: 5,
//                 child: GestureDetector(
//                 onTap: () {
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return Builder(
//                       builder: (BuildContext builderContext) {
//                         return LocationSearchDialog(
//                           mapController: _mapController,
//                             onSuggestionSelected: (selectedAddress) {
//                         setState(() {
//                           this.selectedAddress = selectedAddress;
                          
//                           print('new address bro '+selectedAddress);
//                         });
//                         _getCoordinatesFromAddress(selectedAddress);
//                       },
//                           );
//                       },
//                     );
//                   },
//                 );
//               },


//                   child: Container(
//                     height: 65,
//                     padding: const EdgeInsets.symmetric(horizontal: 5),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).cardColor,
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: const [
//                       BoxShadow(
//                         color:  Color(0xFF000000),
//                         offset: Offset(0.0, 0.0),
//                         blurRadius: 4.0,
//                       ),
//                     ],
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(Icons.location_on, size: 25, color: Theme.of(context).primaryColor),
//                         const SizedBox(width: 5),
//                         Expanded(
//                           child: Text(
//                              '${selectedAddress}',
//                             // '${_draggedAddress}',
//                              // Use the selectedAddress here
//                             style: const TextStyle(fontSize: 15),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             selectionColor: Colors.black,
                            
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Icon(Icons.search, size: 25, color: Theme.of(context).textTheme.bodyText1!.color),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             }
//           ),
//           Center(
//           child: Container(
//             width: 150,
//             child: Lottie.asset("assets/images/pin.json"),
            
//           ),
//         ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () async {
//            widget.onAddressSelected(selectedAddress);
//            Future.delayed(const Duration(seconds: 2), () async {
//       Navigator.pop(context);
//      });
//         },
     
//       label: const Text('Get Address!'),
//       icon: const Icon(Icons.place_outlined),
//     ),
//     floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,

    
//     );
    
//   }

// }
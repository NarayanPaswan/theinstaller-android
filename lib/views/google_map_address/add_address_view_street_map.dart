// import 'package:dio/dio.dart';
// import 'package:geocoding/geocoding.dart';
// import '../../controller/authControllerProvider/auth_controller_provider.dart';
// import '../../utils/exports.dart';


// class AddAddressView extends StatefulWidget {
//    final Function(String) onAddressSelected; 
//     final Function(int?) onNearestServiceCenterIdSelected;

//   const AddAddressView({super.key,  required this.onAddressSelected,
//    required this.onNearestServiceCenterIdSelected,
//   });

//   @override
//   State<AddAddressView> createState() => _AddAddressViewState();
// }

// class _AddAddressViewState extends State<AddAddressView> {
//   String streetAddress = '';
//   int? nearestId;
//   final dio = Dio();
//   double? lat; 
//   double? long;
//   final key = UniqueKey();
//   bool isLoading = true;
//   final authController = AuthenticationControllerProvider();

//     @override
//     void initState() {
//       super.initState();
//       authController.getUserCurrentLocation(context).then((value) {
//           setState(() {
//             lat = value.latitude;
//             long = value.longitude;
//             isLoading = false;
//           });
      
//       });
//     }


//   @override
//   Widget build(BuildContext context) {
      
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Search address"),
//       ),
//       body: 
//       isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : 
//       OpenStreetMapSearchAndPick(
//         center: LatLong(lat!, long!),
//         key: key,
//         zoomOutIcon: Icons.zoom_out,
//         zoomInIcon: Icons.zoom_in,
//         buttonColor: Colors.blue,
//         buttonText: 'Get Address',
        
//         onPicked: (pickedData) async{

//         // Get the placemarks for the user's current location
//         List<Placemark> placemarks = await placemarkFromCoordinates(pickedData.latLong.latitude, pickedData.latLong.longitude);

//         // Extract relevant information from the placemark
               
//         String locality = placemarks.first.locality ?? "";
//         String subAdministrativeArea = placemarks.first.subAdministrativeArea ?? "";
//         String state = placemarks.first.administrativeArea ?? "";
//         String postalCode = placemarks.first.postalCode ?? "";
//         String country = placemarks.first.country ?? "";
//         // Construct the address string
//         String address = "$locality $subAdministrativeArea $state $postalCode $country";
        
//         // Update the UI
        

//         //get nearest service center
//         final urlGetNearestServiceCenter = '${AppUrl.nearestServiceCenter}?latitude=${pickedData.latLong.latitude}&longitude=${pickedData.latLong.longitude}';
//          final response = await dio.get(
//             urlGetNearestServiceCenter,
//             options: Options(
//               headers: {
//                 'Content-Type': 'application/json',
//               },
//             ),
//           );
        
//         setState(() {
//           streetAddress = address;
//           // print("My current address");
//           // print(streetAddress);
//           nearestId = response.data['items']['id'];
//         });

          
//           widget.onAddressSelected(streetAddress);
//           widget.onNearestServiceCenterIdSelected(nearestId);
           
//            Future.delayed(const Duration(seconds: 2), () async {
//             Navigator.pop(context);
//           });
//           // print('my lat is: ${pickedData.latLong.latitude}');
//           // print('my long is: ${pickedData.latLong.longitude}');
       
//           // print('my url is ${urlGetNearestServiceCenter}');
//           // print('nearest id ${response.data['items']['id']}');
            
      
//         })
//     );
//   }
// }
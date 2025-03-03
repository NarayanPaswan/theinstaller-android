import 'package:flutter/material.dart';
import '../../utils/style/app_colors.dart';
import '../drawer/my_drawar_screen.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer:  const MyDrawerScreen(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor:AppColors.primaryColor ,
        title: const Text(''),
      ),


      // body: SingleChildScrollView(
      //   child:
      //       Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //
      //
      //
      //           Container(
      //             decoration: BoxDecoration(
      //               borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
      //
      //               color: AppColors.primaryColor,
      //             ),
      //             height: 100,
      //             child: Center(
      //               child: Column(
      //                 children: [
      //                   addVerticalSpace(10),
      //                   Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                     children: [
      //
      //                     Container(
      //                       decoration: BoxDecoration(
      //                         borderRadius: BorderRadius.all(Radius.circular(10)),
      //
      //                         color:Color(0xff2f1794),
      //                       ),
      //                     height: 55,
      //                     width: 330,
      //                     child: Center(
      //                       child: Theme(
      //                         data: ThemeData(
      //                           colorScheme: Theme.of(context).colorScheme.copyWith(
      //                             primary: Colors.blueAccent,
      //                           ),
      //                         ),
      //                         child: TextFormField(
      //                           onChanged: (String? value){
      //
      //                           },
      //
      //                           decoration: InputDecoration(
      //                               // hintStyle: kBodyText12wBold(textColor),
      //                               border: InputBorder.none,
      //                               prefixIcon: Icon(Icons.search,color: Colors.white,),
      //                               // suffixIconColor: textColor,
      //                               hintStyle: TextStyle(color: Colors.white38,fontSize: 17),
      //                               hintText: 'Search'),
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //                       // addHorihontalSpace(10),
      //                       Container(
      //                           height: 25,
      //                           width: 25,
      //                           child: Image(image: AssetImage('assets/icons/img_8.png'))),
      //                       // addHorihontalSpace(10)
      //                     ],
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //           addVerticalSpace(20),
      //           Padding(
      //             padding: const EdgeInsets.only(left: 12),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceAround,
      //               children: [
      //                 InkWell(
      //                   onTap: (){
      //                     UserDetailsShow();
      //                   },
      //                   child: Container(
      //                     height: 60,
      //                     width: 250,
      //                     decoration: BoxDecoration(
      //                       color: AppColors.primaryColor,
      //                       borderRadius: BorderRadius.all(Radius.circular(10))
      //                     ),
      //                     child: Center(
      //                       child: Row(
      //                         children: [
      //                           addHorihontalSpace(20),
      //                           Icon(Icons.list_alt_outlined,color: Colors.white,),
      //                           addHorihontalSpace(10),
      //                           Text('Category Settings',style: TextStyle(fontSize: 17,color: Colors.white),)
      //                         ],
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //                 Container(
      //
      //                     height: 30,
      //                     width: 30,
      //                     decoration: BoxDecoration(
      //                         color: Colors.black,
      //                       shape: BoxShape.circle
      //                     ),
      //                     child: Center(child: Icon(Icons.sort,color: Colors.white,))),
      //                 Text('Sort',style: TextStyle(fontSize: 17),),
      //                 addVerticalSpace(15)
      //               ],
      //             ),
      //           ),
      //           addVerticalSpace(20),
      //           Container(
      //             height: 600,
      //             child: ListView.builder(
      //               itemCount: 5,
      //                 itemBuilder: (context , i){
      //                   return Container(
      //                     height: 180,
      //                     child: Card(
      //                       color: Colors.white,
      //                       child: Container(
      //                         child: Column(
      //                           children: [
      //                             SingleChildScrollView(
      //                               scrollDirection: Axis.horizontal,
      //                               child: Stack(
      //                                 children: [
      //                                   Positioned(
      //                                       top: 5,
      //                                       right: 5,
      //                                       child: Container(
      //                                         decoration: BoxDecoration(
      //                                             shape: BoxShape.rectangle,
      //                                             color: Colors.green,
      //                                             borderRadius: BorderRadius.all(Radius.circular(10))
      //                                         ),
      //                                         height: 35,
      //                                         width: 35,
      //                                         child: Icon(Icons.account_tree_outlined,color: Colors.white,),
      //                                       )
      //
      //                                   ),
      //                                   Padding(
      //                                     padding: const EdgeInsets.only(left: 12,top: 12),
      //                                     child: Row(
      //                                       children: [
      //                                         Container(
      //                                             decoration: BoxDecoration(
      //                                                 borderRadius: BorderRadius.all(Radius.circular(10))
      //                                             ),
      //                                             height: 60,
      //                                             width: 60,
      //                                             child: Image(image: AssetImage('assets/images/search_image.png'))),
      //                                         addHorihontalSpace(15),
      //                                         Column(
      //                                           crossAxisAlignment: CrossAxisAlignment.start,
      //                                           children: [
      //                                             Text('Customer Name',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
      //                                             addVerticalSpace(5),
      //                                             Row(
      //                                               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                                               children: [
      //                                                 Icon(Icons.cleaning_services_outlined,color: Colors.black26,),
      //                                                 addHorihontalSpace(5),
      //                                                 Text('Cleaning',style: TextStyle(color: Colors.black26,fontSize: 17,),),
      //                                                 addHorihontalSpace(35),
      //                                                 Row(
      //                                                   children: [
      //                                                     Text('Time: ',style: TextStyle(fontSize: 17,color: Colors.black26),),
      //                                                     Text('10:00 AM - 12:00 PM',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),)
      //                                                   ],
      //                                                 )
      //                                               ],
      //                                             )
      //                                           ],
      //                                         )
      //                                       ],
      //                                     ),
      //                                   ),
      //                                 ],
      //                               ),
      //                             ),
      //                             addVerticalSpace(20),
      //                             Divider(thickness: 1,color: Colors.black12,),
      //                             addVerticalSpace(5),
      //                             SingleChildScrollView(
      //                               scrollDirection: Axis.horizontal,
      //                               child: Row(
      //                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                                 children: [
      //                                   Row(
      //                                     children: [
      //                                       addHorihontalSpace(10),
      //                                       Text('Address: ',style: TextStyle(fontSize: 17,color: Colors.black26),),
      //                                       Text('Raj Kumar Nagar,  Godda',style: TextStyle(fontSize: 17),),
      //                                       Container(
      //                                           height: 25,
      //                                           width: 25,
      //                                           child: Image(image: AssetImage('assets/images/location.png')))
      //
      //                                     ],
      //                                   ),
      //                                   Container(
      //
      //                                     height: 38,
      //                                     width: 38,
      //                                     child: Image(image: AssetImage('assets/images/person2.png'),)
      //                                   )
      //
      //                                 ],
      //                               ),
      //                             )
      //                           ],
      //                         ),
      //                       ),
      //                     ),
      //                   );
      //                 }
      //
      //             ),
      //           ),
      //
      //         ],
      //       ),
      //
      // ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: AppColors.primaryColor,
      //   child: Icon(Icons.add,color: Colors.white,),
      //   onPressed: (){},
      //
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: BottomAppBar(
      //   height: 70,
      //   notchMargin: 5.0,
      //   shape: CircularNotchedRectangle(),
      //   color: Colors.white,
      //   child: Center(
      //     child: Padding(
      //       padding: const EdgeInsets.only(top: 20),
      //       child: Text('New Service Booking',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
      //     ),
      //   ),
      // ),


    );
  }
}

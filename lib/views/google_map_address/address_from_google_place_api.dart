import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../../utils/exports.dart';


class GooglePlaceApiView extends StatefulWidget {
   final Function(String) onAddressSelected; 
    final Function(int?) onNearestServiceCenterIdSelected;

  const GooglePlaceApiView({super.key,  required this.onAddressSelected,
   required this.onNearestServiceCenterIdSelected,
  });

  @override
  State<GooglePlaceApiView> createState() => _GooglePlaceApiViewState();
}

class _GooglePlaceApiViewState extends State<GooglePlaceApiView> {
  TextEditingController _searchController = TextEditingController();
  var uuid = Uuid();
  String _sessionToken = '1239832';
  List<dynamic> _placesList = [];

   @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
       onChangePlace(); 
    });

  }
   void onChangePlace() {
     if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
     getSuggestion(_searchController.text);
   }

   void getSuggestion(String input)async{
    String kplacesApiKey = "AIzaSyBgcejM6KxDF1mfBl6icxy2WlZ84WR1shs"; 
    String baseURL = "https://maps.googleapis.com/maps/api/place/autocomplete/json";
    String request = '$baseURL?input=$input&key=$kplacesApiKey&sessiontoken=$_sessionToken';
    
    var response = await http.get(Uri.parse(request));
    var data = response.body.toString();
     print(data);
    if(response.statusCode == 200){
      setState(() {
        _placesList = jsonDecode(response.body.toString()) ['predictions'];
      });
    }else{
      throw Exception('Faild to load data');
    }

   }

  @override
  Widget build(BuildContext context) {
      
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search address"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            
             TextFormField(
               controller: _searchController,
               decoration: const InputDecoration(  
                 hintText: "Search your place"
                 ),
               ),

               Expanded(
                 child: ListView.separated(
                    itemCount: _placesList.length,
                     separatorBuilder: (context, index) => Divider(), 
                    itemBuilder: (context, index){
                       return ListTile(
                        title: Text(_placesList[index]['description']),
                       );
                    }
                 ),
               )
          ],
        ),
      )
    
    );
  }
}
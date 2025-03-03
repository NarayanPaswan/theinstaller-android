import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../utils/exports.dart';



class ImageGalleryView extends StatefulWidget {
   final List<String> initialImagePaths;
  const ImageGalleryView({
    super.key, 
    required this.initialImagePaths, 
    });

  @override
  State<ImageGalleryView> createState() => _ImageGalleryViewState();
}

class _ImageGalleryViewState extends State<ImageGalleryView> {
  final _formKey = GlobalKey<FormState>();
  late List<String> selectedImagePaths = [];
  List<String> imageCaptions = [];

  

 @override
  void initState() {
    super.initState();
    selectedImagePaths = List.from(widget.initialImagePaths); // Initialize with passed data
    
  }

    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          Labels.imageGallery,
          style: AppTextStyle.ongoingBooking,
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: selectedImagePaths.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height / 3,
                            width: MediaQuery.of(context).size.width,
                            child: Image.file(
                              File(selectedImagePaths[index]),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        // AppTextFormField(
                        //   labelText: Labels.formCaption,
                        //   hintText: Labels.typeHere,
                        //   keyboardType: TextInputType.multiline,
                        //   maxLength: 250,
                        //   onChanged: (value) {
                        //     setState(() {
                        //       imageCaptions[index] = value;
                        //       print(
                        //           'Your caption is $index :  ${imageCaptions[index]}');
                        //     });
                        //   },
                        // ),
                        const SizedBox(
                          height: 10,
                        ),

                        //all button start
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppIconButton(
                              onTap: () {
                                setState(() {
                                  selectedImagePaths.removeAt(index);
                                  // imageCaptions.removeAt(index);
                                });
                              },
                              iconType: Icons.delete,
                            ),
                            
                                                       

                        
                          ],
                        ),
                        //all button end
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                        color: AppColors.getStartbuttonColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          selectImage();
                          setState(() {});
                        },
                        child: Text("Add Image",
                            style: AppTextStyle.getStartedSplash),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                        color: AppColors.getStartbuttonColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          Navigator.pop(context, {
                            'selectedImagePaths': selectedImagePaths,
                            // 'imageCaptions': imageCaptions,
                          });
                        },
                        child:
                            Text("Done", style: AppTextStyle.getStartedSplash),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //camera and image dialog box start
  Future selectImage() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 180,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const Text(
                      'Select Image From !',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await selectImageFromGallery();
                          },
                          child: Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      AssetsPath.gallery,
                                      height: 60,
                                      width: 60,
                                    ),
                                    const Text('Gallery'),
                                  ],
                                ),
                              )),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await selectImageFromCamera();
                          },
                          child: Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      AssetsPath.camera,
                                      height: 60,
                                      width: 60,
                                    ),
                                    Text('Camera'),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
  //camera and image dialog box end

  Future<void> selectImageFromGallery() async {
    List<XFile>? files = await ImagePicker().pickMultiImage();

    if (files != null && files.isNotEmpty) {
      setState(() {
        selectedImagePaths.addAll(files.map((file) => file.path).toList());
        // Update imageCaptions to have the same length as selectedImagePaths
        imageCaptions.addAll(List.generate(files.length, (index) => ''));
      });
    }
  }

  selectImageFromCamera() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.camera);

    if (file != null) {
      // return file.path;
      setState(() {
        selectedImagePaths.add(file.path);
        imageCaptions.add('');
      });
    } else {
      return '';
    }
  }
}

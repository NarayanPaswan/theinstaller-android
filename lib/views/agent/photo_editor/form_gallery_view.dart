import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:theinstallers/views/agent/photo_editor/text_editor_form_view.dart';
import '../../../utils/exports.dart';
import 'package:image_cropper/image_cropper.dart';

import 'draw_editor_form_view.dart';

class FormGalleryView extends StatefulWidget {
  final List<String> initialImagePaths;
  final List<String> initialImageCaptions;

  const FormGalleryView({
    Key? key,
    required this.initialImagePaths, // Added to accept initial image paths
    required this.initialImageCaptions, // Added to accept initial image captions
  }) : super(key: key);

  @override
  State<FormGalleryView> createState() => _FormGalleryViewState();
}

class _FormGalleryViewState extends State<FormGalleryView> {
  final _formKey = GlobalKey<FormState>();
  late List<String> selectedImagePaths; // Changed to late to initialize later
  late List<String> imageCaptions; // Changed to late to initialize later
  int _index = 0;
  int _indexDraw = 0;

  @override
  void initState() {
    super.initState();
    selectedImagePaths = List.from(widget.initialImagePaths); // Initialize with passed data
    imageCaptions = List.from(widget.initialImageCaptions); // Initialize with passed data
  }

  Future<File> saveUint8ListToFile(Uint8List uint8List) async {
    Directory tempDir = await getTemporaryDirectory();
    _index++;
    String fileName = 'temp_image$_index.jpg'; 
    File tempFile = await File('${tempDir.path}/$fileName').writeAsBytes(uint8List);
    return tempFile;
  }

  Future<File> saveUint8ListToFileDraw(Uint8List uint8List) async {
    Directory tempDir = await getTemporaryDirectory();
    _indexDraw++;
    String fileName = 'draw_temp_image$_indexDraw.jpg'; 
    File tempFile = await File('${tempDir.path}/$fileName').writeAsBytes(uint8List);
    return tempFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          Labels.formGallery,
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
                        AppTextFormField(
                          labelText: Labels.formCaption,
                          hintText: Labels.typeHere,
                          keyboardType: TextInputType.multiline,
                          maxLength: 250,
                          initialValue: imageCaptions[index], // Initialize the caption with the passed data
                          onChanged: (value) {
                            setState(() {
                              imageCaptions[index] = value;
                              print('Your caption is $index :  ${imageCaptions[index]}');
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppIconButton(
                              onTap: () {
                                setState(() {
                                  selectedImagePaths.removeAt(index);
                                  imageCaptions.removeAt(index);
                                });
                              },
                              iconType: Icons.delete,
                            ),
                            AppIconButton(
                              onTap: () async {
                                CroppedFile? croppedFile = await ImageCropper().cropImage(
                                  sourcePath: selectedImagePaths[index],
                                  aspectRatioPresets: [
                                    CropAspectRatioPreset.square,
                                    CropAspectRatioPreset.ratio3x2,
                                    CropAspectRatioPreset.original,
                                    CropAspectRatioPreset.ratio4x3,
                                    CropAspectRatioPreset.ratio16x9
                                  ],
                                  uiSettings: [
                                    AndroidUiSettings(
                                      toolbarTitle: 'Cropper',
                                      toolbarColor: Colors.deepOrange,
                                      toolbarWidgetColor: Colors.white,
                                      initAspectRatio: CropAspectRatioPreset.original,
                                      lockAspectRatio: false
                                    ),
                                    IOSUiSettings(
                                      title: 'Cropper',
                                    ),
                                    WebUiSettings(
                                      context: context,
                                    ),
                                  ],
                                );

                                if (croppedFile == null) return;
                                setState(() {
                                  selectedImagePaths[index] = croppedFile.path;
                                });
                              },
                              iconType: Icons.crop_rotate,
                              bgColor: AppColors.greenColor,
                            ),
                            AppIconButton(
                              onTap: () async {
                                Uint8List? editedImage = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TextEditorFormView(
                                      selectedImagePath: selectedImagePaths[index],
                                    ),
                                  ),
                                );

                                if (editedImage != null) {
                                  File editedImageFile = await saveUint8ListToFile(editedImage);
                                  setState(() {
                                    selectedImagePaths[index] = editedImageFile.path;
                                    print("new image path is ${editedImageFile.path}");
                                  });
                                }
                              },
                              iconType: Icons.text_fields,
                              bgColor: AppColors.greenColor,
                            ),
                            AppIconButton(
                              onTap: () async {
                                Uint8List? editedDrawImage = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DrawEditorFormView(
                                      selectedDrawImagePath: selectedImagePaths[index],
                                    ),
                                  ),
                                );

                                if (editedDrawImage != null) {
                                  File editedDrawImageFile = await saveUint8ListToFileDraw(editedDrawImage);
                                  setState(() {
                                    selectedImagePaths[index] = editedDrawImageFile.path;
                                    print("new Draw image path is ${editedDrawImageFile.path}");
                                  });
                                }
                              },
                              iconType: Icons.draw,
                              bgColor: AppColors.greenColor,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 10),
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
                        child: Text("Add Form Image", style: AppTextStyle.getStartedSplash),
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
                        onPressed: () {
                          Navigator.pop(context, {
                            'selectedImagePaths': selectedImagePaths,
                            'imageCaptions': imageCaptions,
                          });
                        },
                        child: Text("Done", style: AppTextStyle.getStartedSplash),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
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
        selectedImagePaths.addAll(files.map((file) => file.path));
        imageCaptions.addAll(List.filled(files.length, '')); // Add empty captions for new images
      });
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> selectImageFromCamera() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        selectedImagePaths.add(image.path);
        imageCaptions.add(''); // Add an empty caption for the new image
      });
    }

    if (!mounted) return;
    Navigator.pop(context);
  }
}
import 'dart:io';
import 'dart:typed_data';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:theinstallers/views/agent/photo_editor/text_editor_site_form_view.dart';
import '../../../utils/exports.dart';
import 'draw_site_editor_form_view.dart';

class SiteGalleryView extends StatefulWidget {
  final List<String> initialSiteImagePaths;
  final List<String> initialSiteCaptions;

  const SiteGalleryView({
    Key? key,
    required this.initialSiteImagePaths,
    required this.initialSiteCaptions,
  }) : super(key: key);

  @override
  State<SiteGalleryView> createState() => _SiteGalleryViewState();
}

class _SiteGalleryViewState extends State<SiteGalleryView> {
  final _formKey = GlobalKey<FormState>();

  late List<String> selectedSiteImagePaths;
  late List<String> siteCaptions;
  int _index = 0;
  int _indexDraw = 0;

  Future<File> saveUint8ListToFileSite(Uint8List uint8List) async {
    Directory tempDir = await getTemporaryDirectory();
    _index++;
    String fileName = 'temp_site_image$_index.jpg';
    File tempFile = await File('${tempDir.path}/$fileName').writeAsBytes(uint8List);
    return tempFile;
  }

  Future<File> saveUint8ListToFileDrawSite(Uint8List uint8List) async {
    Directory tempDir = await getTemporaryDirectory();
    _indexDraw++;
    String fileName = 'draw_site_temp_image$_indexDraw.jpg';
    File tempFile = await File('${tempDir.path}/$fileName').writeAsBytes(uint8List);
    return tempFile;
  }

  @override
  void initState() {
    super.initState();
    selectedSiteImagePaths = widget.initialSiteImagePaths;
    siteCaptions = widget.initialSiteCaptions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          Labels.siteGallery,
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
                  itemCount: selectedSiteImagePaths.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 3,
                            width: MediaQuery.of(context).size.width,
                            child: Image.file(
                              File(selectedSiteImagePaths[index]),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        AppTextFormField(
                          labelText: Labels.formCaption,
                          hintText: Labels.typeHere,
                          keyboardType: TextInputType.multiline,
                          initialValue: siteCaptions[index],
                          onChanged: (value) {
                            setState(() {
                              siteCaptions[index] = value;
                              print('Your caption is $index :  ${siteCaptions[index]}');
                            });
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppIconButton(
                              onTap: () {
                                setState(() {
                                  selectedSiteImagePaths.removeAt(index);
                                  siteCaptions.removeAt(index);
                                });
                              },
                              iconType: Icons.delete,
                            ),
                            AppIconButton(
                              onTap: () async {
                                CroppedFile? croppedFile =
                                    await ImageCropper().cropImage(
                                  sourcePath: selectedSiteImagePaths[index],
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
                                        initAspectRatio:
                                            CropAspectRatioPreset.original,
                                        lockAspectRatio: false),
                                    IOSUiSettings(
                                      title: 'Cropper',
                                    ),
                                    WebUiSettings(
                                      context: context,
                                    ),
                                  ],
                                );

                                if (croppedFile == null) return null;
                                setState(() {
                                  selectedSiteImagePaths[index] = croppedFile.path;
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
                                    builder: (context) => TextEditorSiteFormView(
                                      selectedImagePath:
                                          selectedSiteImagePaths[index],
                                    ),
                                  ),
                                );

                                if (editedImage != null) {
                                  File editedImageFile =
                                      await saveUint8ListToFileSite(editedImage);

                                  setState(() {
                                    selectedSiteImagePaths[index] =
                                        editedImageFile.path;
                                  });
                                }
                              },
                              iconType: Icons.text_fields,
                              bgColor: AppColors.greenColor,
                            ),
                            AppIconButton(
                              onTap: () async {
                                Uint8List? editedDrawSiteImage = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DrawSiteEditorFormView(
                                      selectedDrawSiteImagePath:
                                          selectedSiteImagePaths[index],
                                    ),
                                  ),
                                );

                                if (editedDrawSiteImage != null) {
                                  File editedDrawSiteImageFile =
                                      await saveUint8ListToFileDrawSite(editedDrawSiteImage);

                                  setState(() {
                                    selectedSiteImagePaths[index] =
                                        editedDrawSiteImageFile.path;
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
                        onPressed: () async {
                          Navigator.pop(context, {
                            'selectedSiteImagePaths': selectedSiteImagePaths,
                            'siteCaptions': siteCaptions,
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

  Future<void> selectImageFromGallery() async {
    List<XFile>? files = await ImagePicker().pickMultiImage();

    if (files != null && files.isNotEmpty) {
      setState(() {
        selectedSiteImagePaths.addAll(files.map((file) => file.path).toList());
        siteCaptions.addAll(List.generate(files.length, (index) => ''));
      });
    }
  }

  Future<void> selectImageFromCamera() async {
    XFile? file = await ImagePicker().pickImage(source: ImageSource.camera);

    if (file != null) {
      setState(() {
        selectedSiteImagePaths.add(file.path);
        siteCaptions.add('');
      });
    }
  }

  Future<void> selectImage() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)),
          child: Container(
            height: 180,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  const Text(
                    'Select Site Image!',
                    style: TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await selectImageFromGallery();
                          Navigator.pop(context);
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
                          Navigator.pop(context);
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
                                  const Text('Camera'),
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
      },
    );
  }
}
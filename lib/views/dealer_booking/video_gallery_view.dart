import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../../../utils/exports.dart';

class VideoGalleryView extends StatefulWidget {
  final List<String> initialVideoPaths;
  const VideoGalleryView({super.key, required this.initialVideoPaths});

  @override
  State<VideoGalleryView> createState() => _VideoGalleryViewState();
}

class _VideoGalleryViewState extends State<VideoGalleryView> {
  final _formKey = GlobalKey<FormState>();
  late List<String> selectedVideoPaths;
  final List<VideoPlayerController> _videoControllers = [];

  @override
  void initState() {
    super.initState();
    selectedVideoPaths = List.from(widget.initialVideoPaths);
    _initializeVideoControllers();
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeVideoControllers() {
    for (var path in selectedVideoPaths) {
      final controller = VideoPlayerController.file(File(path));
      controller.initialize().then((_) {
        setState(() {
          _videoControllers.add(controller);
        });
      });
    }
  }

  void _addVideo(String path) {
    final controller = VideoPlayerController.file(File(path));
    controller.initialize().then((_) {
      setState(() {
        selectedVideoPaths.add(path);
        _videoControllers.add(controller);
      });
    });
  }

  Future<void> selectVideoFromGallery() async {
    final picker = ImagePicker();
   XFile? file = await picker.pickVideo(source: ImageSource.gallery);
    if (file != null) {
      _addVideo(file.path);
    }
  }

  Future<void> selectVideoFromCamera() async {
    final picker = ImagePicker();
    XFile? file = await picker.pickVideo(source: ImageSource.camera);
    if (file != null) {
      _addVideo(file.path);
    }
  }

  Future selectVideo() {
    return showDialog(
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
                    'Select Video From !',
                    style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Navigator.of(context).pop();
                          await selectVideoFromGallery();
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
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          Navigator.of(context).pop();
                          await selectVideoFromCamera();
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          Labels.videoGallery,
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
                  itemCount: selectedVideoPaths.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 3,
                                width: MediaQuery.of(context).size.width,
                                child: _videoControllers.length > index && _videoControllers[index].value.isInitialized
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (_videoControllers[index].value.isPlaying) {
                                              _videoControllers[index].pause();
                                            } else {
                                              _videoControllers[index].play();
                                            }
                                          });
                                        },
                                        child: AspectRatio(
                                          aspectRatio: _videoControllers[index].value.aspectRatio,
                                          child: VideoPlayer(_videoControllers[index]),
                                        ),
                                      )
                                    : const CircularProgressIndicator(),
                              ),
                              if (_videoControllers.length > index && !_videoControllers[index].value.isPlaying)
                                IconButton(
                                  icon: const Icon(Icons.play_arrow, size: 50, color: Colors.white),
                                  onPressed: () {
                                    setState(() {
                                      _videoControllers[index].play();
                                    });
                                  },
                                )
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppIconButton(
                              onTap: () {
                                setState(() {
                                  _videoControllers[index].dispose();
                                  _videoControllers.removeAt(index);
                                  selectedVideoPaths.removeAt(index);
                                });
                              },
                              iconType: Icons.delete,
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
                          selectVideo();
                        },
                        child: Text("Add Video", style: AppTextStyle.getStartedSplash),
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
                            'selectedVideoPaths': selectedVideoPaths,
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
}

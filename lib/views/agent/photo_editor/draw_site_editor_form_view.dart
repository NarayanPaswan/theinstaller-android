import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:painter/painter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:theinstallers/utils/exports.dart';
import '../../../controller/app_image_provider.dart';
import '../../../widgets/app_color_picker.dart';


class DrawSiteEditorFormView extends StatefulWidget {
  final String selectedDrawSiteImagePath;

  const DrawSiteEditorFormView({Key? key, required this.selectedDrawSiteImagePath})
      : super(key: key);

  @override
  State<DrawSiteEditorFormView> createState() => _DrawSiteEditorFormViewState();
}

class _DrawSiteEditorFormViewState extends State<DrawSiteEditorFormView> {
  String _imagePath = '';

  late AppImageProvider imageProvider;
  ScreenshotController screenshotController = ScreenshotController();
  final PainterController _controller = PainterController();
  
  @override
  void initState() {
    super.initState();
    
    _controller.thickness = 5.0;
    _controller.backgroundColor = Colors.transparent;

    _imagePath = '';
    if (widget.selectedDrawSiteImagePath.isNotEmpty) {
      _imagePath = widget.selectedDrawSiteImagePath;
    }
    print("image path is ${widget.selectedDrawSiteImagePath}");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: const CloseButton(),
            actions: [
              IconButton(
                  onPressed: () async {
                Uint8List? editedDrawSiteImage = await screenshotController.capture();
                if(!mounted) return;
                Navigator.of(context).pop(editedDrawSiteImage);
              
                  },
                  icon: const Icon(Icons.done)
                ),
            ],
          ),
          body: Stack(
            children: [
              Center(
                child: Screenshot(
                  controller: screenshotController,
                  child: Stack(
                    children: [
                      Image.file(
                        File(_imagePath),
                        fit: BoxFit.cover,
                      ),
                        Positioned.fill(
                            child: Painter(_controller)
                        )
                    ],
                  ),
                ),
                 
              ),
            

                 Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                        child: Center(
                          child: Icon(
                            Icons.circle,
                            color: Colors.white,
                            size: _controller.thickness + 3,
                          ),
                        ),
                      ),
                      Expanded(
                        child: slider(
                            value: _controller.thickness,
                            onChanged: (value){
                              setState(() {
                                _controller.thickness = value;
                              });
                            }
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
            ],
          ),

          bottomNavigationBar: Container(
        width: double.infinity,
        height: 60,
        color: Colors.black,
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: RotatedBox(
                  quarterTurns: _controller.eraseMode ? 2 : 0,
                  child: _bottomBarItem(Icons.create,
                      onPress: () {
                        setState(() {
                          _controller.eraseMode = !_controller.eraseMode;
                        });
                      }
                  ),
                ),
              ),
              Expanded(
                child: _bottomBarItem(Icons.color_lens_outlined,
                    onPress: () {
                      AppColorPicker().show(
                          context,
                          backgroundColor: _controller.drawColor,
                          alpha: true,
                          onPick: (color){
                            setState(() {
                              _controller.drawColor = color;
                            });
                          }
                      );
                    }
                ),
              ),
              
              Expanded(
                child: _bottomBarItem(Icons.undo,
                    onPress: () {
                      _controller.undo();
                    }
                ),
              ),
              Expanded(
                child: _bottomBarItem(Icons.delete,
                    onPress: () {
                      _controller.clear();
                    }
                ),
              ),
            ],
          ),
        ),
      ),

        ),
       
        
      ],
    );
  }
   Widget _bottomBarItem(IconData icon, {required onPress}) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
          ],
        ),
      ),
    );
  }

   Widget slider({value, onChanged}) {
    return Slider(
        label: '${value.toStringAsFixed(2)}',
        value: value,
        max: 20,
        min: 1,
        onChanged: onChanged
    );
  }
}

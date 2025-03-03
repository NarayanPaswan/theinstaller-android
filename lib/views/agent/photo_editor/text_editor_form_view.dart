import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';
import 'package:provider/provider.dart';
import 'package:text_editor/text_editor.dart';
import 'package:theinstallers/utils/exports.dart';
import 'package:theinstallers/views/agent/photo_editor/form_gallery_view.dart';

import '../../../controller/app_image_provider.dart';
import '../../../widgets/fonts.dart';

class TextEditorFormView extends StatefulWidget {
  final String selectedImagePath;

  const TextEditorFormView({Key? key, required this.selectedImagePath})
      : super(key: key);

  @override
  State<TextEditorFormView> createState() => _TextEditorFormViewState();
}

class _TextEditorFormViewState extends State<TextEditorFormView> {
  String _imagePath = '';
  late AppImageProvider imageProvider;
  LindiController controller = LindiController();
  bool showEditor = true;

  @override
  void initState() {
    super.initState();
    // imageProvider = Provider.of<AppImageProvider>(context, listen: false);

    // _imagePath = widget.selectedImagePath;
       // Clear the _imagePath before loading a new image
    _imagePath = '';
    if (widget.selectedImagePath.isNotEmpty) {
      _imagePath = widget.selectedImagePath;
    }
    print("image path is ${widget.selectedImagePath}");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: const CloseButton(),
            // title: const Text('Text'),
            actions: [
              IconButton(
                  onPressed: () async {
                    Uint8List? editedImage = await controller.saveAsUint8List();
                    if (!mounted) return;
                   Navigator.of(context).pop(editedImage);
              
                  },
                  icon: const Icon(Icons.done)
                ),
            ],
          ),
          body: GestureDetector(
            onTap: () {
             setState(() {
               showEditor = true;
             });
            },
            child: Center(
              child: LindiStickerWidget(
                controller: controller,
                child: Image.file(
                  File(_imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
          ),

          

        ),
        if(showEditor)
        Scaffold(
          backgroundColor: Colors.black.withOpacity(0.85),
          body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: TextEditor(
                  fonts: Fonts().list(),
                  textStyle: const TextStyle(color: Colors.white),
                  minFontSize: 10,
                  maxFontSize: 70,
                  onEditCompleted: (style, align, text) {
                   setState(() {
                    showEditor = false;
                    if(text.isNotEmpty){
                      controller.addWidget(
                          Text(text,
                            textAlign: align,
                            style: style,
                          )
                      );
                    }
                  });
                  },
                )),
          ),
        )
      ],
    );
  }
}

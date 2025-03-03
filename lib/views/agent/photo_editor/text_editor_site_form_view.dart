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

class TextEditorSiteFormView extends StatefulWidget {
  final String selectedImagePath;

  const TextEditorSiteFormView({Key? key, required this.selectedImagePath})
      : super(key: key);

  @override
  State<TextEditorSiteFormView> createState() => _TextEditorSiteFormViewState();
}

class _TextEditorSiteFormViewState extends State<TextEditorSiteFormView> {
  String _imagePath = '';
  late AppImageProvider imageProvider;
  LindiController controller = LindiController();
  bool showEditor = true;

  @override
  void initState() {
    super.initState();
    _imagePath = '';
    if (widget.selectedImagePath.isNotEmpty) {
      _imagePath = widget.selectedImagePath;
    }
    print("image site path is ${widget.selectedImagePath}");
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

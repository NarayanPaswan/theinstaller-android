import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

class DownloadVideoProgressDialog extends StatefulWidget {
  final String videoUrl;

  DownloadVideoProgressDialog({required this.videoUrl});

  @override
  _DownloadVideoProgressDialogState createState() => _DownloadVideoProgressDialogState();
}

class _DownloadVideoProgressDialogState extends State<DownloadVideoProgressDialog> {
  Dio dio = Dio();
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    startDownloading();
  }

  void startDownloading() async {
    try {
      var tempDir = await getTemporaryDirectory();
      String fileName = path.basename(widget.videoUrl);
      String fullPath = path.join(tempDir.path, fileName);

      await dio.download(
        widget.videoUrl,
        fullPath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              progress = received / total;
            });
          }
        },
      );

      final result = await ImageGallerySaver.saveFile(fullPath);

      if (result != null && result["isSuccess"]) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Download Complete"),
            content: const Text("Video saved to gallery successfully."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } else {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Download Failed"),
            content: const Text("Error saving video to gallery."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Download Failed"),
          content: const Text("An error occurred while downloading the video."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator.adaptive(),
          const SizedBox(height: 20),
          Text(
            "Downloading: ${(progress * 100).toInt()}%",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }
}

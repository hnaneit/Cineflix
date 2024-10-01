import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final String videoURL = "https://www.youtube.com/embed/qaf5W8S3xFw";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
        } else {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: [SystemUiOverlay.top]);
        }

        return Scaffold(
          appBar: orientation == Orientation.portrait
              ? AppBar(
                  title: const Text('Hướng dẫn sử dụng'),
                )
              : null,
          body: SizedBox(
            height: 250,
            child: videoURL != null
                ? WebViewWidget(
                    controller: WebViewController()
                      ..setJavaScriptMode(JavaScriptMode.unrestricted)
                      ..loadRequest(Uri.parse(videoURL)),
                  )
                : const Center(child: Text('Không có liên kết')),
          ),
        );
      },
    );
  }
}

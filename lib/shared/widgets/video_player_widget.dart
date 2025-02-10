import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({super.key, this.videoPath, this.videoLink});
  final String? videoPath;
  final String? videoLink;
  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  @override
  void initState() {
    if (widget.videoLink != null) {
      videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(
          widget.videoLink ?? "",
        )..replace(scheme: "https"),
      );
    } else {
      videoPlayerController =
          VideoPlayerController.file(File(widget.videoPath ?? ""));
    }

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      looping: true,
      autoInitialize: true,
      allowFullScreen: true,
      allowPlaybackSpeedChanging: false,
      showControls: true,
      showOptions: false,
      showControlsOnInitialize: true,
      aspectRatio: 16 / 9,
      placeholder: const Center(
        child: CircularProgressIndicator(),
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: chewieController,
    );
  }
}

import 'dart:io';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({
    super.key,
    required this.url,
    required this.dataSourceType,
  });

  final String url;
  final DataSourceType dataSourceType;

  @override
  VideoPlayerViewState createState() => VideoPlayerViewState();

}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  

  @override
  void initState() {
    super.initState();
    _setupVideo();
  }

  Future<void> _setupVideo() async {
    VideoPlayerController controller;

    switch (widget.dataSourceType) {
      case DataSourceType.asset:
        controller = VideoPlayerController.asset(widget.url);
        break;
      case DataSourceType.network:
        final file = await DefaultCacheManager().getSingleFile(widget.url);
        controller = VideoPlayerController.file(File(file.path));
        break;
      case DataSourceType.file:
        controller = VideoPlayerController.file(File(widget.url));
        break;
      case DataSourceType.contentUri:
        controller = VideoPlayerController.contentUri(Uri.parse(widget.url));
        break;
    }

    await controller.initialize();

    setState(() {
      _videoPlayerController = controller;
      _chewieController = ChewieController(
        autoInitialize: true,
        autoPlay: true,
        videoPlayerController: controller,
        materialProgressColors: ChewieProgressColors(playedColor: CbColors.primary),
        customControls: CupertinoControls(
          backgroundColor: CbColors.dark,
          iconColor: CbColors.grey,
        ),
      );
    });
  }

  void stopVideo() {
    _chewieController?.pause();
    _videoPlayerController?.pause();
    _videoPlayerController?.seekTo(Duration.zero);

    _chewieController?.dispose();
    _videoPlayerController?.dispose();

    _chewieController = null;
    _videoPlayerController = null;
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    if (_chewieController != null &&
        _videoPlayerController != null &&
        _videoPlayerController!.value.isInitialized) {
      return AspectRatio(
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50)
          ),
          child: Chewie(controller: _chewieController!)
        ),
      );
    }

    return const Center(child: CircularProgressIndicator());
  }
}

class VideoPlayerViewState extends _VideoPlayerViewState {}

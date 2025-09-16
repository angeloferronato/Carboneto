import 'dart:io';

import 'package:carboneto/utils/constants/colors.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({super.key, required this.url, required this.dataSourceType});

  final String url;
  final DataSourceType dataSourceType;

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late VideoPlayerController _videoPlayerController;

  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
   
    switch (widget.dataSourceType) {
      case DataSourceType.asset:
        _videoPlayerController = VideoPlayerController.asset(widget.url);
        break;
      case DataSourceType.network:
        _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.url));
        break;
      case DataSourceType.file:
        _videoPlayerController = VideoPlayerController.file(File(widget.url));
        break;
      case DataSourceType.contentUri:
        _videoPlayerController = VideoPlayerController.contentUri(Uri.parse(widget.url));
        break;
    }


    _videoPlayerController.initialize().then(
      (_) => setState(
        () => _chewieController = ChewieController(
          autoInitialize: true,
          autoPlay: true,
          videoPlayerController: _videoPlayerController,
          materialProgressColors: ChewieProgressColors(
            playedColor: CbColors.primary
          ),
          customControls: CupertinoControls(
            backgroundColor: CbColors.dark,
            iconColor: CbColors.grey,
            
          ),
        )
      )
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child:  _videoPlayerController.value.isInitialized 
        ? Chewie(
          controller: _chewieController,
        )
        : const SizedBox()
    );
  }
}
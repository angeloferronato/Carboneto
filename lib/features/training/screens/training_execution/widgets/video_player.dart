import 'dart:async';
import 'dart:io';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

Duration _clampDuration(Duration value, Duration min, Duration max) {
  if (value < min) return min;
  if (value > max) return max;
  return value;
}

String _formatDuration(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return h > 0 ? '$h:$m:$s' : '$m:$s';
}

void _showOptionsMenu(
  BuildContext context, {
  required VideoPlayerController controller,
  required VoidCallback onClose,
  required VoidCallback onOpen,
}) {
  onOpen();
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color.fromARGB(255, 30, 30, 30),
    showDragHandle: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    builder: (ctx) => _OptionsSheet(controller: controller, context: ctx),
  ).then((_) => onClose());
}

class _OptionsSheet extends StatefulWidget {
  const _OptionsSheet({required this.controller, required this.context});
  final VideoPlayerController controller;
  final BuildContext context;

  @override
  State<_OptionsSheet> createState() => _OptionsSheetState();
}

class _OptionsSheetState extends State<_OptionsSheet> {
  bool _showSpeeds = false;
  static const _speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_showSpeeds) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                  onPressed: () => setState(() => _showSpeeds = false),
                ),
                const Text('Velocidade',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          ..._speeds.map((speed) {
            final isSelected = widget.controller.value.playbackSpeed == speed;
            return ListTile(
              title: Text(
                speed == 1.0 ? 'Normal' : '${speed}x',
                style: TextStyle(
                  color: isSelected ? CbColors.primary : Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: isSelected ? Icon(Icons.check_rounded, color: CbColors.primary) : null,
              onTap: () {
                widget.controller.setPlaybackSpeed(speed);
                setState(() {});
                Navigator.pop(context);
              },
            );
          }),
        ] else ...[
          _OptionTile(
            icon: Icons.speed_rounded,
            label: 'Velocidade de reprodução',
            onTap: () => setState(() => _showSpeeds = true),
          ),
          StatefulBuilder(
            builder: (_, setTileState) => _OptionTile(
              icon: Icons.loop_rounded,
              label: 'Loop',
              trailing: Switch(
                value: widget.controller.value.isLooping,
                onChanged: (v) {
                  widget.controller.setLooping(v);
                  setTileState(() {});
                },
                activeThumbColor: CbColors.primary,
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.onTap, required this.child, this.size = 52});
  final VoidCallback onTap;
  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          shape: BoxShape.circle,
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.icon, required this.label, this.onTap, this.trailing});
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class _VideoControls extends StatelessWidget {
  const _VideoControls({
    required this.controller,
    required this.showControls,
    required this.isFullscreen,
    required this.onPlayPause,
    required this.onSeekRelative,
    required this.onSliderStart,
    required this.onSliderChanged,
    required this.onSliderEnd,
    required this.onFullscreen,
    required this.onOptions,
    this.onBack,
    this.showOptionsButton = true,
    this.showFullscreenButton = true,
  });

  final VideoPlayerController controller;
  final bool showControls;
  final bool isFullscreen;
  final bool showOptionsButton;
  final bool showFullscreenButton;
  final VoidCallback onPlayPause;
  final void Function(int seconds) onSeekRelative;
  final VoidCallback onSliderStart;
  final void Function(double value) onSliderChanged;
  final VoidCallback onSliderEnd;
  final VoidCallback onFullscreen;
  final VoidCallback onOptions;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: showControls ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      child: IgnorePointer(
        ignoring: !showControls,
        child: Stack(
          children: [
            Positioned(
              top: 0, left: 0, right: 0,
              child: Container(
                height: 90,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withValues(alpha: 0.65), Colors.transparent],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (onBack != null)
                      IconButton(
                        padding: const EdgeInsets.all(16),
                        icon: const Icon(Icons.fullscreen_exit_rounded, color: Colors.white, size: 28),
                        onPressed: onBack,
                      )
                    else
                      const SizedBox(width: 48),
                    if (showOptionsButton)
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: _CircleButton(
                          size: 42,
                          onTap: onOptions,
                          child: const Icon(Icons.more_vert_rounded, color: Colors.white, size: 22),
                        ),
                      )
                    else
                      const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                height: 110,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
                  ),
                ),
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _CircleButton(
                    onTap: () => onSeekRelative(-5),
                    child: const Icon(Icons.replay_5_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 28),
                  ValueListenableBuilder<VideoPlayerValue>(
                    valueListenable: controller,
                    builder: (_, value, __) => _CircleButton(
                      size: 68,
                      onTap: onPlayPause,
                      child: Icon(
                        value.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 42,
                      ),
                    ),
                  ),
                  const SizedBox(width: 28),
                  _CircleButton(
                    onTap: () => onSeekRelative(5),
                    child: const Icon(Icons.forward_5_rounded, color: Colors.white, size: 28),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: ValueListenableBuilder<VideoPlayerValue>(
                  valueListenable: controller,
                  builder: (_, value, __) {
                    final position = value.position;
                    final duration = value.duration;
                    final progress = duration.inMilliseconds > 0
                        ? (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0)
                        : 0.0;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 3,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                            activeTrackColor: CbColors.primary,
                            inactiveTrackColor: Colors.white.withValues(alpha: 0.25),
                            thumbColor: Colors.white,
                            overlayColor: CbColors.primary.withValues(alpha: 0.2),
                          ),
                          child: Slider(
                            value: progress,
                            onChanged: onSliderChanged,
                            onChangeStart: (_) => onSliderStart(),
                            onChangeEnd: (_) => onSliderEnd(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Row(
                            children: [
                              Text(
                                '${_formatDuration(position)} / ${_formatDuration(duration)}',
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              const Spacer(),
                              if (showFullscreenButton)
                                GestureDetector(
                                  onTap: onFullscreen,
                                  child: Icon(
                                    isFullscreen ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({
    super.key,
    required this.url,
    required this.dataSourceType,
    this.isOverVideo = false,
    this.showOptions = true,
    this.showFullscreen = true,
    this.isPaused = false,
  });

  final String url;
  final DataSourceType dataSourceType;
  final bool isOverVideo;
  final bool showOptions;
  final bool showFullscreen;
  final bool isPaused;

  @override
  VideoPlayerViewState createState() => VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _showControls = true;
  bool _isFullscreen = false;
  Timer? _hideTimer;
  double _dragStartDx = 0;
  Duration _dragStartPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    _setupVideo();
  }

  @override
  void didUpdateWidget(VideoPlayerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPaused != widget.isPaused && _isInitialized && _controller != null) {
      if (widget.isPaused) {
        _controller!.pause();
      } else {
        _controller!.play();
      }
    }
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
    controller.setLooping(true);
    if (!widget.isPaused) controller.play();

    if (!mounted) return;
    setState(() {
      _controller = controller;
      _isInitialized = true;
    });

    _startHideTimer();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showControls = false);
    });
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
    if (_showControls) _startHideTimer();
  }

  void _seekRelative(int seconds) {
    if (_controller == null) return;
    final target = _controller!.value.position + Duration(seconds: seconds);
    _controller!.seekTo(_clampDuration(target, Duration.zero, _controller!.value.duration));
    _startHideTimer();
  }

  void _togglePlayPause() {
    if (_controller == null) return;
    _controller!.value.isPlaying ? _controller!.pause() : _controller!.play();
    setState(() {});
    _startHideTimer();
  }

  void _toggleFullscreen() {
    if (_isFullscreen) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _isFullscreen = true);
    _hideTimer?.cancel();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _FullscreenVideoPlayer(controller: _controller!),
      ),
    ).then((_) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      if (mounted) setState(() => _isFullscreen = false);
      _startHideTimer();
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller?.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _controller == null) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(child: CircularProgressIndicator(color: CbColors.primary)),
      );
    }

    return ColoredBox(
      color: Colors.black,
      child: GestureDetector(
        onTap: _toggleControls,
        onHorizontalDragStart: (d) {
          _dragStartDx = d.globalPosition.dx;
          _dragStartPosition = _controller!.value.position;
        },
        onHorizontalDragUpdate: (d) {
          final diff = d.globalPosition.dx - _dragStartDx;
          final target = _dragStartPosition + Duration(seconds: (diff / 5).round());
          _controller!.seekTo(_clampDuration(target, Duration.zero, _controller!.value.duration));
        },
        onHorizontalDragEnd: (_) => _startHideTimer(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
            ),
            _VideoControls(
              showOptionsButton: widget.showOptions,
              showFullscreenButton: widget.showFullscreen,
              controller: _controller!,
              showControls: _showControls,
              isFullscreen: _isFullscreen,
              onPlayPause: _togglePlayPause,
              onSeekRelative: _seekRelative,
              onSliderStart: () => _hideTimer?.cancel(),
              onSliderChanged: (v) {
                final target = Duration(
                  milliseconds: (v * _controller!.value.duration.inMilliseconds).round(),
                );
                _controller!.seekTo(target);
              },
              onSliderEnd: _startHideTimer,
              onFullscreen: _toggleFullscreen,
              onOptions: () => _showOptionsMenu(
                context,
                controller: _controller!,
                onOpen: () => _hideTimer?.cancel(),
                onClose: _startHideTimer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FullscreenVideoPlayer extends StatefulWidget {
  const _FullscreenVideoPlayer({required this.controller});
  final VideoPlayerController controller;

  @override
  State<_FullscreenVideoPlayer> createState() => _FullscreenVideoPlayerState();
}

class _FullscreenVideoPlayerState extends State<_FullscreenVideoPlayer> {
  bool _showControls = true;
  Timer? _hideTimer;
  double _dragStartDx = 0;
  Duration _dragStartPosition = Duration.zero;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _startHideTimer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showControls = false);
    });
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
    if (_showControls) _startHideTimer();
  }

  void _seekRelative(int seconds) {
    final target = widget.controller.value.position + Duration(seconds: seconds);
    widget.controller.seekTo(_clampDuration(target, Duration.zero, widget.controller.value.duration));
    _startHideTimer();
  }

  void _togglePlayPause() {
    widget.controller.value.isPlaying
        ? widget.controller.pause()
        : widget.controller.play();
    setState(() {});
    _startHideTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        onHorizontalDragStart: (d) {
          _dragStartDx = d.globalPosition.dx;
          _dragStartPosition = widget.controller.value.position;
        },
        onHorizontalDragUpdate: (d) {
          final diff = d.globalPosition.dx - _dragStartDx;
          final target = _dragStartPosition + Duration(seconds: (diff / 5).round());
          widget.controller.seekTo(
            _clampDuration(target, Duration.zero, widget.controller.value.duration),
          );
        },
        onHorizontalDragEnd: (_) => _startHideTimer(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: widget.controller.value.aspectRatio,
                child: VideoPlayer(widget.controller),
              ),
            ),
            _VideoControls(
              controller: widget.controller,
              showControls: _showControls,
              isFullscreen: true,
              onPlayPause: _togglePlayPause,
              onSeekRelative: _seekRelative,
              onSliderStart: () => _hideTimer?.cancel(),
              onSliderChanged: (v) {
                final target = Duration(
                  milliseconds: (v * widget.controller.value.duration.inMilliseconds).round(),
                );
                widget.controller.seekTo(target);
              },
              onSliderEnd: _startHideTimer,
              onFullscreen: () => Navigator.of(context).pop(),
              onBack: () => Navigator.of(context).pop(),
              onOptions: () => _showOptionsMenu(
                context,
                controller: widget.controller,
                onOpen: () => _hideTimer?.cancel(),
                onClose: _startHideTimer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPlayerViewState extends _VideoPlayerViewState {}
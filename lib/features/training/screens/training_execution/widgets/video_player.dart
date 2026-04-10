import 'dart:async';
import 'dart:io';

import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

// ---------------------------------------------------------------------------
// Utilities
// ---------------------------------------------------------------------------

Duration _clamp(Duration value, Duration min, Duration max) {
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

// ---------------------------------------------------------------------------
// Public entry point
// ---------------------------------------------------------------------------

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({
    super.key,
    required this.url,
    required this.dataSourceType,
    this.isOverVideo = false,
    this.showOptions = true,
    this.showFullscreen = true,
    this.isPaused = false,
    this.normalBottomPadding = 0.0,
  });

  final String url;
  final DataSourceType dataSourceType;
  final bool isOverVideo;
  final bool showOptions;
  final bool showFullscreen;
  final bool isPaused;
  final double normalBottomPadding;

  @override
  VideoPlayerViewState createState() => VideoPlayerViewState();
}

class VideoPlayerViewState extends _VideoPlayerViewState {}

// ---------------------------------------------------------------------------
// Shared controller logic (base state)
// ---------------------------------------------------------------------------

abstract class _BaseVideoPlayerState<T extends StatefulWidget>
    extends State<T> {
  VideoPlayerController? controller;
  bool isInitialized = false;
  bool isDisposed = false;
  bool showControls = true;
  bool showOptions = false;
  Timer? hideTimer;
  double _dragStartDx = 0;
  Duration _dragStartPosition = Duration.zero;

  String get videoUrl;
  DataSourceType get videoDataSourceType;
  Duration get startPosition => Duration.zero;
  bool get startPlaying => true;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  @override
  void dispose() {
    isDisposed = true;
    hideTimer?.cancel();
    controller?.pause();
    controller?.dispose();
    controller = null;
    super.dispose();
  }

  Future<VideoPlayerController> _buildController() async {
    switch (videoDataSourceType) {
      case DataSourceType.asset:
        return VideoPlayerController.asset(videoUrl);
      case DataSourceType.network:
        final file = await DefaultCacheManager().getSingleFile(videoUrl);
        return VideoPlayerController.file(File(file.path));
      case DataSourceType.file:
        return VideoPlayerController.file(File(videoUrl));
      case DataSourceType.contentUri:
        return VideoPlayerController.contentUri(Uri.parse(videoUrl));
    }
  }

  Future<void> _initVideo() async {
    final vc = await _buildController();

    await vc.initialize();
    await vc.seekTo(startPosition);
    vc.setLooping(true);
    if (startPlaying) await vc.play();

    if (!mounted || isDisposed) {
      await vc.dispose();
      return;
    }

    setState(() {
      controller = vc;
      isInitialized = true;
    });

    _startHideTimer();
  }

  void _startHideTimer() {
    hideTimer?.cancel();
    hideTimer = Timer(
      const Duration(seconds: 3),
      () {
        if (mounted && !isDisposed) setState(() => showControls = false);
      },
    );
  }

  void toggleControls() {
    if (isDisposed) return;
    setState(() => showControls = !showControls);
    if (showControls) _startHideTimer();
  }

  void seekRelative(int seconds) {
    final vc = controller;
    if (vc == null || isDisposed) return;
    final target = vc.value.position + Duration(seconds: seconds);
    vc.seekTo(_clamp(target, Duration.zero, vc.value.duration));
    _startHideTimer();
  }

  void togglePlayPause() {
    final vc = controller;
    if (vc == null || isDisposed) return;
    vc.value.isPlaying ? vc.pause() : vc.play();
    setState(() {});
    _startHideTimer();
  }

  void onSliderChanged(double value) {
    final vc = controller;
    if (vc == null || isDisposed) return;
    vc.seekTo(
      Duration(
        milliseconds: (value * vc.value.duration.inMilliseconds).round(),
      ),
    );
  }

  Widget buildVideoStack({
    required bool isFullscreen,
    required VoidCallback onFullscreen,
    bool showOptionsButton = true,
    double bottomPadding = 0.0,
  }) {
    final vc = controller!;
    final size = vc.value.size;
    
    final isVertical = size.width > 0 && size.height > size.width;

    Widget videoLayer;
    if (isVertical) {
      videoLayer = SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: VideoPlayer(vc),
          ),
        ),
      );
    } else {
      videoLayer = Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Center(
          child: AspectRatio(
            aspectRatio: vc.value.aspectRatio,
            child: VideoPlayer(vc),
          ),
        ),
      );
    }

    // Wrapped in ClipRect to ensure the video NEVER bleeds out of your 70% height box
    return ClipRect(
      child: GestureDetector(
        // HitTestBehavior.opaque forces the transparent parts of the screen to catch your taps
        behavior: HitTestBehavior.opaque,
        onTap: toggleControls,
        onHorizontalDragStart: (d) {
          _dragStartDx = d.globalPosition.dx;
          _dragStartPosition = vc.value.position;
        },
        onHorizontalDragUpdate: (d) {
          if (isDisposed) return;
          final delta = d.globalPosition.dx - _dragStartDx;
          final target =
              _dragStartPosition + Duration(seconds: (delta / 5).round());
          vc.seekTo(_clamp(target, Duration.zero, vc.value.duration));
        },
        onHorizontalDragEnd: (_) => _startHideTimer(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            videoLayer, 
            _VideoControls(
              controller: vc,
              showControls: showControls,
              isFullscreen: isFullscreen,
              showOptionsButton: showOptionsButton,
              bottomPadding: bottomPadding,
              onPlayPause: togglePlayPause,
              onSeekRelative: seekRelative,
              onSliderStart: hideTimer?.cancel,
              onSliderChanged: onSliderChanged,
              onSliderEnd: _startHideTimer,
              onFullscreen: onFullscreen,
              onOptions: () => _OptionsSheet.show(
                context,
                controller: vc,
                onOpen: hideTimer?.cancel,
                onClose: _startHideTimer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// VideoPlayerView state (inline / non-fullscreen)
// ---------------------------------------------------------------------------

class _VideoPlayerViewState
    extends _BaseVideoPlayerState<VideoPlayerView> {
  @override
  String get videoUrl => widget.url;

  @override
  DataSourceType get videoDataSourceType => widget.dataSourceType;

  @override
  bool get startPlaying => !widget.isPaused;

  @override
  void didUpdateWidget(VideoPlayerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPaused != widget.isPaused && isInitialized) {
      widget.isPaused ? controller?.pause() : controller?.play();
    }
  }

  Future<void> _enterFullscreen() async {
    final vc = controller;
    if (vc == null || isDisposed || !isInitialized) return;

    final position = vc.value.position;
    final wasPlaying = vc.value.isPlaying;
    await vc.pause();

    if (!mounted) return;

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _FullscreenPage(
          url: widget.url,
          dataSourceType: widget.dataSourceType,
          startPosition: position,
          startPlaying: wasPlaying,
        ),
      ),
    );

    if (!mounted || isDisposed) return;

    await Future.wait([
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge),
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    ]);

    if (wasPlaying) controller?.play();
    _startHideTimer();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialized || controller == null) {
      return const ColoredBox(
        color: Color.fromARGB(255, 18, 24, 27),
        child: Center(
          child: CircularProgressIndicator(color: CbColors.primary),
        ),
      );
    }

    return ColoredBox(
      color: Color.fromARGB(255, 18, 24, 27),
      child: buildVideoStack(
        isFullscreen: false,
        onFullscreen: widget.showFullscreen ? _enterFullscreen : () {},
        showOptionsButton: widget.showOptions,
        bottomPadding: widget.normalBottomPadding,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Fullscreen page
// ---------------------------------------------------------------------------

class _FullscreenPage extends StatefulWidget {
  const _FullscreenPage({
    required this.url,
    required this.dataSourceType,
    required this.startPosition,
    required this.startPlaying,
  });

  final String url;
  final DataSourceType dataSourceType;
  final Duration startPosition;
  final bool startPlaying;

  @override
  State<_FullscreenPage> createState() => _FullscreenPageState();
}

class _FullscreenPageState extends _BaseVideoPlayerState<_FullscreenPage> {
  @override
  String get videoUrl => widget.url;

  @override
  DataSourceType get videoDataSourceType => widget.dataSourceType;

  @override
  Duration get startPosition => widget.startPosition;

  @override
  bool get startPlaying => widget.startPlaying;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialized || controller == null) {
      return const Scaffold(
        backgroundColor: Color.fromARGB(255, 18, 24, 27),
        body: Center(
          child: CircularProgressIndicator(color: CbColors.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 18, 24, 27),
      body: buildVideoStack(
        isFullscreen: true,
        onFullscreen: () => Navigator.of(context).pop(),
        bottomPadding: 0.0,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Controls overlay
// ---------------------------------------------------------------------------

class _VideoControls extends StatelessWidget {
  const _VideoControls({
    required this.controller,
    required this.showControls,
    required this.isFullscreen,
    required this.onPlayPause,
    required this.onSeekRelative,
    required this.onSliderChanged,
    required this.onSliderEnd,
    required this.onFullscreen,
    required this.onOptions,
    this.onSliderStart,
    this.showOptionsButton = true,
    this.bottomPadding = 0.0,
  });

  final VideoPlayerController controller;
  final bool showControls;
  final bool isFullscreen;
  final bool showOptionsButton;
  final double bottomPadding;
  final VoidCallback onPlayPause;
  final void Function(int seconds) onSeekRelative;
  final VoidCallback? onSliderStart;
  final void Function(double value) onSliderChanged;
  final VoidCallback onSliderEnd;
  final VoidCallback onFullscreen;
  final VoidCallback onOptions;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: showControls ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      child: IgnorePointer(
        ignoring: !showControls,
        child: Stack(
          children: [            
            if (showOptionsButton)
              Positioned(
                top: 10,
                right: 10,
                child: _CircleButton(
                  size: 42,
                  onTap: onOptions,
                  child: const Icon(
                    Icons.more_vert_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),            
            _CenterControls(
              controller: controller,
              bottomPadding: bottomPadding,
              onPlayPause: onPlayPause,
              onSeekRelative: onSeekRelative,
            ),
            
            _BottomBar(
              controller: controller,
              isFullscreen: isFullscreen,
              bottomPadding: bottomPadding,
              onSliderStart: onSliderStart,
              onSliderChanged: onSliderChanged,
              onSliderEnd: onSliderEnd,
              onFullscreen: onFullscreen,
            ),
          ],
        ),
      ),
    );
  }
}

// class _TopGradient extends StatelessWidget {
//   const _TopGradient();

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       top: 0,
//       left: 0,
//       right: 0,
//       child: IgnorePointer(
//         child: Container(
//           height: 90,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: [
//                 Color.fromARGB(255, 18, 24, 27).withValues(alpha: 0.65),
//                 Colors.transparent,
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _BottomGradient extends StatelessWidget {
//   const _BottomGradient({this.bottomPadding = 0.0});

//   final double bottomPadding;

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       bottom: bottomPadding,
//       left: 0,
//       right: 0,
//       child: IgnorePointer(
//         child: Container(
//           height: 110,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.bottomCenter,
//               end: Alignment.topCenter,
//               colors: [
//                 Color.fromARGB(255, 18, 24, 27).withValues(alpha: 0.7),
//                 Colors.transparent,
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class _CenterControls extends StatelessWidget {
  const _CenterControls({
    required this.controller,
    required this.onPlayPause,
    required this.onSeekRelative,
    this.bottomPadding = 0.0,
  });

  final VideoPlayerController controller;
  final VoidCallback onPlayPause;
  final void Function(int seconds) onSeekRelative;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _CircleButton(
              onTap: () => onSeekRelative(-5),
              child: const Icon(
                Icons.replay_5_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 28),
            ValueListenableBuilder<VideoPlayerValue>(
              valueListenable: controller,
              builder: (_, value, __) => _CircleButton(
                size: 68,
                onTap: onPlayPause,
                child: Icon(
                  value.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 42,
                ),
              ),
            ),
            const SizedBox(width: 28),
            _CircleButton(
              onTap: () => onSeekRelative(5),
              child: const Icon(
                Icons.forward_5_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.controller,
    required this.isFullscreen,
    required this.onSliderChanged,
    required this.onSliderEnd,
    required this.onFullscreen,
    this.onSliderStart,
    this.bottomPadding = 0.0,
  });

  final VideoPlayerController controller;
  final bool isFullscreen;
  final VoidCallback? onSliderStart;
  final void Function(double value) onSliderChanged;
  final VoidCallback onSliderEnd;
  final VoidCallback onFullscreen;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottomPadding,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: ValueListenableBuilder<VideoPlayerValue>(
          valueListenable: controller,
          builder: (_, value, __) {
            final position = value.position;
            final duration = value.duration;
            final progress = duration.inMilliseconds > 0
                ? (position.inMilliseconds / duration.inMilliseconds)
                    .clamp(0.0, 1.0)
                : 0.0;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 7),
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 14),
                    activeTrackColor: CbColors.primary,
                    inactiveTrackColor: Colors.white.withValues(alpha: 0.25),
                    thumbColor: Colors.white,
                    overlayColor: CbColors.primary.withValues(alpha: 0.2),
                  ),
                  child: Slider(
                    value: progress,
                    onChangeStart: (_) => onSliderStart?.call(),
                    onChanged: onSliderChanged,
                    onChangeEnd: (_) => onSliderEnd(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      Text(
                        '${_formatDuration(position)} / ${_formatDuration(duration)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: onFullscreen,
                        child: Icon(
                          isFullscreen
                              ? Icons.fullscreen_exit_rounded
                              : Icons.fullscreen_rounded,
                          color: Colors.white,
                          size: 26,
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
    );
  }
}

// ---------------------------------------------------------------------------
// Reusable widgets
// ---------------------------------------------------------------------------

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.onTap,
    required this.child,
    this.size = 52,
  });

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
          color: Color.fromARGB(255, 18, 24, 27).withValues(alpha: 0.45),
          shape: BoxShape.circle,
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.label,
    this.onTap,
    this.trailing,
  });

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

// ---------------------------------------------------------------------------
// Options bottom sheet
// ---------------------------------------------------------------------------

class _OptionsSheetShell extends StatelessWidget {
  const _OptionsSheetShell({required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1C),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 14, bottom: 4),
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SingleChildScrollView(
              child: _OptionsSheet(controller: controller),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionsSheet extends StatefulWidget {
  const _OptionsSheet({required this.controller});

  final VideoPlayerController controller;

  static void show(
    BuildContext context, {
    required VideoPlayerController controller,
    VoidCallback? onOpen,
    VoidCallback? onClose,
  }) {
    onOpen?.call();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent, 
      isScrollControlled: true,
      showDragHandle: false,
      useSafeArea: false,
      builder: (_) => _OptionsSheetShell(controller: controller),
    ).whenComplete(() => onClose?.call());
  }

  @override
  State<_OptionsSheet> createState() => _OptionsSheetState();
}

class _OptionsSheetState extends State<_OptionsSheet> {
  static const _speeds = <double>[0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
  bool _showSpeeds = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_showSpeeds) _buildSpeedList() else _buildMainMenu(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildMainMenu() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
    );
  }

  Widget _buildSpeedList() {
    final currentSpeed = widget.controller.value.playbackSpeed;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                onPressed: () => setState(() => _showSpeeds = false),
              ),
              const Text(
                'Velocidade',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        ..._speeds.map((speed) {
          final isSelected = currentSpeed == speed;
          return ListTile(
            title: Text(
              speed == 1.0 ? 'Normal' : '${speed}x',
              style: TextStyle(
                color: isSelected ? CbColors.primary : Colors.white,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            trailing: isSelected
                ? Icon(Icons.check_rounded, color: CbColors.primary)
                : null,
            onTap: () {
              widget.controller.setPlaybackSpeed(speed);
              Navigator.pop(context);
            },
          );
        }),
      ],
    );
  }
}
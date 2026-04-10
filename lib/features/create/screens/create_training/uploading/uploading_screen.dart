import 'package:carboneto/features/create/controllers/upload_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// YouTube-style floating upload overlay.
/// Place this as a [Stack] child on the CreateTraining screen.
/// It is only visible when [UploadStatusController.isActive] is true.
class UploadOverlayWidget extends StatelessWidget {
  const UploadOverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Using the REAL controller
    final controller = Get.find<UploadStatusController>();

    // FIX: Positioned must be on the OUTSIDE, Obx on the INSIDE.
    return Positioned(
      bottom: 28,
      left: 16,
      right: 16,
      child: Obx(() {
        // Note: isActive is a getter in your real controller, so we don't use .value
        if (!controller.isActive) return const SizedBox.shrink();

        return _UploadCard(controller: controller);
      }),
    );
  }
}

class _UploadCard extends StatelessWidget {
  final UploadStatusController controller;
  const _UploadCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isMinimized = controller.isMinimized.value;
      final state = controller.state.value;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(174, 70, 123, 184),
              Color.fromARGB(218, 21, 46, 66)
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: CbColors.primary.withOpacity(0.18),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
          color: CbColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF223142),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Progress bar always on top
              if (state == UploadState.uploading ||
                  state == UploadState.preparing ||
                  state == UploadState.processing)
                _AnimatedProgressBar(controller: controller),

              if (!isMinimized) ...[
                _CardBody(controller: controller),
              ] else ...[
                _MinimizedBody(controller: controller),
              ],
            ],
          ),
        ),
      );
    });
  }
}

class _AnimatedProgressBar extends StatefulWidget {
  final UploadStatusController controller;
  const _AnimatedProgressBar({required this.controller});

  @override
  State<_AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<_AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _shineController;

  @override
  void initState() {
    super.initState();
    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _shineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // You can replace this with CbColors.primary if you prefer using your constant directly
    return Obx(() => TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: widget.controller.progress.value),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
          builder: (context, progressValue, _) {
            return Padding(
              // Give the glow some vertical space so it doesn't get clipped
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                height: 4,
                child: Stack(
                  // Crucial: This allows the glow to bleed outside the 4px height limit
                  clipBehavior: Clip.none,
                  children: [
                    // 1. The Background Track (Empty state)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    // 2. The Glowing Progress Fill
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progressValue,
                      child: Container(
                        decoration: BoxDecoration(
                          color: CbColors.primary,
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: [
                            BoxShadow(
                              // THE GLOW EFFECT 🌟
                              color: CbColors.primary.withOpacity(0.65),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 3. The Animated Shine Overlay
                    if (progressValue > 0)
                      FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progressValue,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: AnimatedBuilder(
                            animation: _shineController,
                            builder: (context, child) {
                              return FractionalTranslation(
                                translation: Offset(
                                  (_shineController.value * 2) - 1,
                                  0,
                                ),
                                child: child,
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.0),
                                    Colors.white
                                        .withOpacity(0.5), // The core shine
                                    Colors.white.withOpacity(0.0),
                                  ],
                                  stops: const [0.1, 0.5, 0.9],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}

class _CardBody extends StatelessWidget {
  final UploadStatusController controller;
  const _CardBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.state.value;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            _StateIcon(state: state),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.statusMessage.value,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                  if ([UploadState.uploading, UploadState.processing]
                      .contains(state))
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        '${(controller.progress.value * 100).toInt()}% concluído',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                    ),
                  if (state == UploadState.success)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        'Seu treino foi publicado!',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                    ),
                  if (state == UploadState.error)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        controller.errorMessage.value,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.red.shade400,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _ActionButtons(state: state, controller: controller),
          ],
        ),
      );
    });
  }
}

class _MinimizedBody extends StatelessWidget {
  final UploadStatusController controller;
  const _MinimizedBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => InkWell(
          onTap: controller.expand,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _StateIcon(state: controller.state.value),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    controller.statusMessage.value,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                ),
                Icon(Icons.expand_less_rounded, color: Colors.grey.shade500),
              ],
            ),
          ),
        ));
  }
}

class _StateIcon extends StatelessWidget {
  final UploadState state;
  const _StateIcon({required this.state});

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case UploadState.preparing:
      case UploadState.uploading:
      case UploadState.processing:
        return SizedBox(
          width: 36,
          height: 36,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    CbColors.primary,
                  ),
                ),
              ),
              Icon(
                Icons.cloud_upload_outlined,
                size: 18,
                color: CbColors.primary,
              ),
            ],
          ),
        );
      case UploadState.success:
        return Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: CbColors.success.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check_rounded, color: CbColors.success, size: 20),
        );
      case UploadState.error:
        return Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: CbColors.error.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.error_outline_rounded,
              color: CbColors.error, size: 20),
        );
      case UploadState.idle:
        return const SizedBox(width: 36, height: 36);
    }
  }
}

class _ActionButtons extends StatelessWidget {
  final UploadState state;
  final UploadStatusController controller;
  const _ActionButtons({required this.state, required this.controller});

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case UploadState.preparing:
      case UploadState.uploading:
      case UploadState.processing:
        return IconButton(
          icon: Icon(Icons.remove_rounded, color: Colors.grey.shade500),
          onPressed: controller.minimize,
          tooltip: 'Minimizar',
        );
      case UploadState.success:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                controller.reset();
              },
              child: const Text(
                'Fechar',
                style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans', color: CbColors.primary),
              ),
            ),
          ],
        );
      case UploadState.error:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.close_rounded, color: Colors.grey.shade500),
              onPressed: controller.reset,
              tooltip: 'Fechar',
            ),
          ],
        );
      case UploadState.idle:
        return const SizedBox.shrink();
    }
  }
}

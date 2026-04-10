import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/common/widgets/buttons/cb_primary_btn.dart';
import 'package:carboneto/features/training/controllers/notifications_controller.dart';
import 'package:carboneto/features/training/screens/home/widgets/notification_tile.dart';
import 'package:carboneto/features/training/screens/home/widgets/notification_tile_shimmer.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationsController controller =
        Get.put(NotificationsController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.markAllAsRead();
    });

    return Scaffold(
      appBar: CbAppBar(
        title: Text(
          'Notificações',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        showBackArrow: true,
        actions: [
          Obx(
            () => controller.notificationsList.isNotEmpty
                ? TextButton(
                    onPressed: () => _confirmClearAll(context, controller),
                    child: const Text(
                      'Limpar tudo',
                      style: TextStyle(color: CbColors.primary),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return ListView.builder(
            itemCount: 20,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, __) => const NotificationTileShimmer(),
          );
        }

        if (controller.notificationsList.isEmpty) {
          return const Center(child: Text('Não há notificações recentes.'));
        }

        return ListView.builder(
          itemCount: controller.notificationsList.length,
          itemBuilder: (_, index) {
            final notification = controller.notificationsList[index];
            return Dismissible(
              key: Key(notification.id ?? index.toString()),
              direction: DismissDirection.endToStart,
              onDismissed: (_) =>
                  controller.deleteNotification(notification.id!),
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                color: CbColors.primary,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: NotificationTile(notification: notification),
            );
          },
        );
      }),
    );
  }

  void _confirmClearAll(
      BuildContext context, NotificationsController controller) {
    showModalBottomSheet(
      context: context,
      showDragHandle: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              'Limpar notificações',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Tem certeza que deseja apagar todas as notificações? Esta ação não pode ser desfeita.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CbPrimaryBtn(
                    label: 'Apagar tudo',
                    onPressed: () {
                      Get.back();
                      controller.clearAllNotifications();
                    },
                    paddingV: 15,
                    paddingH: 40,
                    ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancelar', style: TextStyle(color: CbColors.lightGrey),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

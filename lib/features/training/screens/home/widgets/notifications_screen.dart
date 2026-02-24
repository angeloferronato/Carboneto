import 'package:carboneto/common/widgets/appbar/appbar.dart';
import 'package:carboneto/features/training/controllers/notifications_controller.dart';
import 'package:carboneto/features/training/screens/home/widgets/notification_tile.dart';
import 'package:carboneto/features/training/screens/home/widgets/notification_tile_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen ({
    super.key,
  });  

  @override
  Widget build(BuildContext context) {
    final NotificationsController notificationsController = Get.put(NotificationsController());
    return Scaffold(
      appBar: CbAppBar(
        title: Text(
          'Notificações',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        showBackArrow: true,
      ),
      body: Obx(
        () => notificationsController.isLoading.value
        ? ListView.builder(
          itemCount: 20,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (_, __) => NotificationTileShimmer(),
        ) 
        : notificationsController.notificationsList.isEmpty
          ? Center(child: Text('Não há notificações recentes.'),)
          : ListView.builder(
            itemCount: notificationsController.notificationsList.length,
            itemBuilder: (_, index) {
              return NotificationTile(
                notification: notificationsController.notificationsList[index],
              );
            }
          ),
      )
    );
  }
}




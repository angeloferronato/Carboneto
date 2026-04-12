import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/training/screens/home/widgets/notifications_screen.dart';
import 'package:carboneto/home_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

// 1. Mudei para GetxService!
class NotificationService extends GetxService {
  static NotificationService get instance => Get.find();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    await _requestPermission();
    await getToken();
    _setupForegroundListeners();
    _setupInteractedMessage();
  }

  Future<void> _requestPermission() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> getToken() async {
    String? token = await _firebaseMessaging.getToken();

    if (token != null) {
      await saveFirestoreToken(token);
    }

    // Sempre que tiver um novo token, ele salva na firestore
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      await saveFirestoreToken(newToken);
    });
  }

  Future<void> saveFirestoreToken(String token) async {
    final authUser = FirebaseAuth.instance.currentUser;

    if (authUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authUser.uid)
          .set({
        'FcmTokens': FieldValue.arrayUnion([token])
      }, SetOptions(merge: true));
    } 
  }

  Future<void> removeTokenOnLogout() async {
    String? token = await _firebaseMessaging.getToken();
    final authUser = FirebaseAuth.instance.currentUser;

    if (token != null && authUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authUser.uid)
          .set({
        'FcmTokens': FieldValue.arrayRemove([token])
      }, SetOptions(merge: true));
    }
  }

  void _setupForegroundListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // TODO: futuramente, podemos implementar alguma coisa pra ouvir enquanto o app estiver aberto.
    });
  }

  void _setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      handleMessageClick(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessageClick);
  }

  void handleMessageClick(RemoteMessage message) {
    Future.delayed(const Duration(milliseconds: 500), () {
      Get.put(UserController());
      Get.offAll(() => const HomeMenu());
      final homeController = Get.put(HomeMenuController());
      homeController.selectedIndex.value = 0;
      Get.to(NotificationsScreen());
    });
  }
}

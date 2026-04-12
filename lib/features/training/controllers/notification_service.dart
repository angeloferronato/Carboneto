import 'package:carboneto/features/training/screens/home/home.dart';
import 'package:carboneto/features/training/screens/home/widgets/notifications_screen.dart';
import 'package:carboneto/home_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

// 1. Mudei para GetxService!
class NotificationService extends GetxService {
  static NotificationService get instance => Get.find();

  // APAGUEI O Get.put(UserController) e UserRepository! Eles não são mais necessários aqui.

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    await _requestPermission();
    await getToken();
    _setupForegroundListeners();
    _setupInteractedMessage();
  }

  Future<void> _requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('Permissão do usuário: ${settings.authorizationStatus}');
  }

  Future<void> getToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      print("FCM Token: $token");

      if (token != null) {
        await saveFirestoreToken(token);
      }

      _firebaseMessaging.onTokenRefresh.listen((newToken) async {
        await saveFirestoreToken(newToken);
      });
    } catch (e) {
      print("Erro ao obter token: $e");
    }
  }

  Future<void> saveFirestoreToken(String token) async {
    final authUser = FirebaseAuth.instance.currentUser;

    if (authUser != null) {
      // 2. Mudei de update() para set() com merge: true. Isso evita erros de documento não encontrado!
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authUser.uid)
          .set({
        'FcmTokens': FieldValue.arrayUnion([token])
      }, SetOptions(merge: true));

      print('Token salvo no Firestore com sucesso!');
    } else {
      print('Usuário não está logado no Firebase Auth. Token não foi salvo.');
    }
  }

  Future<void> removeTokenOnLogout() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      final authUser = FirebaseAuth.instance.currentUser;

      if (token != null && authUser != null) {
        // 3. Aqui também atualizei para set com merge: true por segurança
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authUser.uid)
            .set({
          'FcmTokens': FieldValue.arrayRemove([token])
        }, SetOptions(merge: true));

        print('Token deste aparelho removido do Firestore com sucesso!');
      }
    } catch (e) {
      print("Erro ao remover token no logout: $e");
    }
  }

  void _setupForegroundListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Mensagem recebida em PRIMEIRO PLANO!');
      print('Dados: ${message.data}');

      if (message.notification != null) {
        print('Título: ${message.notification!.title}');
        print('Corpo: ${message.notification!.body}');
      }
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
    Get.offAll(() => const HomeMenu());
    final homeController = Get.put(HomeMenuController());
    homeController.selectedIndex.value = 1;
    Get.to(NotificationsScreen());
  }
}

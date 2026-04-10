import 'package:carboneto/data/repositories/authentication/authentication_repository.dart';
import 'package:carboneto/data/repositories/training/training_repository.dart';
import 'package:carboneto/data/repositories/user/user_repository.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carboneto/app.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';

void main() async {
  final WidgetsBinding widgetsBinding =  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase Initialization
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then(
    (FirebaseApp value) {
      Get.put(AuthenticationRepository());
      Get.lazyPut<TrainingRepository>(() => TrainingRepository());
      Get.lazyPut<UserRepository>(() => UserRepository());
    }
  );

  await FirebaseAppCheck.instance.activate(
    androidProvider: kDebugMode 
      ? AndroidProvider.debug
      : AndroidProvider.playIntegrity,

    appleProvider: kDebugMode
      ? AppleProvider.debug
      : AppleProvider.appAttest
  );

  // Keeps the splash screen while initializes
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // await dotenv.load(fileName: '.env');

  // Initialize the local storage
  await GetStorage.init();

  runApp(App());
}


import 'package:carboneto/features/authentication/screens/login/login.dart';
import 'package:carboneto/features/authentication/screens/onboarding/onboarding.dart';
import 'package:carboneto/features/personalization/models/user_model.dart';
import 'package:carboneto/features/training/screens/home/home.dart';
import 'package:carboneto/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:carboneto/utils/exceptions/firebase_exceptions.dart';
import 'package:carboneto/utils/exceptions/format_exceptions.dart';
import 'package:carboneto/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  final deviceStorage = GetStorage();

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  screenRedirect() async {
    deviceStorage.writeIfNull('isFirstTime', true);

    deviceStorage.read('isFirstTime') != true ? Get.offAll(() => LoginScreen()) : Get.offAll(OnBoardingScreen());
  }

  /// [Email Authentication] - REGISTER
  Future<UserCredential> registerWithEmailAndPassword(String email, String password, String username) async {
    try {
      final usernameDoc = await FirebaseFirestore.instance
        .collection('usernames')
        .doc(username)
        .get();

      if (usernameDoc.exists) {
        throw Exception('Nome de usuário já está em uso');
      }

      // Cria o usuário no Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      return userCredential;

    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch(e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch(_) {
      throw CbFormatException();
    } on PlatformException catch(e) {
      throw CbPlatformException(e.code).message;
    } catch(e) {
      throw 'Algo deu errado. Por favor tente novamente $e';
    }
  }


  /// [User or Email Authentication] - LOGIN
  Future<void> signIn(String userOrEmail, String senha) async {
    try {
      String email = userOrEmail;

      // Verifica se é um e-mail (contém '@'), senão procura o username
      if (!userOrEmail.contains('@')) {
        final query = await FirebaseFirestore.instance
            .collection('users')
            .where('Username', isEqualTo: userOrEmail)
            .limit(1)
            .get();

        if (query.docs.isNotEmpty) {
          final data = query.docs.first.data();
          email = data['Email'] as String;
        } else {
          throw Exception('Nome de usuário não encontrado');
        }
      }

      await _auth.signInWithEmailAndPassword(email: email, password: senha);

      Get.to(() => HomeScreen());
    } catch (e) {
      rethrow;
    }
  }

  /// [SignIn with Google] - LOGIN
  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);

    // Cria o documento do usuário no Firestore se não existir
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .get();

    if (!userDoc.exists) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'Id': userCredential.user!.uid,
        'Name': userCredential.user!.displayName ?? '',
        'Username': '',
        'Email': userCredential.user!.email ?? '',
      });
    }

    return userCredential;
  }
}




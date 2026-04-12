import 'package:carboneto/data/repositories/user/user_repository.dart';
import 'package:carboneto/features/authentication/screens/login/login.dart';
import 'package:carboneto/features/authentication/screens/onboarding/onboarding.dart';
import 'package:carboneto/features/authentication/screens/verify_email/verify_email.dart';
import 'package:carboneto/features/authentication/screens/welcome/welcome.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/training/controllers/notification_service.dart';
import 'package:carboneto/home_menu.dart';
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
  final userRepository = Get.put(UserRepository());
  final notificationService = Get.put(NotificationService());

  User? get authUser => _auth.currentUser;

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  bool get isLoggedAsGoogle =>
      authUser!.providerData.any((p) => p.providerId == 'google.com');
  bool get isLoggedOnlyAsGoogle =>
      authUser!.providerData.any((p) => p.providerId == 'google.com') &&
      authUser!.providerData.length == 1;
  bool get isLoggedAsPassword =>
      authUser!.providerData.any((p) => p.providerId == 'password');

  // Funtion to show Relevant Screen
  screenRedirect() async {
    final user = _auth.currentUser;

    if (user != null) {
      final isGoogleSignIn =
          user.providerData.any((p) => p.providerId == 'google.com');

      if (isGoogleSignIn || user.emailVerified) {
        Get.put(UserController());
        await notificationService.initialize();
        Get.offAll(() => WelcomeScreen());
      } else {
        Get.offAll(() => VerifyEmailScreen(
              email: user.email,
            ));
      }
    } else {
      deviceStorage.writeIfNull('isFirstTime', true);

      deviceStorage.read('isFirstTime') != true
          ? Get.offAll(() => LoginScreen())
          : Get.offAll(() => OnBoardingScreen());
    }
  }

  /// [Email Authentication] - REGISTER
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      if (await userRepository.usernameExists(username))
        throw Exception('Nome de usuário já está em uso');

      // Cria o usuário no Firebase Auth
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await _auth.currentUser?.reload();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw CbFormatException();
    } on PlatformException catch (e) {
      throw CbPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo deu errado. Por favor tente novamente $e';
    }
  }

  /// [Email Verification] - Email Verification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw CbFormatException();
    } on PlatformException catch (e) {
      throw CbPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo deu errado. Por favor tente novamente';
    }
  }

  /// [Email Verification] - Reset Password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw CbFormatException();
    } on PlatformException catch (e) {
      throw CbPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo deu errado. Por favor tente novamente $e';
    }
  }

  /// [User or Email Authentication] - LOGIN
  Future<void> loginWithEmailAndPassword(
      String userOrEmail, String password) async {
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

      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.to(() => HomeMenu());
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw CbFormatException();
    } on PlatformException catch (e) {
      throw CbPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo deu errado. Por favor tente novamente $e';
    }
  }

  /// [Re-authenticate with Credential] - NEW PASSWORD
  Future<void> reAuthWithEmailAndPassword(
      String email, String currentPassword) async {
    try {
      final cred =
          EmailAuthProvider.credential(email: email, password: currentPassword);

      await authUser!.reauthenticateWithCredential(cred);
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw CbFormatException();
    } on PlatformException catch (e) {
      throw CbPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo deu errado. Por favor tente novamente $e';
    }
  }

  /// [Verify before update email] - NEW PASSWORD
  Future<void> verifyBeforeUpdateEmail(String newEmail) async {
    try {
      await authUser!.verifyBeforeUpdateEmail(newEmail);
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw CbFormatException();
    } on PlatformException catch (e) {
      throw CbPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo deu errado. Por favor tente novamente $e';
    }
  }

  /// [Update user password] - NEW PASSWORD
  Future<void> updatePassword(String newPassword) async {
    try {
      await authUser!.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw CbFormatException();
    } on PlatformException catch (e) {
      throw CbPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo deu errado. Por favor tente novamente $e';
    }
  }

  /// [SignIn with Google] - LOGIN
  Future<List> loginWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      final GoogleSignInAccount? userAccount = await googleSignIn.signIn();

      final GoogleSignInAuthentication? googleAuth =
          await userAccount?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      return [userCredential, userAccount];
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw CbFormatException();
    } on PlatformException catch (e) {
      throw CbPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo deu errado. Por favor tente novamente $e';
    }
  }

  /// [Logout User] - Valid for any authentication
  Future<void> logout() async {
    try {
      await NotificationService.instance.removeTokenOnLogout();
      await GoogleSignIn().signOut();
      await _auth.signOut();
      Get.offAll(() => LoginScreen());
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw CbFormatException();
    } on PlatformException catch (e) {
      throw CbPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo deu errado. Por favor tente novamente $e';
    }
  }

  Future<void> reauthenticateAndDeleteWithGoogle() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;
      final googleSignIn = GoogleSignIn();

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await user.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw CbFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw CbFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw CbFormatException();
    } on PlatformException catch (e) {
      throw CbPlatformException(e.code).message;
    } catch (e) {
      throw 'Algo deu errado. Por favor tente novamente $e';
    }
  }
}

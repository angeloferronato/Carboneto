import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  bool isLoading = true;

  AuthService() {
    _authCheck();
  }

  void _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      this.user = user;
      isLoading = false;
      notifyListeners();
    });
  }

  void _getUser() {
    user = _auth.currentUser;
    notifyListeners();
  }

  Future<void> registrar(
      String nome, String username, String email, String senha) async {
    try {
      // Verifica se esse username existe
      final usernameDoc = await FirebaseFirestore.instance
          .collection('usernames')
          .doc(username)
          .get();

      if (usernameDoc.exists) {
        throw Exception('Nome de usuário já está em uso');
      }
      // Cria o usuário no Firebase Auth
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      await cred.user!.updateDisplayName(nome);

      // A senha não fica salva pq tem que ter um pouco de segurança nessa bagaça
      await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .set({
        'uid': cred.user!.uid,
        'nome': nome,
        'username': username,
        'email': email,
      });
      // Salva o username no Firestore
      await FirebaseFirestore.instance
          .collection('usernames')
          .doc(username)
          .set({
        'userId': cred.user!.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _getUser();
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> encontrarEmailPorUsername(String username) async {
    try {
      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final data = query.docs.first.data();
        return data['email'] as String?;
      }
      return null;
    } catch (e) {
      print('Erro ao buscar username: $e');
      return null;
    }
  }

  Future<void> login(String usuarioOuEmail, String senha) async {
    try {
      String email = usuarioOuEmail;

      // Verifica se é um e-mail (contém '@'), senão procura o username
      if (!usuarioOuEmail.contains('@')) {
        final query = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: usuarioOuEmail)
            .limit(1)
            .get();

        if (query.docs.isNotEmpty) {
          final data = query.docs.first.data();
          email = data['email'] as String;
        } else {
          throw Exception('Nome de usuário não encontrado');
        }
      }

      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      _getUser();
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}

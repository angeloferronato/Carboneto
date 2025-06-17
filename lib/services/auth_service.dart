import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

      _getUser();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      _getUser();
    } catch (e) {
      rethrow;
    }
  }
}

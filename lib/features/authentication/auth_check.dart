import 'package:carboneto/features/authentication/screens/login/login.dart';
import 'package:carboneto/home_menu.dart';
import 'package:carboneto/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);

    if(auth.isLoading) {
      return loading();
    }
    else if(auth.user == null) {
      return LoginScreen();
    } else {
      return HomeMenu();  
    }
  }
}

loading() {
  return Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );  
}

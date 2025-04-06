import 'package:diop_mouhamed_l3gl_examen/screens/home.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/home_page.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/login.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/register.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthManager extends StatefulWidget {
  const AuthManager({super.key});

  @override
  State<AuthManager> createState() => _AuthManagerState();
}

class _AuthManagerState extends State<AuthManager> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (_, snapshots) {
        if (snapshots.connectionState == ConnectionState.waiting) {
          return loadingComponent;
        }
        if (!snapshots.hasData) {
          return const  LoginPage();
        }
        return snapshots.data!.emailVerified ?
             const HomePage() :  loadingComponent;

      },
    );
  }
}

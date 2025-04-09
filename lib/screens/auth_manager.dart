import 'dart:io';

import 'package:diop_mouhamed_l3gl_examen/enum/user_role.dart';
import 'package:diop_mouhamed_l3gl_examen/models/my_user.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/admin_home_page.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/user_home.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/user_home_page.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/login.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/register.dart';
import 'package:diop_mouhamed_l3gl_examen/services/auth_service.dart';
import 'package:diop_mouhamed_l3gl_examen/services/firestore_db.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/loading.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/my_toast_notif.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class AuthManager extends StatefulWidget {
  const AuthManager({super.key});

  @override
  State<AuthManager> createState() => _AuthManagerState();
}

class _AuthManagerState extends State<AuthManager> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
  }
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
        bool isVerified = snapshots.data!.emailVerified;
        String email = snapshots.data!.email!;
        return isVerified ?
              FutureBuilder(
                 future: FirestoreDb().getUserByMail(email),
                 builder: (_, snapshot){
                   if(snapshot.connectionState == ConnectionState.waiting){
                     return loadingComponent;
                   }
                   if(!snapshot.hasData || snapshot.data == null){
                     return Text("Aucun utilisateur trouvé avec l'email : $email");
                   }
                   MyUser user = snapshot.data!;
                   UserRole role = user.role;
                   switch(role){
                     case UserRole.admin:
                       return const AdminHomePage();
                     case UserRole.defaultUser:
                       if(user.blocked){
                         AuthService().signOut().then((onValue) {

                           showError(message: "Votre compte a été bloqué ! Contacter l'administrateur à l'adresse zomethdev@gmail.com");
                         });
                         return loadingComponent;

                       }
                       return const UserHomePage();
                 }}
             )

            :  loadingComponent;

      },
    );
  }
  Future<void> requestPermission() async {
    if (!await Permission.notification.isGranted) {
      await Permission.notification.request();
    }

    if (Platform.isAndroid) {
      if (!await Permission.storage.isGranted) {
        await Permission.storage.request();
      }
      if (!await Permission.manageExternalStorage.isGranted) {
        await Permission.manageExternalStorage.request();
      }
    } else {
      if (!await Permission.storage.isGranted) {
        await Permission.storage.request();
      }
    }
  }
}

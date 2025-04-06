import 'package:diop_mouhamed_l3gl_examen/screens/user_home.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/notifications.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/profil.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/search_page.dart';
import 'package:diop_mouhamed_l3gl_examen/services/firestore_db.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bottom_nav_controller.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirestoreDb().listenStatusChanges();
  }
  @override
  Widget build(BuildContext context) {

    List<Widget> pages = [
      UserHome(),
      SearchPage(),
      Notifications(),
      Profil()
    ];

    return GetBuilder<BottomNavBarController>(
      init: BottomNavBarController(),
      builder: (controller) {
        return Scaffold(
          body: IndexedStack(
            index: controller.index,
            children: pages,
          ),
          bottomNavigationBar: BottomNavBar(),
        );
      }
    );
  }
}

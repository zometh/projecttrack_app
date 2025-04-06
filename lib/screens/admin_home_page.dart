import 'package:diop_mouhamed_l3gl_examen/screens/admin_home.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/users_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/bottom_nav_controller.dart';
import '../widgets/bottom_nav_bar.dart';
import 'admin_projects_page.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const AdminHome(),
      const AdminProjectsPage(),
      const UsersPage()
    ];
    return GetBuilder<BottomNavBarController>(
      init: BottomNavBarController(),
        builder: (controller){
          return Scaffold(
            body: IndexedStack(
              index: controller.index,
              children: pages,
            ),
            bottomNavigationBar: BottomNavBar(isAdmin: true),
          );
        }
        );

  }
}

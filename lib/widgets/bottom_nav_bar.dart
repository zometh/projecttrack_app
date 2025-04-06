
import 'package:diop_mouhamed_l3gl_examen/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bottom_nav_controller.dart';

class BottomNavBar extends StatelessWidget {
  final bool isAdmin;
  const BottomNavBar({super.key, this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    BottomNavBarController controller = Get.put(BottomNavBarController());
    List<BottomNavigationBarItem> items = isAdmin ? [
      buildItem("Accueil", Icons.home),
      buildItem("Projets", Icons.work),
      buildItem("Utilisateurs", Icons.people),
    ] : [
      buildItem("Accueil", Icons.home),
      buildItem("Rechercher",  Icons.search),
      buildItem("Notifications", Icons.notifications),
      buildItem("Profil", Icons.person),


    ];
    return BottomNavigationBar(
      currentIndex: controller.index,
      onTap: (index) => controller.updateIndex(index),
      elevation: 5,
      selectedIconTheme: IconThemeData(color: kprimary),
      selectedItemColor: kprimary,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      items: items,

    );

  }
  BottomNavigationBarItem buildItem(String label, IconData icon){
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label
    );
  }
}

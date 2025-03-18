import 'package:diop_mouhamed_l3gl_examen/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Container(
              height: 170.h,
              width: double.infinity,
              child: CircleAvatar(
                backgroundColor: kprimary,
                backgroundImage: NetworkImage(
                  "https://media.gettyimages.com/id/1446629309/photo/argentina-v-australia-round-of-16-fifa-world-cup-qatar-2022.jpg?b=1&s=594x594&w=0&k=20&c=62wT0Z00Y-1qws1eYBSxj_CVcaPHMJJQIVuPkFajQUY=",
                ),
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}

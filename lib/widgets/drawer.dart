import 'package:diop_mouhamed_l3gl_examen/config/colors.dart';
import 'package:diop_mouhamed_l3gl_examen/services/auth_service.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_button.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: SizedBox(
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
          CustomText(text: AuthService().connectedUserMail!),
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomButton(
              text: "Se déconnecter",
              onPressed: () async{
                Get.back();
                await AuthService().signOut();
              },
            ),
          ),
        ],
      ),
    );
  }
}

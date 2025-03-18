import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoProjectView extends StatelessWidget {
  const NoProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.h,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.folder_outlined, size: 50, color: Colors.grey),
        CustomText(text: "Aucun projet trouvé", fontWeight: FontWeight.w600),
        CustomText(
          text: "Cliquez sur le bouton plus pour créer un projet",

          fontSize: 12,
          color: Colors.grey.shade800,
        ),
      ],
    );
  }
}

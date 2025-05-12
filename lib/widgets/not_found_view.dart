import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotFoundWidget extends StatelessWidget {
  final bool isFileView;
  const NotFoundWidget({super.key, this.isFileView = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 8.h,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_outlined, size: 50, color: Colors.grey),
          CustomText(text: isFileView ? "Aucun fichier trouvé !" :"Aucun projet trouvé !", fontWeight: FontWeight.w600),
          if(!isFileView) CustomText(
            text: "Cliquez sur le bouton plus pour créer un projet",

            fontSize: 12,
            color: Colors.grey.shade800,
          ),
        ],
      ),
    );
  }
}

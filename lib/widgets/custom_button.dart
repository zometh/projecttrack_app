import 'package:diop_mouhamed_l3gl_examen/config/colors.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/fomat_text.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final Function() onPressed;
  final double fontSize;
  final IconData? icon;
  final String text;
  final Color? color;
   CustomButton({super.key, required this.text, required this.onPressed,this.fontSize = 20, this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size.width,
        height: 50.h,
        decoration: BoxDecoration(
          color: color ?? kprimary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: icon != null ?
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 4.w
            ,
            children: [
              CustomText(
                text: FormatText.formatTitle(text),
                color: Colors.white,
                adaptColor: false,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
              Icon(icon, color: Colors.white,)
            ],
          ) : CustomText(
            text: FormatText.formatTitle(text),
            color: Colors.white,
            adaptColor: false,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
          )
          ,
        ),
      ),
    );
  }
}

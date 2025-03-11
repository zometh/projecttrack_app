
import 'package:diop_mouhamed_l3gl_examen/config/colors.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/fomat_text.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final Function() onPressed;
  final String text;
  const CustomButton(
      {super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size.width,
        height: 50.h,
        decoration: BoxDecoration(
            color: kprimary,
            borderRadius: BorderRadius.circular(15)),
        child: Center(
          child: CustomText(
            text: FormatText.formatTitle(text),
           color: Colors.white,
            adaptColor: false,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );

  }
}

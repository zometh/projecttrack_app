import 'package:diop_mouhamed_l3gl_examen/config/colors.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/enum_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final CustomTextStyle customStyle;
  final FontWeight fontWeight;
  final bool adaptColor;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  CustomText({
    super.key,
    required this.text,
    this.fontSize = 15,
    this.color,
    this.customStyle = CustomTextStyle.primary,
    this.fontWeight = FontWeight.normal,
    this.adaptColor = true,
    this.textAlign,
    this.maxLines,
    this.overflow =  TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor =
        color ??
        Theme.of(context).textTheme.bodyLarge?.color ??
        ktextPrimaryLight;

    if (adaptColor && color == null) {
      bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
      textColor = isDarkMode ? ktextPrimaryDark : ktextPrimaryLight;
    }

    final responsiveFontSize = fontSize.sp;

    return Text(
      text,
      style:
          customStyle == CustomTextStyle.primary
              ? GoogleFonts.poppins(
                fontSize: responsiveFontSize,
                color: textColor,
                fontWeight: fontWeight,
              )
              : GoogleFonts.roboto(
                fontSize: responsiveFontSize,
                color: textColor,
                fontWeight: fontWeight,
              ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

import 'package:diop_mouhamed_l3gl_examen/config/colors.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/enum_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/*
class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  Color color;
  final CustomTextStyle customStyle;
  final FontWeight fontWeight;
  final bool adaptColor;
  CustomText({
    super.key,
    required this.text,
    this.fontSize = 15,
    this.color = ktextPrimaryLight,
    this.customStyle = CustomTextStyle.primary,
    this.fontWeight = FontWeight.normal,
    this.adaptColor = true,
  });

  @override
  Widget build(BuildContext context) {
    if (adaptColor) {
      bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
      color = isDarkMode ? ktextPrimaryDark : ktextPrimaryLight;
    }
    return Text(
      text,

      style:
          customStyle == CustomTextStyle.primary
              ? GoogleFonts.poppins(
                fontSize: fontSize,
                color: color,
                fontWeight: fontWeight,
              )
              : GoogleFonts.inter(
                fontSize: fontSize,
                color: color,
                fontWeight: fontWeight,
              ),
    );
  }
}
*/
class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color; // Make color nullable to use theme default
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
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    // Get colors from theme
    Color textColor =
        color ??
        Theme.of(context).textTheme.bodyLarge?.color ??
        ktextPrimaryLight;

    // Apply adaptive coloring if needed
    if (adaptColor && color == null) {
      bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
      textColor = isDarkMode ? ktextPrimaryDark : ktextPrimaryLight;
    }

    // Use ScreenUtil for responsive font sizing
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
              : GoogleFonts.inter(
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

import 'package:diop_mouhamed_l3gl_examen/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeConfig {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: kprimary,
    colorScheme: ColorScheme.light(
      primary: kprimary,
      secondary: ksecondary,
      tertiary: ktertiary,
      background: kbackgroundLight,
      surface: kcardLight,
    ),

    fontFamily: GoogleFonts.inter().fontFamily,
    appBarTheme: AppBarTheme(
      backgroundColor: kprimary,
      foregroundColor: Colors.white,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 19,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardTheme(
      color: kcardLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    scaffoldBackgroundColor: kbackgroundLight,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: kprimary,
    colorScheme: ColorScheme.dark(
      primary: kprimary,
      secondary: ksecondary,
      tertiary: ktertiary,
      background: kbackgroundDark,
      surface: kcardDark,
    ),
    fontFamily: GoogleFonts.inter().fontFamily,
    appBarTheme: AppBarTheme(
      backgroundColor: kcardDark,
      foregroundColor: ktextPrimaryDark,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 19,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardTheme(
      color: kcardDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    scaffoldBackgroundColor: kbackgroundDark,
  );
}

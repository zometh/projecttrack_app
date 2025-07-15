import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDialog{
  BuildContext context;
   CustomDialog({required this.context});
  alertDialogConfirm(VoidCallback onTap, String title, String message){

    AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.scale,
        title: title,
        desc: message,
        btnOkText: "Oui",
        btnCancelText: "Non",
        descTextStyle: GoogleFonts.poppins(),
        titleTextStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        btnCancelOnPress: () {},
    btnOkOnPress: onTap,
    ).show();

  }

}
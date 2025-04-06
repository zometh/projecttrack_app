import 'package:diop_mouhamed_l3gl_examen/config/colors.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/project_priority.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/project_status.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/role.dart';
import 'package:diop_mouhamed_l3gl_examen/models/my_user.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/format_project_text.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/specific_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'custom_text.dart';



class CardStatus extends StatelessWidget {
  final ProjectStatus? status;
  final ProjectPriority? priority;
  final UserProjectRole? role;
  final bool? isBlocked;
  final double fontSize;

  const CardStatus({
    super.key,
    this.priority,
    this.status,
    this.role,
    this.fontSize = 12,
    this.isBlocked,
  });

  @override
  Widget build(BuildContext context) {
    if (priority != null) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: getColorPriority(priority!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomText(
          text: FormatProjectText().getTextPriority(priority!),
          fontWeight: FontWeight.bold,
          fontSize: fontSize.sp,
        ),
      );
    }
    else if(isBlocked != null){

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isBlocked! ? kdanger : ksuccess,
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomText(
          text: isBlocked! ? "Bloqué" : "Actif",
          fontWeight: FontWeight.bold,
          fontSize: fontSize.sp,
        ),
      );
    }
    else if(role != null){
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: getColorbyRole(role!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: CustomText(
          text: FormatProjectText().getTextMember(role!),
          fontWeight: FontWeight.bold,
          fontSize: fontSize.sp,
        ),
      );
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: getColorStatus(status!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: CustomText(
        text: FormatProjectText().getTextStatus(status!),
        fontWeight: FontWeight.bold,
        fontSize: fontSize.sp,
      ),
    );
  }
}

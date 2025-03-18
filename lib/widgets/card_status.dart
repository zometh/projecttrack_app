import 'package:diop_mouhamed_l3gl_examen/config/colors.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/project_priority.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/project_status.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/format_project_text.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/specific_color.dart';
import 'package:flutter/material.dart';
import 'custom_text.dart';

Widget cardStatus(ProjectStatus status, bool isDarkMode) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
      borderRadius: BorderRadius.circular(12),
    ),
    child: CustomText(text: "6D", fontWeight: FontWeight.bold, fontSize: 14),
  );
}

Widget cardPriority(ProjectPriority priority, bool isDarkMode) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
      borderRadius: BorderRadius.circular(12),
    ),
    child: CustomText(text: "6D", fontWeight: FontWeight.bold, fontSize: 14),
  );
}

class CardStatus extends StatelessWidget {
  final ProjectStatus? status;
  final ProjectPriority? priority;

  const CardStatus({
    super.key,
    this.priority,
    this.status,
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
          fontSize: 14,
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
        fontSize: 14,
      ),
    );
  }
}

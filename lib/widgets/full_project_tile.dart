import 'package:diop_mouhamed_l3gl_examen/enum/enum_textstyle.dart';
import 'package:diop_mouhamed_l3gl_examen/models/project.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/fomat_text.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/format_date.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/format_project_text.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/specific_color.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/card_status.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/project_status_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FullProjectTile extends StatelessWidget {
  final Project project;
  const FullProjectTile({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomText(
                      text: FormatText.formatTitle(project.title),
                      overflow: TextOverflow.visible,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  CardStatus(status: project.status),
                ],
              ),
              SizedBox(height: 5.h),
              Row(
                children: [
                  Icon(Icons.error_outline),
                  SizedBox(width: 5.w),
                  CustomText(
                    text:
                        "Priorité : ${FormatProjectText().getTextPriority(project.priority)}",
                    color: getColorPriority(project.priority),
                  ),
                ],
              ),
              SizedBox(height: 7.h),
              CustomText(
                text: "Description",
                overflow: TextOverflow.visible,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              CustomText(
                text: FormatText.formatTitle(project.description),
                customStyle: CustomTextStyle.secondary,
                fontSize: 13,
              ),
              SizedBox(height: 7.h),
              CustomText(
                text: "Dates",
                overflow: TextOverflow.visible,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_month),
                      SizedBox(width: 3.w),
                      CustomText(text: "Début"),
                      SizedBox(width: 3.w),
                      CustomText(
                        text: FormatDate().formatToSimple(project.startDate),
                        fontSize: 13,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.calendar_month),
                      SizedBox(width: 3.w),
                      CustomText(text: "Fin :"),
                      SizedBox(width: 3.w),
                      CustomText(
                        fontSize: 13,
                        text: FormatDate().formatToSimple(project.endDate),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

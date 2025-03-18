import 'package:diop_mouhamed_l3gl_examen/config/colors.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/enum_textstyle.dart';
import 'package:diop_mouhamed_l3gl_examen/models/project.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/full_project_view.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/format_date.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/card_status.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

class ProjectTile extends StatefulWidget {
  final Project project;
  const ProjectTile({super.key, required this.project});

  @override
  State<ProjectTile> createState() => _ProjectTileState();
}

class _ProjectTileState extends State<ProjectTile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting('fr_FR', null);
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () => Get.to(() => FullProjectView(project: widget.project)),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: isDarkMode ? kcardDark : kcardLight,
        child: Container(
          padding: EdgeInsets.all(16),
          height: 165.h,
          width: 320.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                spacing: 10.w,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Hero(
                      tag: widget.project.id,
                      child: CustomText(
                        text: widget.project.title,
                        fontSize: 18,
                        customStyle: CustomTextStyle.primary,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  CardStatus(
            
                    priority: widget.project.priority,
                  ),
                ],
              ),
              SizedBox(height: 8),
              CustomText(
                text: "Membres de l'équipe",
                customStyle: CustomTextStyle.secondary,
                fontSize: 14,
              ),
              SizedBox(height: 10),
              Row(
                children: List.generate(
                  4,
                  (index) => Transform.translate(
                    offset: Offset(-12.0 * index, 0),
                    child: UserAvatar(
                      imageUrl:
                          "https://media.gettyimages.com/id/1446629309/photo/argentina-v-australia-round-of-16-fifa-world-cup-qatar-2022.jpg?b=1&s=594x594&w=0&k=20&c=62wT0Z00Y-1qws1eYBSxj_CVcaPHMJJQIVuPkFajQUY=",
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),

              Expanded(
                child: CustomText(
                  text:
                      "Date d'échéance: ${FormatDate().formatToDate(widget.project.createdAt)}",
                  customStyle: CustomTextStyle.secondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

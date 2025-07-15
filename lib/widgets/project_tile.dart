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
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../services/firestore_db.dart';
import 'loading.dart';

class ProjectTile extends StatefulWidget {
  final Project project;
  const ProjectTile({super.key, required this.project});

  @override
  State<ProjectTile> createState() => _ProjectTileState();
}

class _ProjectTileState extends State<ProjectTile> {
  Project get project => widget.project;


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
      child: Center(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 4.w),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: isDarkMode ? kcardDark : kcardLight,
            child: Padding(
              padding:  EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 7.h,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          text: widget.project.title,
                          fontSize: 18,
                          customStyle: CustomTextStyle.primary,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      CardStatus(
                        priority: widget.project.priority,
                      ),
                    ],
                  ),

                  CustomText(
                    text: "Membres de l'équipe",
                    customStyle: CustomTextStyle.secondary,
                    fontSize: 14,
                  ),

                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       FutureBuilder(future: FirestoreDb().getProjectMembersImage(project.id),
                           builder: (_, snapshots){
                         if(snapshots.connectionState == ConnectionState.waiting){
                           return loadingComponent;
                         }
                         if(snapshots.hasError){
                           return CustomText(text: snapshots.error.toString());
                         }
                         final images = snapshots.data!;
                         return SizedBox(
                           height: 40.h,
                           child: Row(
                             children: List.generate(
                               images.length,
                                   (index) => Transform.translate(
                                 offset: Offset(-12.0 * index, 0),
                                 child: UserAvatar(
                                   imageUrl:
                                   images[index],
                                 ),
                               ),
                             ),
                           ),
                         );
                           }
                       ),
                       CircularStepProgressIndicator(
                         totalSteps: 100,
                         currentStep: project.progress,
                         stepSize: 5,
                         selectedColor: project.progress < 50 ? Colors.red : Colors.green,
                         //unselectedColor: Colors.grey[200],
                         padding: 0,
                         width: 50,
                         height: 50,
                         selectedStepSize: 5,
                         roundedCap: (_, __) => true,

                         child: Center(child: CustomText(text: "${project.progress}%", fontSize: 9.sp,fontWeight: FontWeight.bold,),),
                       ),
                     ],
                   ),

                  CustomText(
                    text:
                        "Date d'échéance: ${FormatDate().formatToDate(widget.project.createdAt)}",
                    customStyle: CustomTextStyle.secondary,
                    fontSize: 14,
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

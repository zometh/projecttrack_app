import 'package:diop_mouhamed_l3gl_examen/config/colors.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/project_status.dart';
import 'package:diop_mouhamed_l3gl_examen/services/firestore_db.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/card_status.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/my_toast_notif.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../controllers/project_action_controller.dart';
import '../enum/enum_textstyle.dart';
import '../models/project.dart';

class StatsTile extends StatelessWidget {
  const StatsTile({super.key});

  @override
  Widget build(BuildContext context) {
    Project project = ProjectActionController.to.currentProject;
    return Center(
      child: Card(
        elevation: 4,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 10.h,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(text: "Avancement du projet".toUpperCase(), fontSize: 18, fontWeight: FontWeight.bold,),
                CircularStepProgressIndicator(
                  totalSteps: 100,
                  currentStep: project.progress,
                  stepSize: 10,
                  selectedColor: kprimary,
                  unselectedColor: Colors.grey[200],
                  padding: 0,
                  width: 150,
                  height: 150,
                  selectedStepSize: 15,
                  roundedCap: (_, __) => true,

                  child: Center(child: CustomText(text: "${project.progress}%", fontSize: 25,fontWeight: FontWeight.bold,),),
                ),
                const SizedBox(
                  height: 8,
                ),
                Wrap(
                  spacing: 8,
                  children: [
                    statusButton(ProjectStatus.pending),
                    statusButton(ProjectStatus.inProgress),
                    statusButton(ProjectStatus.completed),
                    statusButton(ProjectStatus.cancelled),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  statusButton(ProjectStatus status){
    return InkWell(
      onTap: ()async{
        await FirestoreDb().updateProjectStatus(status)
        .then((value){
          Get.back();
          showSuccess(message: "Le statut du projet a été mis à jour");
        });

    },
      child: CardStatus(status: status,));
  }
}



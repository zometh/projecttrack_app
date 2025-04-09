import 'package:diop_mouhamed_l3gl_examen/models/project.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/project_action.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/project_files.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/project_members.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/project_overview.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/project_tasks.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/fomat_text.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_dialog.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/my_toast_notif.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/project_action_controller.dart';
import '../services/auth_service.dart';
import '../services/firestore_db.dart';

class FullProjectView extends StatefulWidget {
  final Project? project;
  final String? projectId;
  const FullProjectView({super.key,  this.project, this.projectId});

  @override
  State<FullProjectView> createState() => _FullProjectViewState();
}

class _FullProjectViewState extends State<FullProjectView>
    with TickerProviderStateMixin {
  late Project project;
  late TabController controller;
  ProjectActionController actionController = Get.put(ProjectActionController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

      if(widget.projectId != null){
        getProject();
      }
      else{
        project = widget.project!;
      }


    actionController.updateCurrentProject(project);
    actionController.updateProjectMembers();

    controller = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      ProjectOverview(),
      const ProjectTasks(),
       ProjectMembers(),
       ProjectFiles(),
    ];
    return DefaultTabController(
      length: controller.length,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            if(actionController.isCreator.value) Row(
              children: [
               PopupMenuButton<int>(

                 itemBuilder: (_) {
                   return [
                     PopupMenuItem(
                       value: 1,
                       
                       child: TextButton.icon(onPressed: (){
                         Get.back();
                         Get.to(() => ProjectActionPage(isEdit: true,));
                       }, icon: Icon(Icons.edit), label: CustomText(text: "Modifier"),),

                     ),
                     PopupMenuItem(
                       value: 1,
                       child: TextButton.icon(onPressed: (){
                         Get.back();
                         CustomDialog(context: context)
                             .alertDialogConfirm(
                                 (){
                               Get.back();
                               FirestoreDb().removeProject().then((_){
                                 showSuccess(message: "Projet supprimé avec succès !");
                               });
                             },
                             "Supprimer le projet",
                             "Êtes-vous sûr de vouloir supprimer ce projet ?");
                       },
                           label: CustomText(text: "Supprimer"),
                           icon:  Icon(Icons.delete, color: Colors.red,))

                     ),
                   ];
                 },

               ),

              ],
            )],
          title: GetBuilder<ProjectActionController>(
          builder: (controller) => CustomText(
    text: FormatText.formatTitle(controller.currentProject.title),
    overflow: TextOverflow.ellipsis,
    fontWeight: FontWeight.bold,
    fontSize: 17,
    color: Colors.white,
    ))
          ,
          bottom: TabBar(

            controller: controller,
            dividerColor: Colors.transparent,
            indicatorAnimation: TabIndicatorAnimation.elastic,
            indicatorWeight: 5,
            tabAlignment: TabAlignment.center,
            unselectedLabelColor: Colors.grey.shade400,
            labelStyle: GoogleFonts.gabarito(
              fontSize: 14.sp,
              color: Colors.white,
            ),
            tabs: [
              Tab(text: "Aperçu"),
              Tab(text: "Tâche"),
              Tab(text: "Membres"),
              Tab(text: "Fichiers"),
            ],
          ),
        ),
        body:  Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: TabBarView(controller: controller, children: pages),
    ),
      ),
    );
  }

  getProject()async{

    project = await FirestoreDb().getOneProject(widget.projectId!);
  }
}

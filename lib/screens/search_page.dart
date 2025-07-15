import 'package:diop_mouhamed_l3gl_examen/controllers/search_controller.dart';
import 'package:diop_mouhamed_l3gl_examen/services/firestore_db.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/mapping/m_project.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_search_bar.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/loading.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/project_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../models/project.dart';
import '../widgets/not_found_view.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.h),
        child: CustomSearchBar(),

    ),
      body: GetBuilder<SearchProjectController>(
          init: SearchProjectController(),
          builder: (controller){
            bool isEmpty =  controller.search.isEmpty;
            return  StreamBuilder(
                stream:FirestoreDb().getAllUsersProjects(),
                builder: (_, snapshots){
                  if(snapshots.connectionState == ConnectionState.waiting){
                    return loadingComponent;
                  }
                  if(!snapshots.hasData || snapshots.data!.isEmpty){

                  return NotFoundWidget();
                  }
                  final List<Project> allProjects = snapshots.data!;
                  List<Project> projects = [];
                  int status = controller.getStatus();
                  if(status != -1){
                    projects = allProjects.where((project) => project.status == Mproject.getStatusByIndex(status)).toList();
                  }
                  else if(!isEmpty){

                    String search = controller.search;
                    if(status == -1){
                      projects = allProjects.where((project) => project.title.toLowerCase().contains(search.toLowerCase())).toList();

                    }else{
                      projects = allProjects.where((project) => project.title.toLowerCase().contains(search.toLowerCase()) && project.status == Mproject.getStatusByIndex(status)).toList();
                    }
                  }else{
                    projects = allProjects;
                  }
                  return projects.isEmpty ? NotFoundWidget() : Column(
                    children: [
                      SizedBox(height: 10.h,),
                      CustomText(text: isEmpty ? "Tous vos projets" : "Résultats de la recherche", fontWeight: FontWeight.w600, fontSize: 16.sp,),
                      Expanded(child: ProjectListView(projects: projects)),
                    ],
                  );
                }

            );
          }
      ),
    );
  }
}

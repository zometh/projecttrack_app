import 'package:diop_mouhamed_l3gl_examen/screens/task_add.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_floating_button.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/loading.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/project_action_controller.dart';
import '../models/task.dart';
import '../services/firestore_db.dart';
class ProjectTasks extends StatelessWidget {
  const ProjectTasks({super.key});

  @override
  Widget build(BuildContext context) {
    ProjectActionController controller = Get.put(ProjectActionController());
    return Scaffold(
      body: StreamBuilder(
          stream: FirestoreDb().getProjectTasks(),
          builder: (_, snapshots){
            if(snapshots.connectionState == ConnectionState.waiting){
              return loadingComponent;
            }
            if(!snapshots.hasData || snapshots.data!.docs.isEmpty){
              return Center(child: CustomText(text: "Aucune tâche pour ce projet !"));

            }
            final datas = snapshots.data!.docs;
            List<Task> tasks = datas.map((e) => Task.fromFirestore(e.data())).toList();
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (_, index) => TaskTile(task: tasks[index]),
            );
          }
      ),



    floatingActionButton: controller.isCreatorOrAdmin() ? 
    MyFloatingActionButton(onTap: () => Get.to(() => TaskAdd())) 
        : null,
    );
  }
}
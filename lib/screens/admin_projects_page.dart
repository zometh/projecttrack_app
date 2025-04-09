import 'package:diop_mouhamed_l3gl_examen/services/firestore_db.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/loading.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/not_found_view.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/project_list_view.dart';
import 'package:flutter/material.dart';

class AdminProjectsPage extends StatelessWidget {
  const AdminProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TOUS LES PROJETS"),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: FirestoreDb().getAllProjects(),
          builder: (_, snapshots){
            if(snapshots.connectionState == ConnectionState.waiting){
              return loadingComponent;
            }
            if(snapshots.data!.isEmpty){
              return NotFoundWidget();
            }
            final projects = snapshots.data!;
            return ProjectListView(projects: projects);
          }
      ),
    );
  }
}

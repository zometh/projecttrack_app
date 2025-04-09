import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/project_status.dart';
import 'package:diop_mouhamed_l3gl_examen/models/project.dart';
import 'package:diop_mouhamed_l3gl_examen/services/auth_service.dart';
import 'package:diop_mouhamed_l3gl_examen/services/firestore_db.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/loading.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/not_found_view.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/project_list_view.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/project_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProjectViewByStatus extends StatelessWidget {

  final ProjectStatus status;
  const ProjectViewByStatus({super.key, required this.status});

  @override
  Widget build(BuildContext context) {

      return StreamBuilder(
        stream: FirestoreDb().getUserProjects(status),
        builder: (_, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return loadingComponent;
          }
          if (snapshots.data!.docs.isEmpty || snapshots.data == null) {
            return NotFoundWidget();


          }

          final datas = snapshots.data!.docs;

          List<Project> projects =
          datas.map((doc) {
            final data = doc.data();
            return Project.fromFirestore(data);
          }).toList();

          return ProjectListView(projects: projects);
        },
      );




  }
}

import 'package:diop_mouhamed_l3gl_examen/enum/project_status.dart';
import 'package:diop_mouhamed_l3gl_examen/models/project.dart';
import 'package:diop_mouhamed_l3gl_examen/services/firestore_db.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/loading.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/no_project_view.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/project_tile.dart';
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
        if (snapshots.data!.docs.isEmpty) {
          return NoProjectView();
        }
        if (snapshots.data == null) {
          return NoProjectView();
        }
        final datas = snapshots.data!.docs;

        List<Project> projects =
            datas.map((doc) {
              final data = doc.data();
              return Project.fromFirestore(data);
            }).toList();

        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          // scrollDirection: Axis.horizontal,
          itemCount: projects.length,

          itemBuilder: (_, index) {
            Project project = projects[index];
            return ProjectTile(project: project);
          },
          separatorBuilder: (_, index) => SizedBox(height: 8.h),
        );
      },
    );
  }
}

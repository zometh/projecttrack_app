import 'package:diop_mouhamed_l3gl_examen/widgets/project_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/project.dart';

class ProjectListView extends StatelessWidget {
  final List<Project> projects;
  const ProjectListView({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(top: 8.0),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        // scrollDirection: Axis.horizontal,
        itemCount: projects.length,

        itemBuilder: (_, index) {
          Project project = projects[index];
          return ProjectTile(project: project);
        },
        separatorBuilder: (_, index) => SizedBox(height: 3.h),
      ),
    );
  }
}

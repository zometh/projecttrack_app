import 'package:diop_mouhamed_l3gl_examen/models/project.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/full_project_tile.dart';
import 'package:flutter/material.dart';

class ProjectOverview extends StatelessWidget {
  final Project project;
  const ProjectOverview({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return FullProjectTile(project: project);
  }
}

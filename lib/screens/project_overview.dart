import 'package:diop_mouhamed_l3gl_examen/models/project.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/full_project_tile.dart';
import 'package:flutter/material.dart';

import '../widgets/stats_tile.dart';

class ProjectOverview extends StatelessWidget {

  const ProjectOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FullProjectTile(),
        StatsTile(),
      ],

    );
  }
}

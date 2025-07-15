import 'package:diop_mouhamed_l3gl_examen/widgets/full_project_tile.dart';
import 'package:flutter/material.dart';

import '../widgets/stats_tile.dart';

class ProjectOverview extends StatelessWidget {
  const ProjectOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            FullProjectTile(),
            SizedBox(height: 10),
            StatsTile(),
          ],
        ),
      ),
    );
  }
}

import 'package:diop_mouhamed_l3gl_examen/models/project.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/project_files.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/project_members.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/project_overview.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/project_tasks.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/fomat_text.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FullProjectView extends StatefulWidget {
  final Project project;
  const FullProjectView({super.key, required this.project});

  @override
  State<FullProjectView> createState() => _FullProjectViewState();
}

class _FullProjectViewState extends State<FullProjectView>
    with TickerProviderStateMixin {
  late Project project;
  late TabController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    project = widget.project;
    controller = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      ProjectOverview(project: project),
      const ProjectTasks(),
      const ProjectMembers(),
      const ProjectFiles(),
    ];
    return DefaultTabController(
      length: controller.length,
      child: Scaffold(
        appBar: AppBar(
          actions: [Icon(Icons.more_vert)],
          title: Hero(
            tag: project.id,
            child: CustomText(
              text: FormatText.formatTitle(project.title),
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.white,
            ),
          ),
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
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: TabBarView(controller: controller, children: pages),
        ),
      ),
    );
  }
}

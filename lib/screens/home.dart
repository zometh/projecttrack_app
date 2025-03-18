import 'package:diop_mouhamed_l3gl_examen/enum/project_status.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/project_add_page.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_floating_button.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_textfield.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/drawer.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/project_status_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late TabController _tabController;
  List<Widget> projectsTypeView = [
    ProjectViewByStatus(status: ProjectStatus.pending),
    ProjectViewByStatus(status: ProjectStatus.inProgress),
    ProjectViewByStatus(status: ProjectStatus.completed),
    ProjectViewByStatus(status: ProjectStatus.cancelled),
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(size.width);
    print(size.height);
    return DefaultTabController(
      length: _tabController.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            controller: _tabController,
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
              Tab(text: "En attente"),
              Tab(text: "En cours"),
              Tab(text: "Terminés"),
              Tab(text: "Annulés"),
            ],
          ),
          title: CustomTextField(
            prefixIcon: Icons.search,
            borderRadius: 10,
            controller: TextEditingController(),
            hintText: "Rechercher un projet",
          ),
          // This ensures proper height for your custom content
          toolbarHeight: 80, // Adjust as needed
        ),
        drawer: MyDrawer(),

        // drawerDragStartBehavior: DragStartBehavior.start,
        body: TabBarView(
          controller: _tabController,
          children: projectsTypeView,
        ),
        floatingActionButton: MyFloatingActionButton(
          onTap: () => Get.to(() => ProjectAddPage()),
        ),
      ),
    );
  }
}

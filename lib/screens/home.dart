import 'package:diop_mouhamed_l3gl_examen/controllers/project_action_controller.dart';
import 'package:diop_mouhamed_l3gl_examen/controllers/user_controller.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/project_status.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/project_add_page.dart';
import 'package:diop_mouhamed_l3gl_examen/services/firestore_db.dart';
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
  UserController userController = Get.put(UserController());
  @override
  void initState() {
    super.initState();

    userController.updateConnectedUserMail();
    _tabController = TabController(length: 4, vsync: this);
    FirestoreDb().fetchNotifications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return DefaultTabController(
      length: _tabController.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("PROJECT TRACK",
          style: GoogleFonts.alata(fontSize: 25.sp, fontWeight: FontWeight.bold)
          ),
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

          toolbarHeight: 40, // Adjust as needed
        ),

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

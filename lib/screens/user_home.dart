import 'package:diop_mouhamed_l3gl_examen/config/image_constant.dart';
import 'package:diop_mouhamed_l3gl_examen/controllers/user_controller.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/project_status.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/project_action.dart';
import 'package:diop_mouhamed_l3gl_examen/services/firestore_db.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_floating_button.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/project_status_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> with TickerProviderStateMixin {
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
    FirestoreDb().fetchNotifications();
    FirestoreDb().checkProjectDate();
    FirestoreDb().listenStatusChanges();


    userController.updateConnectedUserMail();
    _tabController = TabController(length: 4, vsync: this);


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
          title: Image.asset(kTextLogo, width: 180.w) /*Text("PROJECT TRACK",
          style: GoogleFonts.alata(fontSize: 25.sp, fontWeight: FontWeight.bold)
          )*/,
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
          onTap: () => Get.to(() => ProjectActionPage()),
        ),
      ),
    );
  }
}

import 'package:diop_mouhamed_l3gl_examen/models/project.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/add_member.dart';
import 'package:diop_mouhamed_l3gl_examen/services/firestore_db.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_floating_button.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/loading.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/member_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/project_action_controller.dart';

class ProjectMembers extends StatelessWidget {

  const ProjectMembers({super.key});

  @override
  Widget build(BuildContext context) {
    ProjectActionController controller = Get.put(ProjectActionController());
    return Scaffold(
      body: StreamBuilder(
        stream: FirestoreDb().getProjectMembers(),
        builder: (_, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {

            return loadingComponent;
          }

          if (!snapshots.hasData ||
              snapshots.data == null ||
              snapshots.data!.isEmpty) {
            debugPrint(snapshots.error.toString());
            return Center(
              child: CustomText(
                text:
                    "Une erreur est survenue lors de la récupération des données",
              ),
            );
          }


          List<Member>? members = snapshots.data;
          return ListView.builder(
            itemCount: members!.length,
            itemBuilder: (_, index) {
              Member member = members[index];
              return MemberTile(member: member);
            },
          );
        },
      ),
      floatingActionButton: controller.isCreator.value ? MyFloatingActionButton(
        onTap: () => Get.to(() => MemberForm()),
      ) : null,
    );
  }

}

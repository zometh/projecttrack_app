import 'package:diop_mouhamed_l3gl_examen/models/project_notif.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/full_project_view.dart';
import 'package:diop_mouhamed_l3gl_examen/services/firestore_db.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/fomat_text.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/format_date.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
class NotificationTile extends StatelessWidget {
  final ProjectNotif projectNotif;
  const NotificationTile({super.key, required this.projectNotif});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirestoreDb().getOneProject(projectNotif.projectId),
        builder: (_, snapshots){
          if(snapshots.connectionState == ConnectionState.waiting){
            return loadingComponent;
          }
          if(!snapshots.hasData || snapshots.data == null){
            return Center(
              child: CustomText(text: "Aucune information disponible"),
            );
          }
          final project = snapshots.data;
          return InkWell(
            onTap: () => Get.to(() => FullProjectView(project: project!)),
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.notifications, color: Colors.white),
                  ),
                  title: CustomText(
                      text: FormatText.formatTitle("Nom : ${project!.title}"),
                  fontWeight: FontWeight.bold,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: FormatText.formatTitle("Description : ${project.description}"), fontSize: 12.sp,),
                      CustomText(text: FormatText.formatTitle(FormatDate().formatMessageDate(projectNotif.date.toDate())),fontSize: 12.sp,)
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}

import 'package:diop_mouhamed_l3gl_examen/models/project_notif.dart';
import 'package:diop_mouhamed_l3gl_examen/services/firestore_db.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/loading.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/notification_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mes notifications"),),
      body: StreamBuilder(
          stream: FirestoreDb().getNotifications(),
          builder: (_, snapshots){
            if(snapshots.connectionState == ConnectionState.waiting){
              return loadingComponent;
            }
            if(!snapshots.hasData || snapshots.data!.docs.isEmpty){
              return Center(
                child: Text("Aucune notification"),

              );
            }
            final datas = snapshots.data!.docs;
            List<ProjectNotif> notifications = datas.map((data) => ProjectNotif.fromJson(data.data())).toList();
            return ListView.separated(
                itemBuilder: (_, index) => NotificationTile(projectNotif: notifications[index]),
                separatorBuilder: (_, index) => SizedBox(height: 5.h,),
                itemCount: notifications.length);
          }
      ),
    );
  }
}

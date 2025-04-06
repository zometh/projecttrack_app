import 'package:diop_mouhamed_l3gl_examen/models/chat.dart';
import 'package:diop_mouhamed_l3gl_examen/services/firestore_db.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'bubble_chat.dart';

class TaskChats extends StatelessWidget {
  final String taskId;
  const TaskChats({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirestoreDb().getChats(taskId),
        builder: (_, snapshots){
          if(snapshots.connectionState == ConnectionState.waiting){
            return loadingComponent;
          }
          if(!snapshots.hasData || snapshots.data!.docs.isEmpty){
            return  Center(child: CustomText(text: "Aucun message"));

          }
          final datas = snapshots.data!.docs;
          List<Chat> chats = datas.map((e) => Chat.fromFirestore(e.data())).toList();
          return ListView.separated(
            itemCount: chats.length,
              separatorBuilder: (_, index) => SizedBox(height: 5.h,),
              itemBuilder: (_, index) => BubbleChat(chat: chats[index],)

          );
        }

    );
  }
}

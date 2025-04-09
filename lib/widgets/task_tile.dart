import 'package:diop_mouhamed_l3gl_examen/config/colors.dart';
import 'package:diop_mouhamed_l3gl_examen/controllers/project_action_controller.dart';
import 'package:diop_mouhamed_l3gl_examen/controllers/user_controller.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/enum_textstyle.dart';
import 'package:diop_mouhamed_l3gl_examen/models/my_user.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/fomat_text.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/format_date.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/card_status.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_textfield.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/task_bottom_sheet.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/task_chats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../models/task.dart';
import '../services/firestore_db.dart';
import 'loading.dart';

class TaskTile extends StatefulWidget {

  final Task task;
  const TaskTile({super.key, required this.task});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  late TextEditingController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TextEditingController();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    ProjectActionController actionController = Get.put(ProjectActionController());
    String taskAssignedTo = widget.task.assignedTo;
    String creator = ProjectActionController.to.currentProject.creator;
    String connectedUserMail = UserController.to.getEmail;
    return FutureBuilder(
      future: FirestoreDb().getUserByMail(widget.task.assignedTo),
      builder: (_, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return loadingComponent;
        }
        if(snapshot.hasError){
          return Container();
        }
        MyUser? user = snapshot.data;
        Card card = Card(
          elevation: 5,
          child: ExpansionTile(
            shape: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
            iconColor: kprimary,
            title: CustomText(
              text: FormatText.formatTitle(widget.task.title),
              overflow: TextOverflow.ellipsis,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
            subtitle: Row(
              spacing: 6.w,
              children: [
                CardStatus(priority: widget.task.priority,fontSize: 11,),
                CardStatus(status: widget.task.status,fontSize: 11,),

                Row(
                  spacing: 2.w,
                  children: [
                    Icon(Icons.calendar_month,color: Colors.grey, size: 15,),
                    CustomText(text: FormatDate().formatToSimple(widget.task.endDate),fontSize: 14,
                      color: Colors.grey,
                    ),
                  ],
                )
              ],
            ),


            children: [
              Align(
                  alignment: AlignmentDirectional.topStart,
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                    child: Column(
                      spacing: 3.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  <Widget>[
                        CustomText(text: "Description", fontSize: 14,fontWeight: FontWeight.w600,),
                        CustomText(text: widget.task.description, fontSize: 12,customStyle: CustomTextStyle.secondary,),
                        CustomText(text: "Progression : ${widget.task.progress}%", fontSize: 14,fontWeight: FontWeight.w600,),
                        LinearProgressIndicator(
                          value: widget.task.progress/100,

                          valueColor: AlwaysStoppedAnimation(kprimary),
                          color:
                          kprimary,
                          backgroundColor: Colors.grey.shade300,),

                        CustomText(text: "Assigné à : ${user!.fullName.toUpperCase()}", fontSize: 15,fontWeight: FontWeight.w600,),
                        SizedBox(height: 10.h,),
                        CustomText(text: "Discussions:", fontSize: 15,fontWeight: FontWeight.w600,),
                        SizedBox(
                          height: 250.h,
                          child: TaskChats(taskId: widget.task.id),
                        ),

                        if(actionController.isUser) Row(
                          children: [
                            Expanded(
                              child: CustomTextField(controller: controller,
                                  hintText: "Ajouter un commentaire")
                              ,
                            ),
                            IconButton(onPressed: ()async{
                              String message = controller.text;
                              if(message.isNotEmpty){
                                await FirestoreDb().sendMessage( message, widget.task.id);
                                controller.clear();
                              }
                            }, icon: Icon(Icons.send,color: kprimary,))
                          ],
                        ),

                      ],
                    ),
                  )
              )
            ],
          ),
        );
        if(connectedUserMail == creator || connectedUserMail == taskAssignedTo){
          return Slidable(
            key: ValueKey(widget.task.id),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),

              extentRatio: 0.45,
              children: [
                CustomSlidableAction(
                  onPressed: (_) async{
                    showBottomSheet(context: context, builder: (context) => TaskBottomSheet(task: widget.task,));


                  },
                  backgroundColor: kprimary,
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.edit),
                ),
                if(creator == connectedUserMail)CustomSlidableAction(
                  onPressed: (_) async{
                    await FirestoreDb().removeTask(widget.task.id);
                    await FirestoreDb().updateProjectProgression();

                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.delete),
                ),
              ],
            ),
            child: card,
          );
        }
        return card;
      }
    );
  }
}

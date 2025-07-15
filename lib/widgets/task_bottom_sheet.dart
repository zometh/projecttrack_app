import 'package:diop_mouhamed_l3gl_examen/models/task.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_button.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../enum/project_status.dart';
import '../services/firestore_db.dart';
import 'card_status.dart';
import 'my_toast_notif.dart';

class TaskBottomSheet extends StatefulWidget {
  final Task task;
  const TaskBottomSheet({super.key, required this.task});

  @override
  State<TaskBottomSheet> createState() => _TaskBottomSheetState();
}

class _TaskBottomSheetState extends State<TaskBottomSheet> {
  double currentProgress = 0;
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentProgress = widget.task.progress.toDouble();
  }
  @override
  Widget build(BuildContext context) {



    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Padding(padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
      child: Column(
        children: [
          Wrap(
            spacing: 8,
            children: buildChildren(),
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              CustomText(text: "Progression : "),
              Slider(
                  activeColor: Colors.green,
                  inactiveColor: Colors.grey,
                  value: currentProgress,
                  min: 0, max: 100,
                  onChanged: (value){
                    setState(() {
                      currentProgress = value;
                    });
                  }),
              Expanded(child: CustomText(text: "${currentProgress.toInt()}%")),


            ],
          ),
          _isLoading? loadingComponent :  CustomButton(text: "Mettre à jour", onPressed: ()async{
            try {
              setState(() {
                _isLoading = true;
              });

              await FirestoreDb().updateTaskProgress(taskId: widget.task.id, progress: currentProgress.toInt())
                  .then((onValue){

                Get.back();
                showSuccess(message: "Status mis à jour avec succès");
              });
            } on Exception catch (e) {
              setState(() {
                _isLoading = false;
              });
              showError(message: "Une erreur est survenue. Veuillez réssayer plus tard !");
            }
          })
        ],
      ),
      )
    );
  }

  buildChildren(){
    List<ProjectStatus> statuses = [
      ProjectStatus.pending,
      ProjectStatus.inProgress,
      ProjectStatus.completed,
      ProjectStatus.cancelled,
    ];
    List<Widget> children = [];
    for(ProjectStatus status in statuses){
      if(status != widget.task.status){
        children.add(
          InkWell(
            onTap: ()async{
              try{
                setState(() {
                  _isLoading = true;
                });
                await FirestoreDb().updateTaskProgress(taskId: widget.task.id, progress: currentProgress.toInt(), status: status)
                    .then((onValue){
                  Get.back();
                  showSuccess(message: "Status mis à jour avec succès");
                });
              }catch(e){
                setState(() {
                  _isLoading = false;
                });
                showError(message: "Une erreur est survenue. Veuillez réssayer plus tard !");
              }
            },
            child: CardStatus(status: status,),
          ),
        );
      }

    }
    return children;
  }
}

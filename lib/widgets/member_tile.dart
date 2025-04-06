import 'package:diop_mouhamed_l3gl_examen/config/colors.dart';
import 'package:diop_mouhamed_l3gl_examen/controllers/project_action_controller.dart';
import 'package:diop_mouhamed_l3gl_examen/controllers/user_controller.dart';
import 'package:diop_mouhamed_l3gl_examen/models/my_user.dart';
import 'package:diop_mouhamed_l3gl_examen/models/project.dart';
import 'package:diop_mouhamed_l3gl_examen/services/firestore_db.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/card_status.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_dialog.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/loading.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/my_toast_notif.dart';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
class MemberTile extends StatelessWidget {
  final Member member;
  final bool canShowButton;
  const MemberTile({super.key, required this.member,  this.canShowButton = true});

  @override
  Widget build(BuildContext context) {
    ProjectActionController controller = Get.put(ProjectActionController());

    Project project = controller.currentProject;
    String creatorMail = project.creator;
    String connectedUserMail = UserController.to.getEmail;

    final bool canRemoveMember = controller.isCreator.value && creatorMail == member.email;

    return FutureBuilder(
        future: FirestoreDb().getUserByMail(member.email),
        builder: (_, snapshots){
          if(snapshots.connectionState == ConnectionState.waiting){
            return loadingComponent;
          }
          if(!snapshots.hasData || snapshots.data == null){
            return Center(child: CustomText(text: "Auncune information trouvée !"),);
          }
          MyUser? user = snapshots.data;
          String userName = canRemoveMember ? "${user!.fullName.toUpperCase()} (Vous)" : user!.fullName.toUpperCase();
          Card card = Card(
            elevation: 5,
            child: ListTile(
              leading: CircleAvatar(backgroundColor: kprimary, backgroundImage: NetworkImage(user.imageUrl),),
              title: CustomText(text: userName, fontSize: 12, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w600,),
              subtitle: CustomText(text: member.email, fontSize: 12.5,),
              trailing: CardStatus(role: member.role,),
            ),
          );
          if(!canShowButton){
            return card;
          }
          return connectedUserMail == creatorMail && member.email != creatorMail ?

           Slidable(
            key: ValueKey(member.email),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),

              extentRatio: 0.25,
              children: [

                CustomSlidableAction(
                  onPressed: (_) async{
                    CustomDialog(context: context).alertDialogConfirm((){
                      FirestoreDb().removeMemberFromProject( member.email, member.role).then((onValue) {
                        controller.refreshCurrentProject();
                        showSuccess(message: "Membre supprimé avec succès");
                      });
                    }, "Suppression d'un membre", "Êtes-vous sûr de vouloir supprimer ce membre ?");

                  },
                  backgroundColor: kdanger,
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.delete),
                ),
              ],
            ),
            child: card,
          ) : card;
        })
    ;
  }
}

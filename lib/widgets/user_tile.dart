import 'package:diop_mouhamed_l3gl_examen/models/my_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:toastification/toastification.dart';

import '../config/colors.dart';
import '../services/firestore_db.dart';
import 'card_status.dart';
import 'custom_dialog.dart';
import 'custom_text.dart';
import 'my_toast_notif.dart';

class UserTile extends StatelessWidget {
  final MyUser user;
  const UserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Slidable(
        key: ValueKey(user.email),
    endActionPane: ActionPane(
    motion: const ScrollMotion(),

    extentRatio: 0.25,
    children: [
      CustomSlidableAction(
        onPressed: (_) async{
         CustomDialog(context: context).alertDialogConfirm((){
            FirestoreDb().updateUserAccountStatus( user.email, user.blocked ? false : true).then((onValue) {

              showSuccess(message: user.blocked ? "Compte débloqué avec succès" : "Compte bloqué avec succès");
            });
          }, user.blocked ? "Débloquer" : "Bloquer", user.blocked ? "Etes-vous sûr de vouloir débloquer ce compte ?" : "Etes-vous sûr de vouloir bloquer ce compte ?");

        },
        backgroundColor: user.blocked ? ksuccess : kdanger,
        foregroundColor: Colors.white,
        child: user.blocked ? const Icon(Icons.lock_open) : const Icon(Icons.lock),
      ),
    ],

    ), child: Card(
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(backgroundColor: kprimary, backgroundImage: NetworkImage(user.imageUrl),),
        title: CustomText(text: user.fullName.toUpperCase(), fontSize: 14.sp, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w600,),
        subtitle: CustomText(text: user.email, fontSize: 12.5,),
        trailing: CardStatus(isBlocked: user.blocked,),
      ),
    )

    );
  }
}

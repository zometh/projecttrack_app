import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:diop_mouhamed_l3gl_examen/config/colors.dart';
import 'package:diop_mouhamed_l3gl_examen/controllers/user_controller.dart';
import 'package:diop_mouhamed_l3gl_examen/models/chat.dart';
import 'package:diop_mouhamed_l3gl_examen/models/my_user.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/format_date.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_dialog.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/my_toast_notif.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/firestore_db.dart';

class BubbleChat extends StatelessWidget {
  final Chat chat;
  const BubbleChat({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    bool isSender = UserController.to.getEmail == chat.sender;
    return FutureBuilder(
        future: FirestoreDb().getUserByMail(chat.sender),
        builder: (_, snapshots){
          if(snapshots.connectionState == ConnectionState.waiting){
            return Container();
          }
          if(!snapshots.hasData || snapshots.data == null){
            return Center(child: CustomText(text: "Aucune information trouvée !"),);
          }
          MyUser? user = snapshots.data;

          return InkWell(
            onLongPress: () async{
                if(isSender){
              await
             Get.dialog(CustomDialog(context: context)
                  .alertDialogConfirm(
              () => FirestoreDb().deleteChat(chat.id).then((onValue) => showSuccess(message: "Message supprimé !")),
              "Supprimer le message",
              "Êtes-vous sûr de vouloir supprimer ce message ?"));
}
            },
            child: isSender
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: BubbleSpecialOne(
                          isSender: isSender,
                          text: chat.message,
                          color: isSender ? kprimary : Color(0xFFE8E8EE),
                          textStyle: GoogleFonts.montserrat(
                              color: isSender ? Colors.white : Colors.black),
                        ),
                      ),
                      CircleAvatar(
                        backgroundImage: NetworkImage(user!.imageUrl),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4, right: 50),
                    child: Text(
                        FormatDate().formatMessageDate(chat.date.toDate()), style: TextStyle(fontSize: 12, color: Colors.grey)


                  )
                  )
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: user!.fullName.toUpperCase(), fontWeight: FontWeight.w500,),
                  Row(

                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(user.imageUrl),
                      ),
                      Flexible(
                        child: BubbleSpecialOne(
                          isSender: isSender,
                          text: chat.message,
                          color: isSender ? kprimary : Color(0xFFE8E8EE),
                          textStyle: GoogleFonts.montserrat(
                              color: isSender ? Colors.white : Colors.black),
                        ),
                      ),
                    ],
                  ),
                  Text(FormatDate().formatMessageDate(chat.date.toDate()), style: TextStyle(fontSize: 12, color: Colors.grey),)

                ],
              ),
          );
        }
    );
  }
}

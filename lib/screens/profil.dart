import 'package:diop_mouhamed_l3gl_examen/config/colors.dart';
import 'package:diop_mouhamed_l3gl_examen/controllers/user_controller.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/user_info_edit.dart';
import 'package:diop_mouhamed_l3gl_examen/services/auth_service.dart';
import 'package:diop_mouhamed_l3gl_examen/services/firestore_db.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_button.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_dialog.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/loading.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/user_page_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

import '../models/my_user.dart';
class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> with AutomaticKeepAliveClientMixin<Profil>{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    UserController userController = Get.put(UserController());
    return Scaffold(
      body: StreamBuilder(
          stream: FirestoreDb().getCurrentUser(),
          builder: (_, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return loadingComponent;
            }
            if(!snapshot.hasData || snapshot.data == null){
              return Center(child: CustomText(text: "Aucun utilisateur trouvé"),);
            }
            final datas = snapshot.data!.docs.first;
            final user = MyUser.fromFirestore(datas.data());

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(height: 50.h,),
                  Center(
                    child: CircleAvatar(
                      radius: 71,
                      backgroundColor: kprimary,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: kprimary,
                        backgroundImage: NetworkImage(user.imageUrl),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h,),
                 UserPageTile(
                      iconData: Iconsax.user,
                      title: user.fullName.toUpperCase(),
                    showEdit: false
                  ),
                  SizedBox(height: 5.h,),
                  UserPageTile(
                      iconData: Iconsax.user_tag,
                      title: user.email.toLowerCase(),
                    showEdit: false
                  ),
                  SizedBox(height: 5.h,),
                  CustomButton(
                      color: kprimary,
                      icon: Iconsax.edit,
                      fontSize: 15,
                      text: "Modifier mes informations",
                      onPressed: (){
                        Get.to(() => UserInfoEdit(user: user));
                      }
                  ),
                  SizedBox(height: 8.h,),
                  CustomButton(
                      color: Colors.red,
                      icon: Iconsax.logout,
                      fontSize: 15,
                        text: "Se déconnecter",
                        onPressed: (){
                          userController.resetUser();
                          CustomDialog(context: context)
                              .alertDialogConfirm(
                                  () => AuthService().signOut(),
                              "Déconnexion",
                              "Voulez-vous vraiment vous déconnecter ?"
                          );

                        }

                    ),

                ],
              ),
            );
          }
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}

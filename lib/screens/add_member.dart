import 'package:diop_mouhamed_l3gl_examen/controllers/project_action_controller.dart';
import 'package:diop_mouhamed_l3gl_examen/services/firestore_db.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/form_validator.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_button.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_dropdown.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_textfield.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/loading.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/my_toast_notif.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';



class MemberForm extends StatefulWidget {


  const MemberForm({super.key});

  @override
  State<MemberForm> createState() => _MemberFormState();
}

class _MemberFormState extends State<MemberForm> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  bool _isLoading = false;
  ProjectActionController controller = Get.put(ProjectActionController());
  late String projectId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    projectId = controller.currentProject.id;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        title: Text("Ajouter un membre")
    ),

    body: Padding(padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),

    child: GetBuilder<ProjectActionController>(
      init: ProjectActionController(),
      builder: (controller) {
        return Form(
          key: key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 7.h,
            children: [
              CustomText(text: "Email", fontWeight: FontWeight.bold,fontSize: 18,),
             CustomTextField(
                 prefixIcon: Icons.mail,
                 validator: (value) => FormValidator.isValidMail(value!),
                 controller: controller.email.value,


                 hintText: "Adresse email"),
              CustomText(text: "Role", fontWeight: FontWeight.bold,fontSize: 18,),
              MemberRoleChoice(),
              _isLoading ? loadingComponent : CustomButton(text: "Ajouter", onPressed: addMember)
            ],
          ),
        );
      }
    ),

    ),
    );
  }
  addMember() async{
    ProjectActionController controller = Get.put(ProjectActionController());

    if(key.currentState!.validate()){
      if(controller.role != null){
        String email = controller.email.value.text;

        if(await FirestoreDb().userExist(email)){
          if(!await FirestoreDb().checkUserInProject()){
            try{
              setState(() {
                _isLoading = true;
              });
              await FirestoreDb().addMemberToProject().then((onValue){
                controller.refreshCurrentProject();
                showSuccess(message: "Membre ajouté !");
                controller.email.value.clear();
                Get.back();
              });
            }catch (e){
              setState(() {
                _isLoading = false;
              });
              showError(message: e.toString());
            }
          }
          else{
            showError(message: "Cet utilisateur se trouve dèja dans le projet !");
          }

        }else{
          showError(message: "Aucun compte n'est associé à l'adresse email $email");
        }
      }else{
        showError(message: "Veuillez chosir le role du membre");
      }
    }else{
      showError(message: "Veuillez renseigner l'adresse email du membre que vous voulez ajouter !");
    }
  }

}

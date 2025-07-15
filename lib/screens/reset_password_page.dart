import 'package:diop_mouhamed_l3gl_examen/services/auth_service.dart';
import 'package:diop_mouhamed_l3gl_examen/services/firestore_db.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_button.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_textfield.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/my_toast_notif.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../utils/form_validator.dart';
import '../widgets/loading.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late TextEditingController email;
  GlobalKey<FormState> key = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email = TextEditingController();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    email.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Réinitialisation du mot de passe",
        style: TextStyle(fontSize: 14.sp),
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 10.w),
        child: Form(
          key: key,
          child: Column(

            spacing: 10.h,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20.h,),
              Icon(Icons.lock_reset_rounded, size: 150,),
              CustomText(text: "Saisissez votre adresse email pour recevoir un lien de réinitialisation de votre mot de passe.",
              textAlign: TextAlign.center,
                maxLines: 4,
              ),
              CustomTextField(controller: email, hintText: "Adresse email",
              prefixIcon: Icons.email,
              validator: (value) => FormValidator.isValidMail(value!),
              ),
              _isLoading? loadingComponent : CustomButton(text: "Réinitialiser", onPressed: reset)
            ],
          ),
        ),
      ),
    );
  }
  reset() async{
    if(key.currentState!.validate()){
      Get.focusScope!.unfocus();
      String strEmail = email.text.trim();
      if(await FirestoreDb().isEmailExist(strEmail))
      {
        try{
          setState(() {
            _isLoading = true;
          });
          await AuthService().resetPassword(strEmail).then((onValue){
            showSuccess(message: "Un lien de réinitialisation de mot de passe vous a été envoyé !");
            Get.back();
          });
        }catch(e){
          setState(() {
            _isLoading = false;
          });
          debugPrint(e.toString());
          showError(message: "Une erreur est survenue !");
        }
      }else{
        setState(() {
          _isLoading = false;
        });
        showError(message: "L'adresse email n'existe pas !");
      }
    }else{
      showError(message: "Veuillez remplir correctement le formulaire !");
    }
  }

}

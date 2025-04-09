import 'dart:io';

import 'package:diop_mouhamed_l3gl_examen/config/image_constant.dart';
import 'package:diop_mouhamed_l3gl_examen/controllers/register_controller.dart';
import 'package:diop_mouhamed_l3gl_examen/controllers/user_controller.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/textfield_type.dart';
import 'package:diop_mouhamed_l3gl_examen/models/my_user.dart';
import 'package:diop_mouhamed_l3gl_examen/services/auth_service.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/form_validator.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_button.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_textfield.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/loading.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/my_toast_notif.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../config/colors.dart';
import '../enum/enum_textstyle.dart';

class Register extends StatefulWidget {
  final MyUser? user;
  const Register({super.key, this.user});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  late TextEditingController email;
  late TextEditingController fullName;
  late TextEditingController password;
  late TextEditingController passwordConfirm;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _isLoading = false;

  File? file;
  bool editPassword = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    email = TextEditingController();
    fullName = TextEditingController();
    password = TextEditingController();
    passwordConfirm = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    email.dispose();
    password.dispose();
    passwordConfirm.dispose();
    fullName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("INSCRIPTION"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: double.infinity,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Form(
              key: _key,
              child: Column(
                spacing: 12.h,
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 45.h,),
                  Center(
                    child: InkWell(
                      onTap: pickImage,
                      child: CircleAvatar(
                        radius: 65,
                        backgroundImage:
                            file != null
                                ? FileImage(file!)
                                : AssetImage(kUserDefaultImage),
                      ),
                    ),
                  ),

                  CustomTextField(
                    prefixIcon: Icons.person,
                    validator:
                        (value) => FormValidator.isValidFullName(value!.trim()),

                    controller: fullName,
                    hintText: "Nom complet",
                  ),
                 CustomTextField(
                    prefixIcon: Icons.mail,
                    validator:
                        (value) => FormValidator.isValidMail(value!.trim()),

                    controller: email,
                    hintText: "Adresse email",
                  ),

                  CustomTextField(
                    prefixIcon: Icons.lock,
                    validator:
                        (value) => FormValidator.isValidPassword(value!.trim()),
                    controller: password,
                    hintText: "Mot de passe",
                    type: TextFieldType.password,
                  ),
                 // if(editPassword)
                  CustomTextField(
                    prefixIcon: Icons.lock,
                    validator:
                        (value) => FormValidator.isValidPassword(value!.trim()),
                    controller: passwordConfirm,
                    hintText: "Confirmation du mot de passe",
                    type: TextFieldType.password,
                  ),
                  _isLoading
                      ? loadingComponent
                      : CustomButton(text:  "S'inscrire" , onPressed:  signUp ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "Vous avez déjà un compte? ",
                        fontSize: 14,
                      ),
                      InkWell(
                        onTap: () => Get.back(),
                        child: CustomText(
                          text: "Se connecter",
                          color: kprimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          customStyle: CustomTextStyle.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  pickImage() async {
    XFile? _file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (_file != null) {
      setState(() {
        file = File(_file.path);
      });
    }
  }

  void signUp() async {
    if (_key.currentState!.validate()) {
      if (password.text.trim() == passwordConfirm.text.trim()) {
        if (file != null) {
          setState(() {
            _isLoading = true;
          });
          String strEmail = email.text.trim();
          String strFullName = fullName.text.trim();
          String strPassword = password.text.trim();
          try {
            AuthController controller = Get.put(AuthController());
            controller.updateRegisterValues(
              strEmail,
              strPassword,
              strFullName,
              file!,
            );
            await AuthService().signUp();
          } catch (e) {
            setState(() {
              _isLoading = false;
            });
            debugPrint(e.toString());
          } finally {
            setState(() {
              _isLoading = false;
            });
          }
        } else {
          showError(message: "Veuillez choisir une photo de profil !");
        }
      } else {
        showError(
          message: "Les deux motes de passe ne correspondent pas !",
          title: "Erreur !",
        );
      }
    } else {
      showError(message: "Veuillez remplir correctement le formulaire !");
    }
  }
}

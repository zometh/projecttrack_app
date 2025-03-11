import 'package:diop_mouhamed_l3gl_examen/config/colors.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/enum_textstyle.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/textfield_type.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/register.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/form_validator.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_button.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController email;
  late TextEditingController password;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    email = TextEditingController();
    password = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Form(
            key: _key,
            child: Column(
              spacing: 13.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CustomText(
                    text: "Project Track",
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomText(
                  text: "Connectez-vous pour continuer",
                  customStyle: CustomTextStyle.secondary,
                  adaptColor: false,
                  fontSize: 16,
                ),
                CustomTextField(
                                    validator: (value) => FormValidator.isValidMail(value!),

                  controller: email, hintText: "Adresse email"),
                CustomTextField(
                  validator: (value) => FormValidator.isValidPassword(value!),
                  controller: password,
                  hintText: "Mot de passe",
                  type: TextFieldType.password,
                ),
                CustomButton(
                  text: "Se connecter",
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      Get.snackbar("info", "validate");
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

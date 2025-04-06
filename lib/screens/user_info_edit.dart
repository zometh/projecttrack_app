import 'dart:io';

import 'package:diop_mouhamed_l3gl_examen/enum/textfield_type.dart';
import 'package:diop_mouhamed_l3gl_examen/models/my_user.dart';
import 'package:diop_mouhamed_l3gl_examen/services/firestore_db.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_button.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_textfield.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/form_validator.dart';
import '../widgets/my_toast_notif.dart';
class UserInfoEdit extends StatefulWidget {
  final MyUser user;
  const UserInfoEdit({super.key, required this.user});

  @override
  State<UserInfoEdit> createState() => _UserInfoEditState();
}

class _UserInfoEditState extends State<UserInfoEdit> {
  MyUser  get user => widget.user;
  bool canEditPassword =false;
  late TextEditingController username;
  bool _isLoading = false;
  late TextEditingController password;
  late TextEditingController passwordConfirm;
  GlobalKey<FormState> key = GlobalKey<FormState>();
  File? file;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    username = TextEditingController(text: user.fullName);
    password = TextEditingController();
    passwordConfirm = TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Modifier mes informations"),
      ),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(8),
        
        child: Form(
          key: key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10.h,
            children: [
              Center(
                child: InkWell(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 65,
                    backgroundImage:
                    file != null ? FileImage(file!) : NetworkImage(user.imageUrl),
                        ),
                )),
              SizedBox(height: 7.h,),
              CustomTextField(

                  controller: username, hintText: "Nom complet", prefixIcon: Icons.person,
                  validator:
                      (value) => FormValidator.isValidFullName(value!.trim())
              ),
              Row(
                children: [
                  CustomText(text: "Modifier le mot de passe ?"),
                  Checkbox(value: canEditPassword, onChanged: (value) => setState(() => canEditPassword = value!))
                ],
              ),
              if(canEditPassword)
              CustomTextField(
                controller: password,
                hintText: "Nouveau mot de passe", prefixIcon
                  : Icons.lock,type:
              TextFieldType.password,
                validator:
                    (value) => FormValidator.isValidPassword(value!.trim()),
              ),
              if(canEditPassword)
              CustomTextField(
                controller: passwordConfirm,
                hintText: "Confirmation du mot de passe",
                prefixIcon: Icons.lock,type:
              TextFieldType.password,),
              _isLoading? loadingComponent :  CustomButton(text: "Modifier", onPressed: editInfos)
            ],
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
  editInfos() async{
    String _fullName = username.text.trim();
    String _password = password.text.trim();
    String _passwordConfirm = passwordConfirm.text.trim();
    String successMessage = "Vos informations ont été modifiées avec succès !";
    if(key.currentState!.validate()){
      try{
        setState(() {
          _isLoading = true;
        });
        if(canEditPassword){
          if (password.text.trim() == passwordConfirm.text.trim()){
            await FirestoreDb().updateInfos(fullName: _fullName, password: _password, image: file).then((onValue)
                {
                  showSuccess(message: successMessage);
                  Get.back();
                }
            );
          }else{
            showError(message: "Les deux motes de passe ne correspondent pas !");
          }
        }else{
          await FirestoreDb().updateInfos(fullName: _fullName, image: file).then((onValue) {
            {
              showSuccess(message: successMessage);
              Get.back();
            }
          });
        }
      }catch(e){
        setState(() {
          _isLoading = false;
        });
        debugPrint(e.toString());
        showError(message: "Une erreur est survenue. Veuillez réssayer plus tard !");
      }
    }else{
      showError(message: "Veuillez remplir correctement le formulaire !");
    }
  }
}

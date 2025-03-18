import 'package:diop_mouhamed_l3gl_examen/controllers/project_action_controller.dart';
import 'package:diop_mouhamed_l3gl_examen/services/firestore_db.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/fomat_text.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/form_validator.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/format_date.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_button.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_textfield.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/loading.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/my_date_picker.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/my_toast_notif.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/priority_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:intl/date_symbol_data_local.dart';

class ProjectAddPage extends StatefulWidget {
  const ProjectAddPage({super.key});

  @override
  State<ProjectAddPage> createState() => _ProjectAddPageState();
}

class _ProjectAddPageState extends State<ProjectAddPage> {
  bool _isLoading = false;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting('fr_FR', null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Créer un projet")),
      body: GetBuilder<ProjectActionController>(
        init: ProjectActionController(),
        builder: (controller) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 20.h),
              child: Form(
                key: _key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 13.h,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextField(
                      validator:
                          (value) =>
                              FormValidator.isValidField(input: value!.trim()),
                      borderRadius: 12,
                      prefixIcon: Icons.text_fields,
                      controller: controller.title.value,
                      hintText: "Titre du projet",
                    ),
                    CustomTextField(
                      validator:
                          (value) => FormValidator.isValidField(
                            input: value!.trim(),
                            nbCar: 10,
                          ),
                      maxLines: 7,
                      borderRadius: 12,
                      prefixIcon: Icons.text_fields,
                      controller: controller.description.value,
                      hintText: "Description du projet",
                    ),
                    CustomText(text: "Dates du projet", fontSize: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            MyDatePicker(
                              date: controller.start.value,
                              onDateChanged: (d) {
                                setState(() {
                                  controller.start.value = d;
                                });
                              },
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(text: "Date début"),
                                CustomText(
                                  text: FormatDate().formatDateComplete(
                                    controller.start.value,
                                  ),

                                  fontSize: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            MyDatePicker(
                              date: controller.end!.value,
                              onDateChanged:
                                  (d) => setState(() {
                                    controller.end.value = d;
                                  }),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(text: "Date Fin"),
                                CustomText(
                                  text: FormatDate().formatDateComplete(
                                    controller.end.value,
                                  ),
                                  fontSize: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    CustomText(text: "Priorité", fontSize: 18),
                    PriorityChoice(),
                    _isLoading
                        ? loadingComponent
                        : CustomButton(text: "Créer", onPressed: createProject),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  createProject() async {
    ProjectActionController controller = Get.put(ProjectActionController());
    if (_key.currentState!.validate()) {
      if (controller.start.value.isBefore(controller.end.value)) {
        if (ProjectActionController.to.priority != null) {
          try {
            controller.updateValue();
            setState(() {
              _isLoading = true;
            });
            await FirestoreDb().createProject().then((onValue) {
              showSuccess(message: "Projet crée avec succès !");
              Get.back();
            });
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
          showError(message: "Veuillez choisir une priorité !");
        }
      } else {
        showError(
          message:
              "La date de début ne doit pas etre supérieure ou égale à la date de fin !",
        );
      }
    } else {
      showError(message: "Veuillez remplir correctement le formulaire !");
    }
  }
}

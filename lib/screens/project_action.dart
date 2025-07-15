import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diop_mouhamed_l3gl_examen/controllers/project_action_controller.dart';
import 'package:diop_mouhamed_l3gl_examen/models/project.dart';
import 'package:diop_mouhamed_l3gl_examen/services/firestore_db.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/form_validator.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/format_date.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_button.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_textfield.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/loading.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/my_date_picker.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/my_toast_notif.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:intl/date_symbol_data_local.dart';

class ProjectActionPage extends StatefulWidget {
  final bool isEdit;
  const ProjectActionPage({super.key, this.isEdit = false});

  @override
  State<ProjectActionPage> createState() => _ProjectActionPageState();
}

class _ProjectActionPageState extends State<ProjectActionPage> {
  bool _isLoading = false;
  bool get isEdit => widget.isEdit;
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
      appBar: AppBar(title: Text(isEdit ? "Modifier le projet" : "Créer un projet")),
      body: GetBuilder<ProjectActionController>(

        init: ProjectActionController(),
        builder: (controller) {
          if(isEdit){
            Project project = controller.currentProject;
            controller.title.value.text = project.title;
            controller.description.value.text = project.description;
            //controller.start.value = project.startDate.toDate();
            //controller.end.value = project.endDate.toDate();
          }

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
                      //initialValue: isEdit ? project.title : null,
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
                                  text: FormatDate().formatToSimple(
                                    Timestamp.fromDate(controller.start.value),
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

                              date: controller.end.value,
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
                                  text: FormatDate().formatToSimple(
                                    Timestamp.fromDate(controller.end.value),
                                  ),
                                  fontSize: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox()
                      ],
                    ),
                    CustomText(text: "Priorité", fontSize: 18),
                    PriorityChoice(),
                    _isLoading
                        ? loadingComponent
                        : CustomButton(text: isEdit? "Modifier" : "Créer", onPressed: addOrUpdate),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  addOrUpdate() async {
    ProjectActionController controller = Get.put(ProjectActionController());
    if (_key.currentState!.validate()) {
      final start = controller.start.value;
      final end = controller.end.value;
      if (start.isBefore(end) || start == end) {
        if (controller.priority != null) {
          try {
            controller.updateValue();
            setState(() {
              _isLoading = true;
            });
            await FirestoreDb().createOrUpdate(isEdit: isEdit).then((onValue){
              showSuccess(message: isEdit ? "Projet modifié avec succès !" : "Projet créé avec succès !");
              Get.back();
              controller.resetValue();

            });
            await controller.updateCurrentProjectInfo().then((onValue){
              /*showSuccess(message: isEdit ? "Projet modifié avec succès !" : "Projet créé avec succès !");
              Get.back();
              controller.resetValue();*/

            });
          } catch (e) {
            setState(() {
              _isLoading = false;
            });
            debugPrint(e.toString());
          } finally {
            if(mounted){
              setState(() {
                _isLoading = false;
              });
            }
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

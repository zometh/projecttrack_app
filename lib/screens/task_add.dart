import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../controllers/project_action_controller.dart';
import '../services/firestore_db.dart';
import '../utils/form_validator.dart';
import '../utils/format_date.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/loading.dart';
import '../widgets/member_bottom_sheet.dart';
import '../widgets/my_date_picker.dart';
import '../widgets/my_toast_notif.dart';

class TaskAdd extends StatefulWidget {
  const TaskAdd({super.key});

  @override
  State<TaskAdd> createState() => _TaskAddState();
}

class _TaskAddState extends State<TaskAdd> {
  bool _isLoading = false;
  GlobalKey<FormState> key = GlobalKey<FormState>();
  ProjectActionController controller = Get.put(ProjectActionController());
  late String projectId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting('fr_FR', null);
    projectId = controller.currentProject.id;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter une tâche"),
      ),
      body: GetBuilder<ProjectActionController>(
        init: ProjectActionController(),
        builder: (controller) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 20.h),
              child: Form(
                key: key,
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
                      hintText: "Titre de la tâche",
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
                      hintText: "Description",
                    ),
                    CustomText(text: "Date de la tâche", fontSize: 18),
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
                              isEndDate: true,
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
                    CustomText(text: "Membre à assigner", fontSize: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(text: "Choisissez le membre"),
                        IconButton(onPressed: ()async{
                          showModalBottomSheet(
                              showDragHandle: true,
                              isScrollControlled: true,
                              context: context, builder: (context) => MemberBottomSheet());
                        }, icon: Icon(Icons.person))

                      ],
                    ),
                    _isLoading
                        ? loadingComponent
                        : CustomButton(text: "Créer", onPressed: createTask),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  createTask() async {
    ProjectActionController controller = Get.put(ProjectActionController());
    if (key.currentState!.validate()) {
      final start = controller.start.value;
      final end = controller.end.value;
      if (start.isBefore(end) && start != end) {
        if (controller.priority != null) {
          if(controller.currentMember.email.isNotEmpty){
            try {
              controller.updateValue();
              setState(() {
                _isLoading = true;
              });
              await FirestoreDb().createTask().then((onValue) {
                showSuccess(message: "Tache crée avec succès !");
                controller.resetValue();
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
          }else{
            showError(message: "Veuillez choisir un membre !");
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

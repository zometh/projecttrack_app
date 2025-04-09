import 'package:diop_mouhamed_l3gl_examen/controllers/project_action_controller.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class PriorityChoice extends StatelessWidget {
  const PriorityChoice({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> priorities = ["Basse", "Moyenne", "Haute", "Urgente"];
    return GetBuilder<ProjectActionController>(
      builder: (controller) {
        return DropdownButtonFormField<int>(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
          ),
          items:
              priorities
                  .map(
                    (priority) => DropdownMenuItem(
                      value: priorities.indexOf(priority),
                      child: CustomText(text: priority),
                    ),
                  )
                  .toList(),
          onChanged: (value) => controller.updatePriority(value!),
          hint: Text("Sélectionnez une priorité"),
        );
      }
    );
  }
}
class MemberRoleChoice extends StatelessWidget {
  const MemberRoleChoice({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> roles = ["Administrateur", "Membre"];
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      ),
      items:
      roles
          .map(
            (role) => DropdownMenuItem(
          value: roles.indexOf(role),
          child: CustomText(text: role),
        ),
      )
          .toList(),
      onChanged: (value) {
        int role = value == 0 ? 0 : 2;
        ProjectActionController.to.updateRole(role);},
      hint: Text("Sélectionnez le type de membre"),
    );
  }
}


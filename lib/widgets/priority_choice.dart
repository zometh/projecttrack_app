import 'package:diop_mouhamed_l3gl_examen/controllers/project_action_controller.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PriorityChoice extends StatelessWidget {
  const PriorityChoice({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> priorities = ["Basse", "Moyenne", "Haute", "Urgente"];
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
      onChanged: (value) => ProjectActionController.to.updatePriority(value!),
      hint: Text("Sélectionnez une priorité"),
    );
  }
}

import 'package:diop_mouhamed_l3gl_examen/config/colors.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/project_priority.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/project_status.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/role.dart';
import 'package:flutter/material.dart';

Color getColorPriority(ProjectPriority priority) {
  switch (priority) {
    case ProjectPriority.low:
      return kpriorityLow;
    case ProjectPriority.medium:
      return kpriorityMedium;
    case ProjectPriority.high:
      return kpriorityHigh;
    case ProjectPriority.urgent:
      return kpriorityUrgent;
  }
}

Color getColorStatus(ProjectStatus status) {
  switch (status) {
    case ProjectStatus.pending:
      return kpending;
    case ProjectStatus.inProgress:
      return kinProgress;
    case ProjectStatus.completed:
      return kcompleted;
    case ProjectStatus.cancelled:
      return kcancelled;
  }
}
Color getColorbyRole(UserProjectRole role){
  switch(role){

    case UserProjectRole.admin:
      return kadmin;
    case UserProjectRole.projectLead:
      return kcreateur;
      throw UnimplementedError();
    case UserProjectRole.teamMember:
      return kmembre;
  }
}
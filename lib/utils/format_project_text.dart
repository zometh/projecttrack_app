import 'package:diop_mouhamed_l3gl_examen/enum/project_priority.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/project_status.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/role.dart';

class FormatProjectText {
  String getTextStatus(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.pending:
        return "En attente";

      case ProjectStatus.inProgress:
        return "En cours";
      case ProjectStatus.completed:
        return "Terminé";
      case ProjectStatus.cancelled:
        return "Annulé";
    }
  }

  String getTextPriority(ProjectPriority priority) {
    switch (priority) {
      case ProjectPriority.low:
        return "Faible";

      case ProjectPriority.medium:
        return "Moyenne";
      case ProjectPriority.high:
        return "Haute";
      case ProjectPriority.urgent:
        return "Urgente";
    }
  }
  String getTextMember(UserProjectRole role){
    switch(role){

      case UserProjectRole.admin:
        return "Admin";
      case UserProjectRole.projectLead:
        return "Créateur";
      case UserProjectRole.teamMember:
        return "Membre";
    }
  }
}

import 'package:diop_mouhamed_l3gl_examen/enum/project_priority.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/project_status.dart';

class Mproject {
  static ProjectStatus getStatusByIndex(int index) {
    switch (index) {
      case 0:
        return ProjectStatus.pending;
      case 1:
        return ProjectStatus.inProgress;
      case 2:
        return ProjectStatus.completed;
      default:
        return ProjectStatus.cancelled;
    }
  }

  static int getStatus(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.pending:
        return 0;
      case ProjectStatus.inProgress:
        return 1;
      case ProjectStatus.completed:
        return 2;
      default:
        return 3;
    }
  }

  static ProjectPriority getPriorityByIndex(int index) {
    switch (index) {
      case 0:
        return ProjectPriority.low;
      case 1:
        return ProjectPriority.medium;
      case 2:
        return ProjectPriority.high;
      default:
        return ProjectPriority.urgent;
    }
  }

  static int getPriority(ProjectPriority priority) {
    switch (priority) {
      case ProjectPriority.low:
        return 0;
      case ProjectPriority.medium:
        return 1;
      case ProjectPriority.high:
        return 2;
      default:
        return 3;
    }
  }
}

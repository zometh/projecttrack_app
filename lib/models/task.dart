import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/project_priority.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/project_status.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/mapping/m_project.dart';

class Task{
  final String id;
  final String title;
  final String description;
  final String assignedTo;
  final ProjectPriority priority;
  final ProjectStatus status;
  final Timestamp endDate;
  final Timestamp startDate;
  final String projectId;
  final int progress;
  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.priority,
    required this.status,
    required this.endDate,
    required this.projectId,
    required this.progress,
    required this.startDate,
  });
  factory Task.fromFirestore(Map<String, dynamic> data){
    return Task(
        id: data["id"],
        title: data["title"],
        description: data["description"],
        assignedTo: data["assignedTo"],
        priority: Mproject.getPriorityByIndex(data["priority"]) ,
        status: Mproject.getStatusByIndex(data["status"]),
        endDate: data["endDate"],
        projectId: data["projectId"],
        progress: data["progress"],
        startDate: data["startDate"],
    );
  }
}
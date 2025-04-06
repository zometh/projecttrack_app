import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectNotif{
  final String id;
  final String owner;
  final Timestamp date;
  final String projectId;
  final bool isRead;

  ProjectNotif({
    required this.id,
    required this.owner,
    required this.date,
    required this.projectId,
  required  this.isRead,
  });

  factory ProjectNotif.fromJson(Map<String, dynamic> json) => ProjectNotif(
    id: json["id"],
    owner: json["owner"],
    date: json["date"],
    projectId: json["projectId"],
    isRead: json["isRead"]
  );




}
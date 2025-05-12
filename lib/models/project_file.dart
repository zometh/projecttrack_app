import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectFile {
  final String id;
  final Timestamp date;
  final String uploadedBy;
  final String fileUrl;
  final String title;
  final String extension;
  final String projectId;
  final double fileSize;
  const ProjectFile( {
    required this.id,
    required this.date,
    required this.uploadedBy,

    required this.fileUrl,
    required this.title,
    required this.extension,
    required this.projectId,
    required this.fileSize,
  });
  factory ProjectFile.fromFirestore(Map<String, dynamic> data) {
    return ProjectFile(
      id: data["id"],
      date: data["date"],
      uploadedBy: data["publishedBy"],
      fileUrl: data["fileUrl"],
      title: data["title"],
      extension: data["extension"],
      projectId: data["projectId"],
      fileSize: data["fileSize"],
    );
  }
}

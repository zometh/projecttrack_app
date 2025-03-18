import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diop_mouhamed_l3gl_examen/controllers/project_action_controller.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/project_status.dart';
import 'package:diop_mouhamed_l3gl_examen/services/supabase_service.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/my_toast_notif.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class FirestoreDb {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final SupabaseService _supabaseService = SupabaseService();
  final fProjectName = "projects";
  final fMemebersName = "membersMail";
  final fUsersName = "users";

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserProjects(
    ProjectStatus status,
  ) {
    Query<Map<String, dynamic>> query = _db
        .collection(fProjectName)
        .where(fMemebersName, arrayContains: _auth.currentUser!.email);
    switch (status) {
      case ProjectStatus.pending:
        return _getProjectSnapshots(query, 0);
      case ProjectStatus.inProgress:
        return _getProjectSnapshots(query, 1);
      case ProjectStatus.completed:
        return _getProjectSnapshots(query, 2);
      case ProjectStatus.cancelled:
        return _getProjectSnapshots(query, 3);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _getProjectSnapshots(
    Query<Map<String, dynamic>> query,
    int status,
  ) {
    return query
        .where("status", isEqualTo: status)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> addUser(
    String uid,
    String email,
    String fullName,
    File image,
  ) async {
    String imageUrl = await _supabaseService.getImageUrl(uid, image);
    Map<String, dynamic> infos = {
      "uid": uid,
      "email": email,
      "fullName": fullName,
      "imageUrl": imageUrl,
      "projects": [],
    };
    await _db.collection(fUsersName).doc(uid).set(infos);
  }

  Future<void> createProject() async {
    try {
      ProjectActionController controller = Get.put(ProjectActionController());
      String creator = _auth.currentUser!.uid;
      String creatorMail = _auth.currentUser!.email!;
      DocumentReference document = _db.collection(fProjectName).doc();
      final datas = {
        "id": document.id,
        "creator": creatorMail,
        "title": controller.pTitle,
        "description": controller.pDescription,
        "createdAt": Timestamp.fromDate(DateTime.now()),
        "startDate": controller.endDate,
        "endDate": controller.endDate,
        "status": 0,
        "membersMail": [_auth.currentUser!.email],
        "members": [
          {"uid": creator, "email": _auth.currentUser!.email, "role": 1},
        ],
        "priority": controller.priority,
      };
      await _db
          .collection(fProjectName)
          .doc(document.id)
          .set(datas)
          .then((onValue) => controller.resetValue());
    } catch (e) {
      showError(
        message: "Une erreur est survenue. Veuillez réssayer plus tard !",
      );
      debugPrint(e.toString());
    }
  }
}

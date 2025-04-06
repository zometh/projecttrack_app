import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diop_mouhamed_l3gl_examen/controllers/project_action_controller.dart';
import 'package:diop_mouhamed_l3gl_examen/controllers/user_controller.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/project_status.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/role.dart';
import 'package:diop_mouhamed_l3gl_examen/models/my_user.dart';
import 'package:diop_mouhamed_l3gl_examen/models/project.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/auth_manager.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/login.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/user_home_page.dart';
import 'package:diop_mouhamed_l3gl_examen/services/auth_service.dart';
import 'package:diop_mouhamed_l3gl_examen/services/supabase_service.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/mapping/m_project.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/my_toast_notif.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;

import '../enum/user_role.dart';
import '../models/project_notif.dart';
import '../utils/fomat_text.dart';
import '../utils/notif_service.dart';

class FirestoreDb {
  final _db = FirebaseFirestore.instance;
 // final _auth = FirebaseAuth.instance;
  final SupabaseService _supabaseService = SupabaseService();

  final fProjectName = "projects";
  final fMemebersName = "membersMail";
  final kMembers = "members";
  final fUsersName = "users";
  final fFilesName = "files";
  String fTaskName = "tasks";
  String fChatsName = "chats";
  String fNotifName = "notifications";
  String projectId = "";
   ProjectActionController controller = Get.put(ProjectActionController());
   UserController userController = Get.put(UserController());
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserProjects(
    ProjectStatus status,
  ) {
    Query<Map<String, dynamic>> query = _db
        .collection(fProjectName)
        .where(fMemebersName, arrayContains: FirebaseAuth.instance.currentUser!.email);
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
      "blocked": false,
      "role": 2
    };
    await _db.collection(fUsersName).doc(uid).set(infos);
  }

  Stream<List<MyUser>> getAllUsers(){
    return _db.collection(fUsersName).snapshots().map((snapshot) {
      List<MyUser> users = [];

      final datas = snapshot.docs.map((doc) {
        return MyUser.fromFirestore(doc.data());
      }).toList();
      for(var data in datas){
        if(data.role == UserRole.defaultUser){
          users.add(data);
        }
      }
      return users;
    });
  }
  Future<void> listenStatusChanges() async{
    _db.collection(fUsersName).where("email", isEqualTo: AuthService().connectedUserMail).snapshots().listen((snapshot) {
      if(snapshot.docs.isNotEmpty){
        final data = snapshot.docs.first.data();
        bool isBlocked = data["blocked"];
        if(isBlocked){
          AuthService().signOut().then((onValue) {

            //showError(message: "Votre compte a été bloqué ! Contacter l'administrateur à l'adresse zomethdev@gmail.com");
          });
          Get.offAll(AuthManager());
        }
      }
    });
  }
  Future<void> updateUserAccountStatus(String email, bool status) async{
    await _db.collection(fUsersName).where('email', isEqualTo: email).get().then((snapshot) {
      snapshot.docs.first.reference.update({"blocked": status});

    });
  }
  Future<void> createProject() async {
    try {


      String creatorMail = userController.getEmail;
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
        "membersMail": [creatorMail],
        "members": [
          {"email": creatorMail, "role": 1},
        ],
        "priority": controller.priority,
        "progress": 0
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

  Future<void> putFile(File file) async {
     projectId = controller.currentProject.id;

    int imageSize = file.lengthSync();
    double fileSize = imageSize / (1024 * 1024);
  final documentReference = _db.collection(fFilesName).doc();
     String fileUrl = await _supabaseService.getFilesUrl(documentReference.id, file);
    final datas = {
      "id": documentReference.id,
      "date": Timestamp.now(),
      "publishedBy": userController.getEmail,
      "fileUrl": fileUrl,
      "title": path.basenameWithoutExtension(file.path),
      "extension": path.extension(file.path).toLowerCase(),
      "projectId": projectId,
      "fileSize": fileSize.toPrecision(2),
    };
    await documentReference.set(datas);
  }
  Future<bool> isEmailExist(String email) async{
    final datas = await _db.collection(fUsersName)
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    return datas.docs.isNotEmpty;
  }
  Future<MyUser?> getUserByMail(String email) async{
    final datas = await _db.collection(fUsersName).where('email', isEqualTo: email).limit(1).get();
    final infos = datas.docs.first.data();

    return MyUser.fromFirestore(infos);
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getProjectFiles(

  ) {
     projectId = controller.currentProject.id;
    return _db
        .collection(fFilesName)
        .where("projectId", isEqualTo: projectId)
        .snapshots();
  }

//Future<void>
  Stream<List<Member>> getProjectMembers() {
     projectId = controller.currentProject.id;
    return FirebaseFirestore.instance
        .collection(fProjectName)
        .where("id", isEqualTo: projectId)
        .snapshots()
        .map((snapshot) {

      if (snapshot.docs.isEmpty) {
        return [];
      }
      final data = snapshot.docs.first;
      List<Member> members = (data.data()["members"] as List<dynamic>?)
          ?.map(
            (memberData) =>
            Member.fromFirestore(memberData as Map<String, dynamic>),
      )
          .toList() ??
          [];


      return members;
    });}
  Future<QuerySnapshot<Map<String, dynamic>>> getMembers() {
     projectId = controller.currentProject.id;
    return FirebaseFirestore.instance
        .collection(fProjectName)
        .where("id", isEqualTo: projectId)
        .get();

    }
  Future<bool> userExist(String email) async {
    final datas = await _db.collection(fUsersName)
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    return datas.docs.isNotEmpty;
  }
    Future<bool> checkUserInProject() async{
       projectId = controller.currentProject.id;
    String email = controller.email.value.text;
      final query = await _db.collection(fProjectName).where('id', isEqualTo: projectId).get();
      final data = query.docs.first.data();
      List<Member> members = (data["members"] as List<dynamic>?)
          ?.map(
            (memberData) =>
            Member.fromFirestore(memberData as Map<String, dynamic>),
      )
          .toList() ??
          [];

      bool isExist = false;
      for(var member in members){
        if(member.email == email) {
          isExist = true;
          break ;
        }
      }
      return isExist;
    }
    Future<void> addMemberToProject( )async{

      String email = controller.email.value.text;
      int memberRole = controller.memberRole!;
       projectId = controller.currentProject.id;
      final documentReference = _db.collection(fProjectName).doc(projectId);
      await documentReference.update(
        {
          fMemebersName: FieldValue.arrayUnion([
            email
          ])}
      );
      await documentReference.update({
        "members" : FieldValue.arrayUnion([{
          "email": email,
          "role": memberRole
        }])
      });
      if(email != userController.getEmail){
        await createNotif(email);
      }

    }
    Future<void> removeMemberFromProject(
        String memberMail, UserProjectRole role)async{

      int memberRole = Mproject.getRoleId(role);
      projectId = controller.currentProject.id;
      final documentReference = _db.collection(fProjectName).doc(projectId);
      await documentReference.update({
        'members': FieldValue.arrayRemove([
          {'email': memberMail, 'role': memberRole}
        ]),
        'membersMail': FieldValue.arrayRemove([memberMail])
      });
      await _db.collection(fTaskName).where('assignedTo', isEqualTo: memberMail)
          .where('projectId', isEqualTo: projectId)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs){
          deleteTaskChats(ds.id);
          ds.reference.delete();


        }
      });
    }

    Future<Project> getOneProject(String projectId) async{
      final datas = await _db.collection(fProjectName).where('id', isEqualTo: projectId).get();
      final data = datas.docs.first.data();
      Project project = Project.fromFirestore(data);
      return project;
    }
    Future<void> createTask() async{
      Project project = controller.currentProject;
      Member currentMember = controller.currentMember;

      final documentReference = _db.collection(fTaskName).doc();
      final datas = {
        "id": documentReference.id,
        "title": controller.title.value.text,
        "description": controller.description.value.text,
        "assignedTo": currentMember.email,
        "priority": controller.priority,
        "status": 0,
        "endDate": controller.endDate,
        "startDate" : controller.startDate,
        "projectId": project.id,
        "progress": 0};
        await documentReference.set(datas);

    }
    Stream<QuerySnapshot<Map<String, dynamic>>> getProjectTasks() {
      projectId = controller.currentProject.id;
      return _db
          .collection(fTaskName)
          .where("projectId", isEqualTo: projectId).snapshots();
    }
    Future<void> sendMessage(String message, String taskId) async{
      String sender = UserController.to.getEmail;
      final documentReference = _db.collection(fChatsName).doc();
      final datas = {
        "id": documentReference.id,
        "sender": sender,
        "message": message,
        "taskId": taskId,
        "date" : Timestamp.now()
      };
      await documentReference.set(datas);

    }
    Future<void> deleteTaskChats(String taskId)async {
       _db.collection(fChatsName).where("taskId", isEqualTo: taskId).get().then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs){
          deleteChat(ds.id);
        }
      });
    }
    Stream<QuerySnapshot<Map<String, dynamic>>> getChats(String taskId) {
      return _db
          .collection(fChatsName)
          .where("taskId", isEqualTo: taskId)
          .orderBy("date").snapshots();}

  Future<void> deleteChat(String chatId) async{

    await _db.collection(fChatsName).doc(chatId).delete();


  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getCurrentUser() {
    return FirebaseFirestore.instance
        .collection(fUsersName)
        .where("email", isEqualTo: userController.getEmail)
        .snapshots();


  }
  Future<void> createNotif(String owner)async{
    Project project = controller.currentProject;
    final ref = _db.collection(fNotifName).doc();
    final datas = {
      "id": ref.id,
      "owner": owner,
      "date": Timestamp.now(),
      "projectId": project.id,
      "isRead": false
    };
    await ref.set(datas);

  }
  fetchNotifications(){
    String email = AuthService().connectedUserMail!;
    _db.collection(fNotifName)
    .where("owner", isEqualTo: email)
    .snapshots()
    .listen((notif){
      if(notif.docs.isEmpty){
        return ;
      }
      final datas = notif.docs;
      List<ProjectNotif> notifications =
          datas.map((data) => ProjectNotif.fromJson(data.data())).toList();
      for(var notif in notifications){
        if(!notif.isRead){
          displayNotif(notif.projectId, notif);
          _db.collection(fNotifName).doc(notif.id).update({"isRead": true});
      }
      }
    });
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getNotifications() {
    String email = userController.getEmail;
    return _db.collection(fNotifName)
        .where("owner", isEqualTo: email)
        .snapshots();
  }
  displayNotif(String projectId, ProjectNotif notif) async{
    Project project = await getOneProject(projectId);
    MyUser owner =    userController.getUser;
    MyUser? creator = await getUserByMail(project.creator);
    String message = "Bonjour ${owner.fullName}, vous avez été ajouté au projet ${project.title} par ${creator!.fullName}";
    await NotifService().showNotifications(
        title: "Nouvelle notification",
        body: message,
        payload: project.id
    );

  }

  Future<void> removeProject() async{
    projectId = controller.currentProject.id;
    _db.collection(fProjectName).doc(projectId).delete();
    _db.collection(fFilesName).where("projectId", isEqualTo: projectId).get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        deleteProjectFile(projectId);
        deleteProjectTasks(projectId);
        ds.reference.delete();

      }

    });

  }
  Future<void> deleteProjectFile(String projectId) async{
    await _db.collection(fFilesName).where('projectId', isEqualTo: projectId).get().then((snapshot){

      for(DocumentSnapshot ds in snapshot.docs){
        deleteFile(ds.id);
        ds.reference.delete();
      }
    });
  }
  Future<void> deleteProjectTasks(String projectId) async{
    await _db.collection(fTaskName).where("projectId", isEqualTo: projectId).get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        deleteTaskChats(ds.id);
        ds.reference.delete();
      }
    });

  }
  Future<void> deleteFile(String fileId) async{
    await _db.collection(fFilesName).doc(fileId).delete();
    await _supabaseService.removeFile(fileId);
  }

  Future<void> updateInfos({required String fullName, String password = "", File? image}) async{
    String uid = FirebaseAuth.instance.currentUser!.uid;
    Map<String, dynamic> infos = {};
    if(password.isNotEmpty){
      try {
        await AuthService().updatePassword(password);
      } on FirebaseAuthException catch (e) {
        showError(message: FormatText.getMessageFromErrorCode(e.code));
      }
    }
    if (image != null) {
      String imageUrl = await SupabaseService().getUpdateImageUrl(uid, image);
       //await SupabaseService().removeImage(uid);

      infos["imageUrl"] = imageUrl;
    }
    infos['fullName'] = fullName;
    await _db.collection(fUsersName).doc(uid).update(infos);
  }
  updateProjectProgress(int progress) async{
    projectId = controller.currentProject.id;
    await _db.collection(fProjectName).doc(projectId).update({
      "progress": progress
    });
  }
  Future<void> updateProjectStatus(ProjectStatus status) async{
    projectId = controller.currentProject.id;
    if(status == ProjectStatus.completed){
      await _db.collection(fProjectName).doc(projectId).update({
        "status": status.index,
        "progress": 100
      });
    }
    else if(status == ProjectStatus.cancelled) {
      await _db.collection(fProjectName).doc(projectId).update({
        "status": status.index,
        "progress": 0
      });
    }
    await _db.collection(fProjectName).doc(projectId).update({
      "status": status.index
    });
  }
  Future<void> updateTaskProgress({required String taskId,int? progress, ProjectStatus? status}) async{
    if(progress != null){
      if(progress == 100){
        await _db.collection(fTaskName).doc(taskId).update({
          "progress": progress,
          "status": Mproject.getStatus(status!)
        });
      }
      else if(progress >= 0 && progress <= 100){
        await _db.collection(fTaskName).doc(taskId).update({
          "progress": progress,
          "status": Mproject.getStatus(ProjectStatus.inProgress)
        });
      }
      else{
        await _db.collection(fTaskName).doc(taskId).update({
          "progress": progress,
          "status": Mproject.getStatus(ProjectStatus.pending)
        });
      }
    }
    if(status != null){
      if(status == ProjectStatus.completed){
        await _db.collection(fTaskName).doc(taskId).update({
          "progress": 100,
          "status": Mproject.getStatus(status)
        });
      }
      else{
        await _db.collection(fTaskName).doc(taskId).update({
          "status": status.index
        });
      }
    }
  }

  Future<void> removeTask(String id) async{
    await _db.collection(fTaskName).doc(id).delete();
    await deleteTaskChats(id);
  }
  Future<List<String>> getProjectMembersImage(String projectId) async{
    List<String> images = [];
    final datas = await _db.collection(fProjectName).where('id', isEqualTo: projectId).get();
    final data = datas.docs.first.data();
    List<Member>? members = (data["members"] as List<dynamic>?)
        ?.map(
          (memberData) =>
          Member.fromFirestore(memberData as Map<String, dynamic>)
    ).toList();
    if(members != null){
      for(var member in members){
        final datas = await _db.collection(fUsersName).where('email', isEqualTo: member.email).get();
        final data = datas.docs.first.data();
        images.add(data["imageUrl"]);
      }
    }
    return images;


  }
}

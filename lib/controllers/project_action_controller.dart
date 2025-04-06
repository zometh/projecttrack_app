import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diop_mouhamed_l3gl_examen/controllers/user_controller.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/role.dart';
import 'package:diop_mouhamed_l3gl_examen/services/auth_service.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/mapping/m_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../models/project.dart';
import '../services/firestore_db.dart';

class ProjectActionController extends GetxController {
  static ProjectActionController get to => Get.find();
  late Rx<TextEditingController> email ;
  late Rx<TextEditingController> searchController;
  Project get currentProject => project.value;
  Member get currentMember => member.value;
  RxBool isCreator = false.obs;
  RxBool isAdmin = false.obs;
  Rx<Project> project = Project.empty().obs;
  Rx<Member> member = Member.empty().obs;
  int? priority;
  int? memberRole;
  UserProjectRole? role;
  late Rx<TextEditingController> title;
  late Rx<TextEditingController> description;
  Rx<DateTime> start = DateTime.now().obs;
  Rx<DateTime> end = DateTime.now().add(const Duration(days: 1)).obs;

  Timestamp? startDate;
  Timestamp? endDate;
  String? pTitle;
  String? pDescription;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    searchController = TextEditingController().obs;
    title = TextEditingController().obs;
    description = TextEditingController().obs;
    email = TextEditingController().obs;
  }
  updateCurrentProject(Project newProject){
    project.value= newProject;
    update();
  }
  updateMember(Member newMember){
    member.value = newMember;
    update();
  }
  updateSearchValue(String value){
    searchController.value.text = value;
    update();
  }
  refreshCurrentProject()async{
    project.value = await FirestoreDb().getOneProject(currentProject.id);
    update();
  }

  updateProjectMembers(){

    String connectedUserMail = UserController.to.getEmail;
    isCreator.value = currentProject.creator == connectedUserMail;
    isAdmin.value = currentProject.members.any((member) => member.email == connectedUserMail && member.role == UserProjectRole.admin);
    update();
  }
  bool isCreatorOrAdmin(){
    return isCreator.value || isAdmin.value;
  }
  updateValue() {
    startDate = Timestamp.fromDate(start.value);
    endDate = Timestamp.fromDate(end.value);
    pTitle = title.value.text.trim();
    pDescription = description.value.text.trim();

    update();
  }

  resetValue() {
    title.value = TextEditingController();
    description.value = TextEditingController();
    start.value = DateTime.now();
    end.value = DateTime.now();
    priority = null;
    project.value = Project.empty();
    member.value = Member.empty();
    update();
  }

  updatePriority(int newValue) {
    priority = newValue;
    update();
  }
  updateRole(int newRole){
    memberRole = newRole;
    role = MUser.getRoleByIndex(memberRole!);
    update();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    title.value.dispose();
    description.value.dispose();
    email.value.dispose();
    searchController.value.dispose();
    super.dispose();
  }
}

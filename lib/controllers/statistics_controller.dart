import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/my_toast_notif.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class StatisticsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxBool isLoading = true.obs;

  int totalProjects = 0;
  int totalUsers = 0;
  int totalTasks = 0;
  double completionRate = 0.0;


  int pendingProjects = 0;
  int inProgressProjects = 0;
  int completedProjects = 0;
  int cancelledProjects = 0;


  int pendingTasks = 0;
  int inProgressTasks = 0;
  int completedTasks = 0;
  int cancelledTasks = 0;
double completionTaskRate = 0;

  int activeUsers = 0;
  int inactiveUsers = 0;
  double activeUsersRate = 0.0;
  double inactiveUsersRate = 0.0;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> refreshData() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    await fetchDashboardData();
    isLoading.value = false;
    showInfos(message: "Données actualisées avec succès");
    update();
  }

  Future<void> fetchDashboardData() async {
    try {

      QuerySnapshot projectsSnapshot = await _firestore.collection('projects').get();
      totalProjects = projectsSnapshot.docs.length;

      pendingProjects = 0;
      inProgressProjects = 0;
      completedProjects = 0;
      cancelledProjects = 0;

      for (var doc in projectsSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final status = data['status'] ?? '';

        switch (status) {
          case 0:
            pendingProjects++;
            break;
          case 1:
            inProgressProjects++;
            break;
          case 2:
            completedProjects++;
            break;
          case 3:
            cancelledProjects++;
            break;
        }
      }

    
      QuerySnapshot usersSnapshot = await _firestore.collection('users').where('role', isEqualTo: 2).get();
      totalUsers = usersSnapshot.docs.length;

      activeUsers = 0;
      inactiveUsers = 0;

      for (var doc in usersSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final isBlocked = data['blocked'];

        if (isBlocked) {
          inactiveUsers++;
        } else {
          activeUsers++;
        }
      }

      activeUsersRate = totalUsers > 0 ? (activeUsers / totalUsers) * 100 : 0;
      inactiveUsersRate = totalUsers > 0 ? (inactiveUsers / totalUsers) * 100 : 0;


      QuerySnapshot tasksSnapshot = await _firestore.collection('tasks').get();
      totalTasks = tasksSnapshot.docs.length;

      pendingTasks = 0;
      inProgressTasks = 0;
      completedTasks = 0;
      cancelledTasks = 0;

      for (var doc in tasksSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final status = data['status'] ?? 0;

        switch (status) {
          case 0:
            pendingTasks++;
            break;
          case 1:
            inProgressTasks++;
            break;
          case 2:
            completedTasks++;
            break;
          case 3:
            cancelledTasks++;
            break;
        }
      }

      completionRate = completedProjects / totalProjects * 100;
       completionTaskRate = completedTasks / totalTasks * 100;

      isLoading.value = false;
      update();
    } catch (e) {
      debugPrint('Erreur lors de la récupération des données: $e');
      isLoading.value = false;
      update();
    }
  }


}
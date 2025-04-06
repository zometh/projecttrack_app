import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../controllers/statistics_controller.dart';
import '../config/colors.dart';
import '../services/auth_service.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/stats_card.dart';


class AdminHome extends StatelessWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? kbackgroundDark : kbackgroundLight;
    final cardColor = isDarkMode ? kcardDark : kcardLight;
    final textColor = isDarkMode ? ktextPrimaryDark : ktextPrimaryLight;

    return GetBuilder<StatisticsController>(
      init: StatisticsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            title: Text(
              'Tableau de bord',
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
            backgroundColor: backgroundColor,
            elevation: 0,
            actions: [

              IconButton(onPressed: (){
                CustomDialog(context: context)
                    .alertDialogConfirm(
                        () => AuthService().signOut(),
                    "Déconnexion",
                    "Voulez-vous vraiment vous déconnecter ?"
                );
              }, icon: Icon(Icons.logout, color: kprimary))
             
            ],
          ),
          body: controller.isLoading.value
              ? const Center(
            child: CircularProgressIndicator(color: kprimary),
          )
              : RefreshIndicator(
            onRefresh: () async => controller.refreshData(),
            color: kprimary,
            child: SingleChildScrollView(

              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 22.h,
                children: [
                  _buildSummarySection(controller, cardColor, textColor),

                  _buildProjectStatusSection(controller, cardColor, textColor),

        
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummarySection(
      StatisticsController controller, Color cardColor, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            'Aperçu général',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Projets',
                value: controller.totalProjects.toString(),
                icon: Icons.folder,
                color: kprimary,
                cardColor: cardColor,
                textColor: textColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'Utilisateurs',
                value: controller.totalUsers.toString(),
                icon: Icons.people,
                color: ksecondary,
                cardColor: cardColor,
                textColor: textColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'Tâches',
                value: controller.totalTasks.toString(),
                icon: Icons.task_alt,
                color: ktertiary,
                cardColor: cardColor,
                textColor: textColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatCard(
                title: 'Complétion',
                value: '${controller.completionRate.toStringAsFixed(0)}%',
                icon: Icons.pie_chart,
                color: kcompleted,
                cardColor: cardColor,
                textColor: textColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProjectStatusSection(
      StatisticsController controller, Color cardColor, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            'Statut des projets',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                height: 220.h,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 50,
                    sections: [
                      PieChartSectionData(
                        value: controller.pendingProjects.toDouble(),
                        title: '${controller.pendingProjects}',
                        color: kpending,
                        radius: 70,
                        titleStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        value: controller.inProgressProjects.toDouble(),
                        title: '${controller.inProgressProjects}',
                        color: kinProgress,
                        radius: 70,
                        titleStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        value: controller.completedProjects.toDouble(),
                        title: '${controller.completedProjects}',
                        color: kcompleted,
                        radius: 70,
                        titleStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      PieChartSectionData(
                        value: controller.cancelledProjects.toDouble(),
                        title: '${controller.cancelledProjects}',
                        color: kcancelled,
                        radius: 70,
                        titleStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 5.w,
                children: [
                  _buildLegendItem('En attente', kpending, textColor),

                  _buildLegendItem('En cours', kinProgress, textColor),

                  _buildLegendItem('Terminés', kcompleted, textColor),

                  _buildLegendItem('Annulés', kcancelled, textColor),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }



  Widget _buildLegendItem(String title, Color color, Color textColor) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: textColor,
          ),
        ),
      ],
    );
  }


}
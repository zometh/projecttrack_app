import 'dart:io';

import 'package:diop_mouhamed_l3gl_examen/controllers/project_action_controller.dart';
import 'package:diop_mouhamed_l3gl_examen/models/project.dart';
import 'package:diop_mouhamed_l3gl_examen/models/project_file.dart';
import 'package:diop_mouhamed_l3gl_examen/services/firestore_db.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_button.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/file_tile.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/loading.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/my_toast_notif.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/not_found_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProjectFiles extends StatefulWidget {

  const ProjectFiles({super.key});

  @override
  State<ProjectFiles> createState() => _ProjectFilesState();
}

class _ProjectFilesState extends State<ProjectFiles> {
  ProjectActionController controller = Get.put(ProjectActionController());
  late Project project;
  bool _isUploading = false;
  String buttonText = "Ajouter un fichier";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    project = controller.currentProject;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
        child: Column(
          spacing: 10.h,
          children: [
            /*_isUploading
                ? loadingComponent
                : */
            if(controller.isUser) SizedBox(
              height: 45.h,
              width: double.infinity,
              child: CustomButton(
                text:
                    _isUploading ? "Ajout en cours ..." : "Ajouter un fichier",
                onPressed: pickFile,
                fontSize: 16,
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirestoreDb().getProjectFiles(),
                builder: (_, snapshots) {
                  if (snapshots.connectionState == ConnectionState.waiting) {
                    return loadingComponent;
                  }
                  if (!snapshots.hasData ||
                      snapshots.data == null ||
                      snapshots.data!.docs.isEmpty) {
                    return NotFoundWidget(isFileView: true);
                  }
                  final docs = snapshots.data!.docs;

                  List<ProjectFile> files =
                      docs.map((doc) {
                        final data = doc.data();
                        return ProjectFile.fromFirestore(data);
                      }).toList();

                  return ListView.builder(
                    itemCount: files.length,
                    itemBuilder: (_, index) {
                      ProjectFile file = files[index];
                      return FileTile(file: file);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  void pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        setState(() {
          _isUploading = true;
        });
        File file = File(result.files.single.path!);
        await FirestoreDb().putFile(file).then((onValue) {
          showSuccess(message: "Fichier ajouté au projet avec succès !");
          setState(() {
            _isUploading = false;
          });
        });
      } else {
        showError(message: "Aucun fichier sélectionné !");
      }
    } catch (e) {
      _isUploading = false;
      debugPrint(e.toString());
      showError(message: "Erreur lors de l'accès au fichier: ${e.toString()}");
    }
  }
}

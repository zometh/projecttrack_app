import 'dart:io';

import 'package:diop_mouhamed_l3gl_examen/config/colors.dart';
import 'package:diop_mouhamed_l3gl_examen/controllers/project_action_controller.dart';
import 'package:diop_mouhamed_l3gl_examen/controllers/user_controller.dart';
import 'package:diop_mouhamed_l3gl_examen/models/project_file.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/default_file_viewer.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/pdf_viewer.dart';
import 'package:diop_mouhamed_l3gl_examen/services/firestore_db.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/format_date.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'custom_dialog.dart';
import 'my_toast_notif.dart';

class FileTile extends StatefulWidget {
  final ProjectFile file;
  const FileTile({super.key, required this.file});

  @override
  State<FileTile> createState() => _FileTileState();
}

class _FileTileState extends State<FileTile> {
  UserController controller = Get.put(UserController());
  ProjectActionController projectActionController = Get.put(ProjectActionController());

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    String connectedUserMail = controller.getEmail;
    String creatorMail = projectActionController.currentProject.creator;
    return FutureBuilder(
        future: FirestoreDb().getUserByMail(widget.file.uploadedBy),
        builder: (_, snapshots){
          if(snapshots.connectionState == ConnectionState.waiting){
            return loadingComponent;
          }
          if(!snapshots.hasData || snapshots.data == null){
            return Center(
              child: CustomText(text: "Une erreur est survenue !"),
            );
          }
          final user = snapshots.data;
          final Card card = Card(
            elevation: 5,
            child: ListTile(
              trailing: _isLoading ? loadingComponent :
              IconButton(onPressed: ()async{
                await _downloadDocument();
              }, icon: Icon(Icons.download, color: kprimary)),
              leading: Icon(getIconByExtension(), size: 35, color: kprimary),
              title: CustomText(
                text: widget.file.title,
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Column(
                spacing: 3.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Taille : ${widget.file.fileSize} MB ° Ajouté par ${user!.fullName}",
                    overflow: TextOverflow.clip,
                  ),
                  Row(
                    spacing: 3.w,
                    children: [
                      Icon(Icons.date_range),
                      CustomText(
                        text: FormatDate().formatToSimple(widget.file.date),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );

          return (widget.file.uploadedBy == connectedUserMail || widget.file.uploadedBy == creatorMail)
            ?
           Slidable(
            key: ValueKey(widget.file.id),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),

              extentRatio: 0.25,
              children: [

                CustomSlidableAction(
                  onPressed: (_) async{
                    CustomDialog(context: context).alertDialogConfirm((){
                      try{
                        FirestoreDb().deleteFile(widget.file.id).then((onValue) => showSuccess(message: "Fichier supprimé avec succès !"));
                      }catch(e){
                        showError(message: "Une erreur est survenue !");
                      }

                    }, "Suppression d'un fichier", "Êtes-vous sûr de vouloir supprimer ce fichier ?");

                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  child: const Icon(Icons.delete),
                ),
              ],
            ),
            child: InkWell(
              onTap: () => previewFile(),
              child: card,
            ),
          ) : card;
        }
    );
  }

  void previewFile() {
    String extension = widget.file.extension;
    ProjectFile file = widget.file;
    Get.to(
      () =>
          extension == ".pdf"
              ? PDFViewerScreen(file: file)
              : isImage(extension) ? 
              InstaImageViewer(child: Image.network(file.fileUrl))
    : DefaultFileViewer(
      file: file,
    ) );
  }
  bool isImage(String extension) {
    return extension == ".jpg" ||
        extension == ".jpeg" ||
        extension == ".png" ||
        extension == ".gif";
  }
  IconData getIconByExtension() {
    switch (widget.file.extension) {
      case ".pdf":
        return Icons.picture_as_pdf;
      case ".xls" || ".xlsx":
        return Icons.functions;
      default:
        return Icons.description;
    }
  }

  Future<void> _downloadDocument() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final fileName = widget.file.title + widget.file.extension;
      final response = await http.get(Uri.parse(widget.file.fileUrl));

      if (response.statusCode == 200) {

        bool permissionGranted = false;

        if (Platform.isAndroid) {

          if (await Permission.storage.request().isGranted) {
            permissionGranted = true;
          }

          if (!permissionGranted && await Permission.manageExternalStorage.request().isGranted) {
            permissionGranted = true;
          }
        } else {

          permissionGranted = await Permission.storage.request().isGranted;
        }

        if (!permissionGranted) {
          setState(() {
            _isLoading = false;
          });
          showError(message: "Permission de stockage refusée. Veuillez l'activer dans les paramètres de l'application.");
          return;
        }


        Directory? directory;

        if (Platform.isAndroid) {

          directory = Directory('/storage/emulated/0/Download');
          if (!await directory.exists()) {

            directory = await getExternalStorageDirectory();
          }
        } else {

          directory = await getApplicationDocumentsDirectory();
        }

        if (directory == null) {
          setState(() {
            _isLoading = false;
          });
          showError(message: "Impossible de trouver un dossier pour enregistrer le fichier");
          return;
        }

        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);


        await file.writeAsBytes(response.bodyBytes);

        setState(() {
          _isLoading = false;
        });

        showSuccess(message: "Fichier téléchargé avec succès à: $filePath");
      } else {
        setState(() {
          _isLoading = false;
        });
        showError(message: "Erreur de téléchargement: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showError(message: "Erreur lors du téléchargement: ${e.toString()}");
    }
  }
}

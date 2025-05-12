import 'package:diop_mouhamed_l3gl_examen/models/project_file.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class FilePreview extends StatelessWidget {
  final ProjectFile file;
  const FilePreview({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: CustomText(text: file.title)));
  }
}

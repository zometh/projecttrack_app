import 'package:diop_mouhamed_l3gl_examen/models/project_file.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class PDFViewerScreen extends StatefulWidget {
  final ProjectFile file;
  const PDFViewerScreen({super.key, required this.file});
  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  ProjectFile get pFile => widget.file;
  String? localPath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPDF();
  }

  Future<void> loadPDF() async {
    setState(() {
      isLoading = true;
    });

    var url = pFile.fileUrl;
    final response = await http.get(Uri.parse(url));

    final dir = await getTemporaryDirectory();

    final file = File('${dir.path}/sample.pdf');

    await file.writeAsBytes(response.bodyBytes);

    setState(() {
      localPath = file.path;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PDF Viewer')),
      body:
          isLoading
              ? loadingComponent
              : PDFView(
                filePath: localPath,
                enableSwipe: true,
                swipeHorizontal: true,
                autoSpacing: false,
                pageFling: false,
                pageSnap: true,

              ),
    );
  }
}

import 'package:diop_mouhamed_l3gl_examen/models/project_file.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
import 'dart:io';

import '../widgets/loading.dart';

class DefaultFileViewer extends StatefulWidget {
  final ProjectFile file;

  const DefaultFileViewer({Key? key, required this.file}) : super(key: key);

  @override
  _DefaultFileViewerState createState() => _DefaultFileViewerState();
}

class _DefaultFileViewerState extends State<DefaultFileViewer> {
  ProjectFile get file => widget.file;
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _downloadAndOpenDocument();
  }

  Future<void> _downloadAndOpenDocument() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final fileName = path.basename(file.fileUrl) + file.extension;


      final response = await http.get(Uri.parse(file.fileUrl));

      if (response.statusCode == 200) {

        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);


        await Share.shareXFiles([
          XFile(filePath),
        ], text: 'Ouvrir avec une application ');


        Get.back();
      } else {
        setState(() {
          _error = 'Erreur de téléchargement: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Erreur: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(file.title)),
      body: Center(
        child:
            _isLoading
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    loadingComponent,
                    SizedBox(height: 16),
                    Text('Téléchargement du document en cours...'),
                  ],
                )
                : _error.isNotEmpty
                ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 48),
                    SizedBox(height: 16),
                    Text(_error, style: TextStyle(color: Colors.red)),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _downloadAndOpenDocument,
                      child: Text('Réessayer'),
                    ),
                  ],
                )
                : Container(),
      ),
    );
  }
}

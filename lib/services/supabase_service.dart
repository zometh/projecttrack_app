import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  Future<String> getImageUrl(String uid, File file) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final String filename = '${uid}_$timestamp.jpg';
    await Supabase.instance.client.storage
        .from('profiles')
        .upload(
          filename,
          file,
          fileOptions: const FileOptions(upsert: true),
        );
    final String imageUrl = Supabase.instance.client.storage
        .from('profiles')
        .getPublicUrl(filename);
    return imageUrl;
  }
}

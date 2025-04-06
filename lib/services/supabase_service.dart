import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  Future<String> getImageUrl(String uid, File file) async {

    await Supabase.instance.client.storage
        .from('profiles')
        .upload(
          uid,
          file,
          fileOptions: const FileOptions(upsert: true),
        );
    final String imageUrl = Supabase.instance.client.storage
        .from('profiles')
        .getPublicUrl(uid);
    return imageUrl;
  }

  Future<String> getUpdateImageUrl(String uid, File file) async {

    await Supabase.instance.client.storage
        .from('profiles')
        .update(
      uid,
      file,
      fileOptions: const FileOptions(upsert: true),
    );
    final String imageUrl = Supabase.instance.client.storage
        .from('profiles')
        .getPublicUrl(uid);
    return imageUrl;
  }
  Future<String> getFilesUrl(String id, File file) async {

    await Supabase.instance.client.storage
        .from('files')
        .upload(
          id,
          file,
          fileOptions: const FileOptions(upsert: true),
        );
    final String imageUrl = Supabase.instance.client.storage
        .from('files')
        .getPublicUrl(id);
    return imageUrl;
  }
  Future<void> removeFile(String id) async{

    await Supabase.instance.client.storage
        .from('files')
        .remove([id]);
  }

  removeImage(String uid) async{
    await Supabase.instance.client.storage
        .from('profiles')
        .remove([uid]);
  }
}

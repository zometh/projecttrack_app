import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diop_mouhamed_l3gl_examen/services/supabase_service.dart';

class FirestoreDb {
  final _db = FirebaseFirestore.instance;
  final SupabaseService _supabaseService = SupabaseService();
  Future<void> addUser(
    String uid,
    String email,
    String fullName,
    File image,
  ) async {
    String imageUrl = await _supabaseService.getImageUrl(uid, image);
    Map<String, dynamic> infos = {
      "uid": uid,
      "email": email,
      "fullName": fullName,
      "imageUrl": imageUrl,
    };
    await _db.collection("users").doc(uid).set(infos);
  }
}

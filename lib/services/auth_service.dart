import 'dart:io';

import 'package:diop_mouhamed_l3gl_examen/controllers/register_controller.dart';
import 'package:diop_mouhamed_l3gl_examen/services/firestore_db.dart';
import 'package:diop_mouhamed_l3gl_examen/services/supabase_service.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/fomat_text.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/my_toast_notif.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService {
  final _authInstance = FirebaseAuth.instance;
  final firestoreDb = FirestoreDb();
  UserCredential? _credential;
  Future<void> signOut() async {
    await _authInstance.signOut();
  }

  Future<void> signUp() async {
    try {
      AuthController controller = Get.put(AuthController());
      String email = controller.email.value;
      String password = controller.password.value;
      String fullName = controller.fullName.value;
      File image = controller.file.value!;
      _credential = await _authInstance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _credential!.user!.sendEmailVerification();

      await firestoreDb.addUser(_credential!.user!.uid, email, fullName, image);
      await signOut();
    } on FirebaseAuthException catch (e) {
      showError(message: FormatText.getMessageFromErrorCode(e.code));
    }
  }

  Future<void> signIn() async {
    try {
      AuthController controller = Get.put(AuthController());
      String email = controller.email.value;
      String password = controller.password.value;
      _credential = await _authInstance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!_credential!.user!.emailVerified) {
        signOut();
        showError(
          message:
              "Vous devez valider votre compte pour pouvoir vous connecter !",
        );
        _credential!.user!.sendEmailVerification();
        showSuccess(
          message:
              "Un autre mail vous de validation vous a été envoyé à votre adresse email.",
        );
      }
    } on FirebaseAuthException catch (e) {
      showError(message: FormatText.getMessageFromErrorCode(e.code));
    }
  }
}

import 'package:email_validator/email_validator.dart';

class FormValidator {
  static String? isValidMail(String email) {
    return EmailValidator.validate(email) ? null : "Adresse email incorrecte !";
  }

  static bool isValidField(String input) {
    return false;
  }

  static String? isValidPassword(String pwd) {
    return pwd.length < 6
        ? "Le mot de passe doit contenir au moins 6 caractères"
        : null;
  }
}

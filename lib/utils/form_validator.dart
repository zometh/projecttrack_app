import 'package:email_validator/email_validator.dart';

class FormValidator {
  static String? isValidMail(String email) {
    if (email.isEmpty) {
      return "Champs requis";
    } else if (!EmailValidator.validate(email)) {
      return "Adresse email incorrecte !";
    }
    return null;
  }

  static bool isValidField(String input) {
    return false;
  }

  static String? isValidPassword(String pwd) {
    return pwd.length < 6
        ? "Le mot de passe doit contenir au moins 6 caractères"
        : null;
  }
  static String? isValidFullName(String fullName) {
    if (fullName.isEmpty) {
      return "Champs requis";
    } else if (!RegExp(r'^[a-zA-Z]+ [a-zA-Z]+$').hasMatch(fullName)) {
      return "Nom complet invalide";
    }
    return null;
  }
}

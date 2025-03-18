import 'package:diop_mouhamed_l3gl_examen/enum/role.dart';

class MUser {
  static UserRole getRoleByIndex(int index) {
    switch (index) {
      case 0:
        return UserRole.admin;
      case 1:
        return UserRole.projectLead;
      default:
        return UserRole.teamMember;
    }
  }

  static int getRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 0;
      case UserRole.projectLead:
        return 1;
      default:
        return 2;
    }
  }
}

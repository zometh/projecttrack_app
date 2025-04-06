import 'package:diop_mouhamed_l3gl_examen/enum/role.dart';

class MUser {
  static UserProjectRole getRoleByIndex(int index) {
    switch (index) {
      case 0:
        return UserProjectRole.admin;
      case 1:
        return UserProjectRole.projectLead;
      default:
        return UserProjectRole.teamMember;
    }
  }

  static int getRole(UserProjectRole role) {
    switch (role) {
      case UserProjectRole.admin:
        return 0;
      case UserProjectRole.projectLead:
        return 1;
      default:
        return 2;
    }
  }
}

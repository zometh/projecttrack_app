import 'package:diop_mouhamed_l3gl_examen/enum/user_role.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/mapping/m_project.dart';

class MyUser {
  final String email;
  final String uid;
  final String fullName;
  final String imageUrl;
  final UserRole role;
  final bool blocked;
  const MyUser({required this.uid, required this.fullName, required this.imageUrl, required this.role, required this.email, required this.blocked});
   MyUser.empty() : this(uid: "", fullName: "", imageUrl: "", role: UserRole.defaultUser, email: "", blocked: false);
  factory MyUser.fromFirestore(Map<String, dynamic> data) {
    return MyUser(
      email :data["email"],
      uid :data["uid"],
      fullName :data["fullName"],
      imageUrl :data["imageUrl"],
      role : Mproject.getUserRole(data["role"]),
        blocked : data["blocked"]
    );
  }
  
}

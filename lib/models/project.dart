import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/project_priority.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/project_status.dart';
import 'package:diop_mouhamed_l3gl_examen/enum/role.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/mapping/m_project.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/mapping/m_user.dart';

class Project {
  final String id;
  final String title;
  final String description;
  final Timestamp createdAt;
  final Timestamp startDate;
  final Timestamp endDate;
  final ProjectStatus status;
  final List<dynamic> memebersMail;
  final List<Member> members;
  final ProjectPriority priority;
  final String creator;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.memebersMail,
    required this.members,
    required this.priority,
    required this.creator,
  });
  factory Project.fromFirestore(Map<String, dynamic> datas) {
    return Project(
      creator: datas["creator"],
      id: datas["id"],
      title: datas["title"],
      description: datas["description"],
      createdAt: datas["createdAt"],
      startDate: datas["startDate"],
      endDate: datas["endDate"],
      status: Mproject.getStatusByIndex(datas["status"]),
      memebersMail: datas["membersMail"],
      members:
          (datas["members"] as List<dynamic>?)
              ?.map(
                (memberData) =>
                    Member.fromFirestore(memberData as Map<String, dynamic>),
              )
              .toList() ??
          [],
      priority: Mproject.getPriorityByIndex(datas["priority"]),
    );
  }
}

class Member {
  final String uid;
  final String email;
  final UserRole role;
  Member({required this.uid, required this.email, required this.role});

  factory Member.fromFirestore(Map<String, dynamic> datas) {
    return Member(
      uid: datas["uid"],
      email: datas["email"],
      role: MUser.getRoleByIndex(datas["role"]),
    );
  }
}

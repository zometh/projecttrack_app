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
  final int progress;

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
    this.progress = 0,
  });
    Project.empty():
      id = '',
      title = '',
      description = '',
      createdAt = Timestamp.now(),
      startDate = Timestamp.now(),
      endDate = Timestamp.now(),
      status = ProjectStatus.pending,
      memebersMail = [],
      members = [],
      priority = ProjectPriority.low,
      creator = '',
          progress = 0
  ;
  factory Project.fromFirestore(Map<String, dynamic> datas) {
    return Project(
      progress: datas["progress"],
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
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "createdAt": createdAt,
      "startDate": startDate,
      "endDate": endDate,
      "status": status.index,
      "membersMail": memebersMail,
      "members": members.map((member) => member.toMap()).toList(),
      "priority": priority.index,
      "creator": creator,
    };
  }
}

class Member {

  final String email;
  final UserProjectRole role;
  Member({ required this.email, required this.role});

  factory Member.fromFirestore(Map<String, dynamic> datas) {
    return Member(

      email: datas["email"],
      role: MUser.getRoleByIndex(datas["role"]),
    );
  }
  Member.empty():
      email = '',
      role = UserProjectRole.teamMember;
  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "role": role.index,
    };
  }

}

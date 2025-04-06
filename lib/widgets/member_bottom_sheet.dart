
import 'package:diop_mouhamed_l3gl_examen/enum/role.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/project_action_controller.dart';
import '../models/project.dart';
import 'member_tile.dart';

class MemberBottomSheet extends StatefulWidget {
  const MemberBottomSheet({super.key});

  @override
  State<MemberBottomSheet> createState() => _MemberBottomSheetState();
}

class _MemberBottomSheetState extends State<MemberBottomSheet> {

  @override
  Widget build(BuildContext context) {
    //ProjectActionController actionController = Get.put(ProjectActionController());
    //Project project = controller.project.value;
    //List<Member> members = project.members.where((member) => member.role == UserProjectRole.teamMember).toList();
    return GetBuilder<ProjectActionController>(
      builder: (controller) {
        Project project = controller.currentProject;
        TextEditingController searchController = controller.searchController.value;
        List<Member> members = project.members.where((member) => member.role == UserProjectRole.teamMember).toList();
        List<Member> filteredMembers = members.where((member) => member.email.toLowerCase().contains(searchController.text.toLowerCase())).toList();

        return SizedBox(
          height: 580.h,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 3.h,
              children: [
                TextField(

                    controller: searchController,
                    onChanged: (value){
                      controller.updateSearchValue(value);
                    },
                decoration: InputDecoration(
                  hintText: "Rechercher un membre",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                  prefixIcon: Icon(Icons.search) ,

                ),
                ),
                Expanded(
                  child: searchController.text.isEmpty ? ListView.builder(
                    itemCount: members.length,
                    itemBuilder: (_, index) {
                      Member member = members[index];
                      return InkWell(
                          onTap: (){
                            controller.updateMember(member);
                            Get.back();
                          },
                          child: MemberTile(member: member, canShowButton:false,));

                    }

                      ) : ListView.builder(
                      itemCount: filteredMembers.length,
                      itemBuilder: (_, index) {
                        Member member = filteredMembers[index];
                        return InkWell(
                            onTap: (){
                              controller.updateMember(member);
                              Get.back();
                            },
                            child: MemberTile(member: member, canShowButton:false,));

                      }

                  ),
                ),
              ],
            ),
          ),
            );
      }
    );
  }
}

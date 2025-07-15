import 'package:diop_mouhamed_l3gl_examen/controllers/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> status = ["Tous", "En attente","En cours", "Terminé", "Annulé"];
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final fillColor = isDark ? Color(0xFF2A2A2A) : Colors.grey.shade200;

    final borderColor = isDark ? Colors.grey.shade800 : Colors.white;


    final hintColor = isDark ? Colors.grey.shade400 : Colors.grey.shade500;
    return GetBuilder<SearchProjectController>(
      init: SearchProjectController(),
      builder: (controller) {
        TextEditingController searchController = controller.searchController.value;
        String search = controller.search;
        return SafeArea(









          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child:
            Row(
              children: [
                Expanded(
                  child: TextFormField(

                    controller: searchController,

                    style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                    onChanged:(value) => controller.update(),
                    decoration: InputDecoration(
                      hintText: "Rechercher un projet",
                      hintStyle: TextStyle(color: hintColor),
                      filled: true,
                      fillColor:  fillColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
color: isDark ? theme.colorScheme.outline : Colors.grey.shade400,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: isDark? theme.colorScheme.primary : Colors.grey.shade400
                        ),
                      ),
                      suffixIcon: search.isNotEmpty ? IconButton(
                        onPressed: (){
                          searchController.clear();
                          controller.update();
                        },
                        icon: Icon(Icons.close, size: 30.sp,),
                      ) : null,
                      prefixIcon: Icon(Icons.search)

                    ),
                  ),
                ),
                PopupMenuButton<int>(
                  initialValue: controller.projectStatus.value,
                  icon: Icon(Icons.filter_alt, size: 30.sp),
                  onSelected: (int value) {
                   controller.updateStatus(value);
                  },

                  itemBuilder: (BuildContext context) {
                    return status.map((s){
                      return PopupMenuItem<int>(
                        value: status.indexOf(s),
                        child: Text(s),
                      );
                    }).toList();
                  },
                ),
              ],
            ),


          ),
        );
      }
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
class UserPageTile extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Widget? redirectPage;
  final bool showEdit;
  const UserPageTile({super.key, 
    required this.iconData, 
    required this.title,  
    this.redirectPage ,  this.showEdit = true});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.transparent)
      ),
      //color: ColorController().colorFive,
      child: Container(
        height: 50.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(iconData, /*color: ColorController().toDoColor,*/),
                SizedBox(width: 15.w,),
                Text(title,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                      fontSize: 15.sp,
                     // color: Colors.white,
                      fontWeight: FontWeight.w600
                  ),),
              ],
            ),
            if(showEdit)IconButton(
              icon:  const Icon(Iconsax.edit), /*color: ColorController().toDoColor,*/
              onPressed: () => Get.to(() => redirectPage!),)
          ],
        ),
      ),

    );
  }
}

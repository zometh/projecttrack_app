import 'package:diop_mouhamed_l3gl_examen/config/colors.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String imageUrl;
  const UserAvatar({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 15,
      backgroundColor: kprimary,
      backgroundImage: NetworkImage(imageUrl),
    );
  }
}

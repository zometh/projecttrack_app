import 'package:diop_mouhamed_l3gl_examen/utils/notif_service.dart';
import 'package:diop_mouhamed_l3gl_examen/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomButton(text: "SEND NOTIF", onPressed: () async{
        await NotifService().showNotifications(title: "test", body: "test body");
      }),
    );
  }
}

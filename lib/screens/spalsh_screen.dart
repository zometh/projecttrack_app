import 'package:diop_mouhamed_l3gl_examen/screens/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({super.key});

  @override
  State<SpalshScreen> createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Get.off(() => const AuthManager());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("SPLASH SCREEN .....")));
  }
}

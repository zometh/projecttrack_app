import 'package:diop_mouhamed_l3gl_examen/config/theme.dart';
import 'package:diop_mouhamed_l3gl_examen/firebase_options.dart';
import 'package:diop_mouhamed_l3gl_examen/screens/spalsh_screen.dart';
import 'package:diop_mouhamed_l3gl_examen/utils/notif_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.accessNotificationPolicy.request();
  NotifService().initNotifications();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env["SUPABASE_URL"]!,
    anonKey: dotenv.env["ANON_KEY"]!,
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      designSize: const Size(360, 758),
      child: ToastificationWrapper(
        child: GetMaterialApp(
          builder: (_, child) {
            return ScaffoldMessenger(child: child!);
          },
          debugShowCheckedModeBanner: false,
          title: 'Project Track',
          defaultTransition: Transition.cupertino,
          theme: ThemeConfig.lightTheme,
          darkTheme: ThemeConfig.darkTheme,
          home: const SpalshScreen(),
        ),
      ),
    );
  }
}
/*MaterialApp(
      title: 'Project Track',
      
      theme: ThemeConfig.lightTheme,
      darkTheme: ThemeConfig.darkTheme,
      home: const SpalshScreen(),
    )

 */

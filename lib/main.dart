import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pizza/routes.dart';
import 'package:pizza/theme/app_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'admin/controller/admin_login_controller.dart';
import 'constant/data.dart';
import 'key.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      //This is for web
      options: FirebaseOptions(
    apiKey: apiKey,
    appId: appId,
    messagingSenderId: messageSenderId,
    projectId: projectId,
    storageBucket: storageBucket,
  ));
  await Hive.initFlutter();
  await Hive.openBox(loginBox);
  /* debugPaintSizeEnabled = true; */
  Get.put(AdminLoginController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminLoginController alController = Get.find();
    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: alController.isLightTheme.value
            ? AppTheme.lightTheme()
            : AppTheme.darkTheme(),
        initialRoute: getInitialRoute(),
        getPages: routes,
      );
    });
  }
}

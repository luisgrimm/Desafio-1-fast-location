import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fastlocation/theme.dart';
import 'package:fastlocation/src/shared/storage/storage_config.dart';
import 'package:fastlocation/src/http/dio_config.dart';
import 'package:fastlocation/src/modules/initial/page/initial_page.dart';
import 'package:fastlocation/src/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  

  await StorageConfig.init();
  
  DioConfig.init();
  
  runApp(const FastLocationApp());
}

class FastLocationApp extends StatelessWidget {
  const FastLocationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FastLocation',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: AppRoutes.initial,
      home: const InitialPage(),
    );
  }
}

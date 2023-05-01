import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'configs/hive_configs.dart';
import 'model/routes.dart';
import 'view/homePage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.start();
  await Hive.openBox('radio_values');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Du e Paulinho Churrascos",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 209, 150, 92),
      ),
      routes: Routes.getRoutes(), // register your routes here
      home: const HomePage(title: "Du e Paulinho Churrascos",),
    );
  }
}

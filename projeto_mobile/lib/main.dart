import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'configs/hive_configs.dart';
import 'model/routes.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String lastRoute = prefs.getString('last_route') ?? '/';
  await HiveConfig.start();
  await Hive.openBox('radio_values');
  runApp(MyApp(lastRoute: lastRoute));
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final String lastRoute;
  const MyApp({super.key, required this.lastRoute});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Du e Paulinho Churrascos",
      initialRoute: lastRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 209, 150, 92),
      ),
      routes: Routes.getRoutes(), 
    );
  }
}

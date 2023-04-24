import 'package:flutter/material.dart';

import 'model/routes.dart';
import 'view/homePage.dart';

void main() {
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

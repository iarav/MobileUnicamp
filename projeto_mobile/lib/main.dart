import 'package:flutter/material.dart';
import 'package:projeto_mobile/model/routes.dart';
import 'package:projeto_mobile/view/homePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Du e Paulinho Churrascos",
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 1, 29, 62),
      ),
      routes: Routes.getRoutes(), // register your routes here
      home: const HomePage(title: "Du e Paulinho Churrascos",),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:projeto_mobile/view/loginPage.dart';
import 'package:projeto_mobile/view/mainPage.dart';

import '../view/fazerReserva.dart';


class Routes {
  static const String title = 'Du e Paulinho Churrascos';
  static const String fazerReserva = '/fazerReserva';
  static const String login = '/login';
  static const String mainPage = '/mainPage';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      fazerReserva: (BuildContext context) => const FazerReserva(title: title,),
      login: (BuildContext context) => const LoginPage(title: title,),      
      mainPage: (BuildContext context) => const MainPage(title: title,),
    };
  }
}

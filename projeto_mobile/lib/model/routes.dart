import 'package:flutter/material.dart';

import '../cadastroPage.dart';
import '../view/fazerReserva.dart';
import '../view/loginPage.dart';
import '../view/mainPage.dart';


class Routes {
  static const String title = 'Du e Paulinho Churrascos';
  static const String fazerReserva = '/fazerReserva';
  static const String login = '/login';
  static const String cadastro = '/cadastro';
  static const String mainPage = '/mainPage';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      fazerReserva: (BuildContext context) => const FazerReserva(title: title,),
      login: (BuildContext context) => const LoginPage(title: title,),     
      cadastro: (BuildContext context) => const CadastroPage(title: title,),       
      mainPage: (BuildContext context) => const MainPage(title: title,),
    };
  }
}

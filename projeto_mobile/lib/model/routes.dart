import 'package:flutter/material.dart';
import '../view/editarPerfil.dart';
import '../view/cadastroPage.dart';
import '../view/fazerReserva.dart';
import '../view/loginPage.dart';
import '../view/mainPage.dart';
import '../view/PagesAdm/admMainPage.dart';
import '../view/sobreAplicativo.dart';

class Routes {
  static const String title = 'Du e Paulinho Churrascos';
  static const String fazerReserva = '/fazerReserva';
  static const String login = '/login';
  static const String cadastro = '/cadastro';
  static const String mainPage = '/mainPage';
  static const String admMainPage = 'PagesAdm/admMainPage';
  static const String editarPerfil = 'PagesAdm/editarPerfil';
  static const String sobreAplicativo = 'PagesAdm/sobreAplicativo';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      fazerReserva: (BuildContext context) => const FazerReserva(title: title,),
      login: (BuildContext context) => const LoginPage(title: title,),     
      cadastro: (BuildContext context) => const CadastroPage(title: title,),       
      mainPage: (BuildContext context) => const MainPage(title: title,),
      admMainPage: (BuildContext context) => const AdmMainPage(title: title,),
      editarPerfil: (BuildContext context) => const EditarPerfil(title: title,),
      sobreAplicativo: (BuildContext context) => const SobreAplicativo(title: title,),
    };
  }
}

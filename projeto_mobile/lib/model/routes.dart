import 'package:flutter/material.dart';

import '../view/fazerReserva.dart';


class Routes {
  static const String fazerReserva = '/fazerReserva';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      fazerReserva: (BuildContext context) => const FazerReserva(title: "Du e Paulinho Churrascos",),
    };
  }
}

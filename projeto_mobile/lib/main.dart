import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/dadosReservas/dadosReservas_bloc.dart';
import 'bloc/dataBloqueada/dataBloqueada_bloc.dart';
import 'bloc/dadosUsuario/dadosUsuario_bloc.dart';
import 'configs/hive_configs.dart';
import 'model/routes.dart';

iniciarFireBase() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

void main() async {
  iniciarFireBase();

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String lastRoute = prefs.getString('last_route') ?? '/';
  await HiveConfig.start();
  await Hive.openBox('radio_values');
  await Hive.openBox('textform_values');
  await Hive.openBox('reservas_canceladas');
  await Hive.openBox('reservas');
  runApp(MyApp(lastRoute: lastRoute));
}

class MyApp extends StatelessWidget {
  final String lastRoute;
  const MyApp({super.key, required this.lastRoute});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DadosUsuarioBloc>(
          create: (context) => DadosUsuarioBloc(context),
        ),
        BlocProvider<DataBloqueadaBloc>(
          create: (context) => DataBloqueadaBloc(context),
        ),
        BlocProvider<DadosReservasBloc>(
          create: (context) => DadosReservasBloc(context),
        ),
      ],
      child: MaterialApp(
        title: "Du e Paulinho Churrascos",
        initialRoute: lastRoute,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 209, 150, 92),
        ),
        routes: Routes.getRoutes(),
      ),
    );
  }
}

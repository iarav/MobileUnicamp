// ignore: file_names
import 'package:flutter/material.dart';

import '../model/routes.dart';
import '../model/save_path.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/assets/DU_PAULINHO.png',
                        width: 266,
                        height: 266,
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  botaoEntrar(),
                  const SizedBox(height: 25),
                  botaoCadastro(),
                ],
              ),
            ),
            //const SizedBox(height: 80),
            botaoSaberMais(),
          ],
        ),
      ),
    );
  }

  Widget botaoEntrar() {
    return ElevatedButton(
        onPressed: () {
          SavePath.changePath(Routes.login);
          Navigator.pushNamed(
            context,
            Routes.login, //define your route name
          );
        },
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xFF05173D)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 34.0),
            )),
        child: const Text(
          "Entrar",
          style: TextStyle(
            fontSize: 15,
            shadows: [
              Shadow(
                blurRadius: 2.0,
                color: Color.fromARGB(255, 24, 24, 24),
                offset: Offset(1.0, 1.0),
              ),
            ],
          ),
        ));
  }

  Widget botaoCadastro() {
    return ElevatedButton(
        onPressed: () {
          SavePath.changePath(Routes.cadastro);
          Navigator.pushNamed(
            context,
            Routes.cadastro, //define your route name
          );
        },
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xFF05173D)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 34.0),
            )),
        child: const Text(
          "Fazer Cadastro",
          style: TextStyle(
            fontSize: 15,
            shadows: [
              Shadow(
                blurRadius: 2.0,
                color: Color.fromARGB(255, 24, 24, 24),
                offset: Offset(1.0, 1.0),
              ),
            ],
          ),
        ));
  }

  Widget botaoSaberMais() {
    return ElevatedButton(
        onPressed: () {
          SavePath.changePath(Routes.sobreAplicativo);
          Navigator.pushNamed(
            context,
            Routes.sobreAplicativo, //define your route name
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(0, 1, 29, 62)),
          padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
          ),
          elevation: MaterialStateProperty.all<double>(0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.info_outline),
            SizedBox(
              width: 15,
            ),
            Text(
              "Saiba mais sobre o aplicativo",
              style: TextStyle(
                fontSize: 15,
                shadows: [
                  Shadow(
                    blurRadius: 2.0,
                    color: Color.fromARGB(145, 24, 24, 24),
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

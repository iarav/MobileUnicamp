// ignore: file_names
import 'package:flutter/material.dart';
import 'package:projeto_mobile/view/loginPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 1, 29, 62),
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
                    children: const [
                      Text(
                        "Du e Paulinho \nChurrascos",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                        ),
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

  Widget botaoEntrar(){
    return ElevatedButton(
      onPressed: (){
         Navigator.push(
          context, MaterialPageRoute(
            builder: (_) => const LoginPage(title: "Du e Paulinho Churrascos",),
          )
        );
      }, 
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 7, 24, 180)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(vertical: 12.0, horizontal: 34.0),
        )
      ),
      child: const Text(
        "Entrar",
        style: TextStyle(
          fontSize: 20,
        ),
      )
    );
  }

  Widget botaoCadastro(){
    return ElevatedButton(
      onPressed: (){
      }, 
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 7, 24, 180)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(vertical: 12.0, horizontal: 34.0),
        )
      ),
      child: const Text(
        "Fazer Cadastro",
        style: TextStyle(
          fontSize: 20,
        ),
      )
    );
  }

  Widget botaoSaberMais(){
    return ElevatedButton(
      onPressed: (){
      }, 
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(0, 1, 29, 62)),
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
        ),
        elevation: MaterialStateProperty.all<double>(0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.info_outline),
          SizedBox(width: 15,),
          Text(
            "Saiba mais sobre o aplicativo",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      )
    );
  }
}
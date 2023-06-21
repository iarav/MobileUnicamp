// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SobreAChurrascaria extends StatefulWidget {
  const SobreAChurrascaria({super.key});

  @override
  State<SobreAChurrascaria> createState() => _SobreAChurrascariaState();
}

class _SobreAChurrascariaState extends State<SobreAChurrascaria> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                imgChurrascaria(),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Du e Paulinho Churrascos",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  width: 345,
                  child: Text(
                    "Empreendedores autônomos, fornecemos o churrasco para você, do jeito que você quiser e quando quiser.",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: 350,
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 181, 181, 181),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Contato:",
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'lib/assets/whatsapp.svg',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            "(19) 999999-9999",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.email_outlined,
                            color: Colors.black,
                            size: 26,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "churras@gmail.com",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget imgChurrascaria() {
    return Image.asset(
      'lib/assets/churrascaria-capa.jpg',
      height: 201,
      width: 335,
    );
  }
}

import 'package:flutter/material.dart';

class SobreAplicativo extends StatefulWidget {
  const SobreAplicativo({super.key, required this.title});

  final String title;

  @override
  State<SobreAplicativo> createState() => _SobreAplicativoState();
}

class _SobreAplicativoState extends State<SobreAplicativo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 209, 150, 92),
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
              fontFamily: 'bright', color: Color(0xFF05173D), fontSize: 24),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.95,
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 243, 240, 240),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF05173D),
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.info_outline),
                        SizedBox(width: 15),
                        Text(
                          "Sobre o Aplicativo",
                          style: TextStyle(
                              fontFamily: 'bright',
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text("Esse aplicativo..."),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF05173D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: const Text(
                        "OK",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 15,
                          shadows: [
                            Shadow(
                              blurRadius: 2.0,
                              color: Color.fromARGB(255, 24, 24, 24),
                              offset: Offset(1.0, 1.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

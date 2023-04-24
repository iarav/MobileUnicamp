// ignore: file_names
import 'package:flutter/material.dart';

import '../../model/dadosReserva.dart';

class AdmVerReserva extends StatefulWidget {
  const AdmVerReserva({super.key});

  @override
  State<AdmVerReserva> createState() => _AdmVerReservaState();
}

class _AdmVerReservaState extends State<AdmVerReserva> {
  final DadosReserva reservas = DadosReserva();

  List<bool> isCardEnabled = List<bool>.generate(6, (_) => true);
  List<Color> selectedCardColor = List<Color>.generate(6, (_) => const Color.fromARGB(255, 158, 177, 181));
  int selectedCardIndex = -1;
  List<String> textoBotao= List<String>.generate(6, (_) => "Cancelar Reserva");

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 30, //limite que o index terá. Não irá passar de 30 listTile
      itemBuilder: ((context, index) => Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: Center(
              child: SizedBox(
                height: 150,
                width: MediaQuery.of(context).size.width * 0.90,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 2, // valor de elevação da sombra
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12.0), // borda arredondada
                    ),
                    color: selectedCardColor[index],
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            "${reservas.nome[index]} - ${reservas.telefone[index]}\n${reservas.data[index]} - ${reservas.qntPessoas[index]}  pessoas\n${reservas.combo[index]} - R\$${reservas.preco[index]}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: "inder",
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: isCardEnabled[index] ? () {
                            setState(() {
                              selectedCardIndex = index;
                              selectedCardColor[selectedCardIndex] = const Color.fromARGB(150, 144, 10, 0);
                              isCardEnabled[selectedCardIndex] = false;
                              textoBotao[selectedCardIndex] = 'RESERVA CANCELADA';
                            });
                          } : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 1, 29, 62),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Text(textoBotao[index]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}

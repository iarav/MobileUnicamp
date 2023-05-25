// ignore: file_names
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../model/routes.dart'; //import your routes.dart file
import '../model/complete_data.dart';
import 'selecaoDataOpcoesReserva.dart';

class OpcoesDeReserva extends StatefulWidget {
  const OpcoesDeReserva({super.key});

  @override
  State<OpcoesDeReserva> createState() => _OpcoesDeReservaState();
}

class _OpcoesDeReservaState extends State<OpcoesDeReserva> {
  final List<String> items = [
    'Combo Básico',
    'Combo Silver',
    'Combo Gold',
    'Combo Premium'
  ];
  final List<String> description = [
    'Somente Churrasco',
    'Churrasco + Arroz + Salada',
    'Churrasco + Arroz + Salada + Maionese',
    'Churrasco + Arroz + Salada + Maionese + Acompanhamento personalizado'
  ];
  final Box _radioValues = Hive.box("radio_values");

  final CompleteModel completeModel = CompleteModel();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            radioOpcoes(1, 'Opções de \nChurrasco'),
            radioOpcoes(2, 'Ver disponibilidade \nde datas'),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(child: _buildWidget()),
      ],
    );
  }

  Widget radioOpcoes(int value, String textRadio) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio(
            value: value,
            groupValue: _radioValues.get('radioOpcao') ??
                1, // completeModel.radioValue,
            onChanged: (dynamic groupValue) {
              //Esse value se refere ao group value
              // setState(() {
              //   completeModel.radioValue = groupValue ?? 1;
              // });
              setState(() {
                _radioValues.put('radioOpcao', groupValue ?? 1);
              });
            }),
        Text(
          textRadio,
          style: const TextStyle(
            fontSize: 15,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildWidget() {
    // switch (completeModel.radioValue) {
    switch (_radioValues.get('radioOpcao') ?? 1) {
      case 1:
        return Container(child: myList());
      case 2:
        return const SelecaoData();
      default:
        return Container();
    }
  }

  Widget myList() {
    return ListView.separated(
      padding: const EdgeInsets.all(15),
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 67, 67, 67),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            title: Text(
              items[index],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
              textAlign: TextAlign.center,
            ),
            subtitle: Text(
              description[index],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.fazerReserva, //define your route name
                arguments: items[index], //pass the arguments
              );
            },
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          height: 13, // Defina a altura do espaço aqui
          color: Colors.transparent,
        );
      },
    );
  }
}

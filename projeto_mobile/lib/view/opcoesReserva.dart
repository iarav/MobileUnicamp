// ignore: file_names
import 'package:flutter/material.dart';
import '../model/routes.dart';  //import your routes.dart file
import '../model/complete_data.dart';


class OpcoesDeReserva extends StatefulWidget {
  const OpcoesDeReserva({super.key});

  @override
  State<OpcoesDeReserva> createState() => _OpcoesDeReservaState();
}

class _OpcoesDeReservaState extends State<OpcoesDeReserva> {
  final List<String> items = ['Combo Básico', 'Combo Silver', 'Combo Gold', 'Combo Premium'];
  final List<String> description = ['Somente Churrasco', 'Churrasco + Arroz + Salada', 'Churrasco + Arroz + Salada + Maionese', 'Churrasco + Arroz + Salada + Maionese + Acompanhamento personalizado'];
  
  final CompleteModel completeModel = CompleteModel();
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            myRadio(1, 'Opções de \nChurrasco'),
            myRadio(2, 'Ver disponibilidade \nde datas'),
          ],
        ),
        const SizedBox(height: 20,),
        Expanded(
          child: Container(child: myList())
        ),
      ],
    );
  }

  Widget myRadio(int value, String textRadio){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio(
          value: value, 
          groupValue: completeModel.radioValue,
          onChanged: (int? groupValue){ //Esse value se refere ao group value
            setState(() {
              completeModel.radioValue = groupValue ?? 1;
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

  Widget myList(){
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
// ignore: file_names
import 'package:flutter/material.dart';

class MinhasReservas extends StatefulWidget {
  const MinhasReservas({super.key});

  @override
  State<MinhasReservas> createState() => _MinhasReservasState();
}

class _MinhasReservasState extends State<MinhasReservas> {
  final List<String> data = ['24/02/2023', '02/05/2023', '04/02/2023', '15/12/2023', '06/08/2023', '25/12/2022'];
  final List<String> qntPessoas = ['100', '200', '500', '300', '600', '1000'];
  final List<String> combo = ['Combo Básico', 'Combo Silver', 'Combo Básico', 'Combo Silver', 'Combo Gold', 'Combo Premium'];
  final List<String> preco = ['100,00', '200,00', '500,00', '300,00', '600,00', '1000,00'];
    
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20,),
        Expanded(child: Container(child: myList())),
      ],
    );
  }

  Widget myList(){
    return ListView.separated(
      padding: const EdgeInsets.all(15),
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 158, 177, 181),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            title: Column(
              children: [
                Text(
                  '${data[index]} - ${qntPessoas[index]}',
                  style: const TextStyle( 
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${combo[index]} - ${preco[index]}',
                  style: const TextStyle( 
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            subtitle: TextButton(
              child: const Text(
                'Cancelar Reserva',
                style: TextStyle( 
                  color: Color.fromARGB(255, 144, 10, 0),
                ),
              ),
              onPressed: (){
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => dialgoCancelarReserva()
                );
              },
            ),
            onTap: () {
              
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

  Widget dialgoCancelarReserva(){
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              'Você tem certeza que deseja cancelar a reserva?',
              style: TextStyle( 
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar Reserva'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:projeto_mobile/model/reservaData.dart';

import '../model/complete_data.dart';

class FazerReserva extends StatefulWidget {
  const FazerReserva({super.key, required this.title});

  final String title;

  @override
  State<FazerReserva> createState() => _FazerReservaState();
}

class _FazerReservaState extends State<FazerReserva> {
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ReservaData _reservaData = ReservaData();
  
  final CompleteModel completeModel = CompleteModel();
  
  bool justEntered = true;
  final List<String> itemsCombo = ['Combo Básico', 'Combo Silver', 'Combo Gold', 'Combo Premium'];
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    var item = ModalRoute.of(context)!.settings.arguments;
    // _reservaData.combo = item as String?;

    if(item != null){
      if(justEntered){
        if(item is DateTime?){
          _selectedDate = DateTime.parse('$item');
        }else{
            if(itemsCombo.contains(item)){
                _reservaData.combo = '$item';
            }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Reserva:",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 35),    
                comboField(itemsCombo),
                const SizedBox(height: 25),
                qntPessoasSlider(),
                const SizedBox(height: 25),
                getPreco(),
                const SizedBox(height: 25),
                selectData(),
                const SizedBox(height: 25),
                botaoFazerReserva(),
              ],
            ),
          ),
        ],
      ),
    );
  }

   Widget comboField(List<String> itemsCombo){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Combo: ",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500
          ),
        ),
        DropdownButton<String>(
          value: _reservaData.combo, 
          onChanged: (String? newValue) {
            justEntered = false;
            setState(() {
              _reservaData.combo = newValue; 
            });
          },
          items: itemsCombo
              .map((option) => DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  ))
              .toList(), 
        ),
      ],
    );
  }

  Widget qntPessoasSlider(){
    int divisoes = 9; 
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Quantidade \nde pessoas: ",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500
          ),
        ),
        Slider(
          min: 100,
          max: 1000,
          divisions: divisoes,
          value: completeModel.quantidadePessoas, 
          onChanged: (double value){
            setState(() {
              completeModel.quantidadePessoas = value.roundToDouble();
            });
          }),
        Text("${completeModel.quantidadePessoas.toInt()}"),  
      ],
    );
  }

  Widget getPreco(){
    int? indexCombo, precoPorPessoa;
    if(_reservaData.combo != null){
      indexCombo = itemsCombo.indexOf(_reservaData.combo!);
    }

    switch(indexCombo){
      case 0:
        precoPorPessoa = 2;
        break;
      case 1:
        precoPorPessoa = 4;
        break;
      case 2:
        precoPorPessoa = 5;
        break;
      case 3:
        precoPorPessoa = 7;
        break;
      default:
        precoPorPessoa = 2;
    }

    int preco = (precoPorPessoa * completeModel.quantidadePessoas * 0.5).toInt();

    return Container(
      decoration: const BoxDecoration(
        // borderRadius: BordersRadius.circular(20.0),
        color: Color.fromARGB(143, 149, 211, 255),
      ),
      padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
      child: Text(
        "Preço: $preco" ,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w500
        )
      ),
    );
  }

  Widget selectData(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Data: ',
          style: TextStyle( 
            fontSize: 22,
            fontWeight: FontWeight.w500
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          _selectedDate == null
              ? '__/__/____'
              : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
          style: const TextStyle( 
            fontSize: 22,
          ),
          textAlign: TextAlign.center,
        ),
        IconButton(
          icon: const Icon(Icons.calendar_month),
          onPressed: () => _selectDate(context),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        justEntered = false;
      });
    }
  }

  Widget botaoFazerReserva(){
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
        "Fazer Reserva",
        style: TextStyle(
          fontSize: 15,
        ),
      )
    );
  }
}

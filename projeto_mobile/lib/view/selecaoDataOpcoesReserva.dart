// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/routes.dart';

class SelecaoData extends StatefulWidget {
  const SelecaoData({super.key});

  @override
  _SelecaoDataState createState() => _SelecaoDataState();
}

class _SelecaoDataState extends State<SelecaoData> {
  DateTime? _selectedDate;
  
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            const Text(
              "Verifique aqui se a data\ndesejada está disponível:",
              style: TextStyle( 
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20,),    
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
              child: SizedBox(
                width: 210,
                child: textForm(),
              ),
            ),
            const SizedBox(height: 20,),   
            ElevatedButton(
              onPressed: () => {
                if(_selectedDate != null){
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 30),
                            Text(
                              'A data: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year} está disponível para reserva!',
                              style: const TextStyle( 
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    _selectedDate = null;
                                    _dateController.text = '';
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.fazerReserva, //define your route name
                                      arguments: _selectedDate, //pass the arguments
                                    );
                                  },
                                  child: const Text('Fazer Reserva'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                }else{
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(height: 30),
                            const Text(
                              'Selecione uma data!',
                              style: TextStyle( 
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 0, 84, 174), // Define / Define a cor do texto do botão
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ), // Define o raio dos cantos do botão
                padding: const EdgeInsets.fromLTRB(25,13,25,13)
              ),
              child: const Text(
                'Verificar',
                style: TextStyle( 
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 40,),   
          ],
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
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      final String formattedDate = formatter.format(picked);
      setState(() {
        _selectedDate = picked;
        _dateController.text =
            formattedDate; 
      });
    }
  }
  Widget textForm() {
    return TextFormField(
      controller: _dateController,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        hintText: '00/00/0000',
        hintStyle: TextStyle(
          color: Colors.grey[400],
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Campo obrigatório.';
        }
        return null;
      },
      onTap: () {
        _selectDate(context);
      },
    );
  }
}

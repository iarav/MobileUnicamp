// ignore: file_names
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/dadosReserva.dart';

class AdmBloquearData extends StatefulWidget {
  const AdmBloquearData({super.key});

  @override
  State<AdmBloquearData> createState() => _AdmBloquearDataState();
}

class _AdmBloquearDataState extends State<AdmBloquearData> {
  final _formKey = GlobalKey<FormState>();
  final DadosReserva reservas = DadosReserva();
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          const Text(
            "SELECIONAR A DATA A SER BLOQUEADA:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const Text(
            "Obs: datas bloqueadas impedem os usuários de reservar nesse dia",
            style: TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                  child: SizedBox(
                    width: 210,
                    child: textForm(),
                  ),
                ),
                botaoBloquear(),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          //O expanded diz que o listView ocupará todo o resto da tela, ele é necessário
          Expanded(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: ListView.builder(
                itemCount: reservas.data.length,
                itemBuilder: (context, index) => Card(
                  color: const Color.fromARGB(90, 180, 0, 0),
                  child: ListTile(
                    title: Text(reservas.data[index]),
                    trailing: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: const Color.fromARGB(190, 214, 100, 100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Desbloquear',
                        style: TextStyle(color: Color.fromARGB(255, 92, 0, 12)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != _selectedDate) {
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      final String formattedDate = formatter.format(picked);
      setState(() {
        _selectedDate = picked;
        // _dateController.text = picked.toString();
        _dateController.text =
            formattedDate; // Define o valor do campo de texto
      });
    }
  }

  Widget botaoBloquear() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(230, 196, 0, 33),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: const Text(
        "Bloquear",
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
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

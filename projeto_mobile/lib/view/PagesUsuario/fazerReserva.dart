// ignore_for_file: file_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:projeto_mobile/bloc/dadosReservas/dadosReservas_bloc.dart';
import 'package:projeto_mobile/bloc/dadosReservas/dadosReservas_event.dart';

import '../../bloc/bloc_state.dart';
import '../../bloc/dadosUsuario/dadosUsuario_bloc.dart';
import '../../bloc/dadosUsuario/dadosUsuario_event.dart';
import '../../bloc/dataBloqueada/dataBloqueada_bloc.dart';
import '../../bloc/dataBloqueada/dataBloqueada_event.dart';
import '../../model/complete_data.dart';
import '../../model/dadosUsuario.dart';
import '../../model/reserva.dart';
import '../../model/routes.dart';
import '../../model/save_path.dart';

class FazerReserva extends StatefulWidget {
  const FazerReserva({super.key, required this.title});

  final String title;

  @override
  State<FazerReserva> createState() => _FazerReservaState();
}

class _FazerReservaState extends State<FazerReserva> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Box _textformValues = Hive.box("textform_values");
  final Reserva _reservaData = Reserva();
  String loggedUserId = "";
  final DadosUsuario _dadosUsuarioCadastro = DadosUsuario();
  late bool estaDisponivel;

  StreamSubscription<BlocState>? _blocSubscription;

  final CompleteModel completeModel = CompleteModel();

  bool justEntered = true;
  final List<String> itemsCombo = [
    'Combo Básico',
    'Combo Silver',
    'Combo Gold',
    'Combo Premium'
  ];
  DateTime? _selectedDate;

  void getDadosUsuario(stateWidget) async {
    if (!mounted) {
      return;
    }
    final bloc = DadosUsuarioBloc(context);

    bloc.add(GetAllDadosUsuarioEvent(loggedUserId));

    bloc.stream.listen((state) async {
      if (state is LoadedState) {
        Map<String, dynamic>? usuario = state.dados;
        if (usuario != null) {
          _dadosUsuarioCadastro.converterParaDadosUsuario(usuario);
          _reservaData.cpfUsuario = _dadosUsuarioCadastro.cpf;
          _reservaData.nome = _dadosUsuarioCadastro.nome;
          _reservaData.telefone = _dadosUsuarioCadastro.telefone;
          _reservaData.qntPessoas = "100";
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content:
                  Text('Não foi possivel recuperar os dados do usuário.')));
        }
      }
    });
  }

  @override
  void initState() {
    loggedUserId = _textformValues.get('loggedUserId');
    getDadosUsuario(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var item = ModalRoute.of(context)!.settings.arguments;
    // _reservaData.combo = item as String?;

    if (item != null) {
      if (justEntered) {
        if (item is DateTime?) {
          _selectedDate = DateTime.parse('$item');
        } else {
          if (itemsCombo.contains(item)) {
            _reservaData.combo = '$item';
          }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
              fontFamily: 'bright', color: Color(0xFF05173D), fontSize: 24),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Reserva:",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
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

  Widget comboField(List<String> itemsCombo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Combo: ",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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

  Widget qntPessoasSlider() {
    int divisoes = 9;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Quantidade \nde pessoas: ",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Slider(
            min: 100,
            max: 1000,
            divisions: divisoes,
            value: completeModel.quantidadePessoas,
            onChanged: (double value) {
              setState(() {
                completeModel.quantidadePessoas = value.roundToDouble();
                var quantPessoas = completeModel.quantidadePessoas.toInt();
                _reservaData.qntPessoas = quantPessoas.toString();
              });
            }),
        Text("${completeModel.quantidadePessoas.toInt()}"),
      ],
    );
  }

  Widget getPreco() {
    int? indexCombo, precoPorPessoa;
    if (_reservaData.combo != null) {
      indexCombo = itemsCombo.indexOf(_reservaData.combo!);
    }

    switch (indexCombo) {
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

    int preco =
        (precoPorPessoa * completeModel.quantidadePessoas * 0.5).toInt();
    _reservaData.preco = preco.toString();

    return Container(
      decoration: const BoxDecoration(
        // borderRadius: BordersRadius.circular(20.0),
        color: Color.fromARGB(143, 149, 211, 255),
      ),
      padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
      child: Text("Preço: $preco",
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w500)),
    );
  }

  Widget selectData() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Data: ',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        Text(
          _selectedDate == null
              ? '__/__/____'
              : DateFormat('dd/MM/yyyy').format(_selectedDate!),
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
        var dataSelecionada = DateFormat('dd/MM/yyyy').format(_selectedDate!);
        _reservaData.dataReserva = dataSelecionada;
      });
    }
  }

  Widget botaoFazerReserva() {
    return ElevatedButton(
        onPressed: () async {
          if (_selectedDate != null && _reservaData.combo != null) {
            estaDisponivel = await verificarDisponibilidade(
                DateFormat('dd/MM/yyyy').format(_selectedDate!));
            print("if");
            if (estaDisponivel) {
              final bloc = context.read<DadosReservasBloc>();
              // Cancelar o StreamSubscription anterior, se existir
              _blocSubscription?.cancel();
              bloc.add(InsertDadosReservasEvent(_reservaData));
              _blocSubscription = bloc.stream.listen((state) async {
                if (state is LoadedState) {
                  print("Reserva cadastrada com sucesso!");
                }
              });

              // ignore: use_build_context_synchronously
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => dialgoReservaEfeuada(
                      'A reserva foi efetuada com sucesso!'));
            } else {
              // ignore: use_build_context_synchronously
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => dialgoReservaEfeuada(
                      'A data está indisponível!\nSelecione outra data.'));
            }
          } else {
            print("AQUI");
            // ignore: use_build_context_synchronously
            showDialog<String>(
                context: context,
                builder: (BuildContext context) =>
                    dialgoReservaEfeuada('Preencha todos os campos!'));
          }
        },
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xFF05173D)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 34.0),
            )),
        child: const Text(
          "Fazer Reserva",
          style: TextStyle(
            fontSize: 15,
          ),
        ));
  }

  Future<bool> verificarDisponibilidade(dataParaVerificar) async {
    final blocReservasBloqueadas = context.read<DataBloqueadaBloc>();
    List<Map<String, dynamic>> datasNaoDisponiveis = [];

    late bool disponivel;

    StreamSubscription? bloqueadasSubscription;

    Completer<bool> meuCompleter = Completer<bool>();

    blocReservasBloqueadas.add(GetDatasIndisponiveisEvent());
    bloqueadasSubscription =
        blocReservasBloqueadas.stream.listen((state) async {
      if (state is LoadedState) {
        if (state.dados != null) {
          for (var value in state.dados!.values) {
            if (value is Map<String, dynamic>) {
              datasNaoDisponiveis.add({
                'datas': value['dataIndisponivel'],
              });
            }
          }
        }
      }
      if (bloqueadasSubscription != null && datasNaoDisponiveis.isNotEmpty) {
        print("DATAS INDISPONÍVEIS: ");
        print(datasNaoDisponiveis);

        //VERIFICA SE A DATA ESTÁ OU NÃO DISPONÍVEL
        bool dataEstaDisponivel = datasNaoDisponiveis.any((map) {
          String data = map['datas'] as String;
          return data == dataParaVerificar;
        });
        disponivel = !dataEstaDisponivel;

        if (!meuCompleter.isCompleted) {
          meuCompleter.complete(disponivel);
        }
      }
    });

    await meuCompleter.future;
    if (meuCompleter.isCompleted) {
      return disponivel;
    } else {
      throw Exception('Erro ao obter a disponibilidade');
    }
  }

  Widget dialgoReservaEfeuada(String texto) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 10),
            Text(
              texto,
              style: const TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (texto == 'A reserva foi efetuada com sucesso!') {
                  SavePath.changePath(Routes.mainPage);
                  Navigator.pushNamed(
                    context,
                    Routes.mainPage, //define your route name
                  );
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('OK'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

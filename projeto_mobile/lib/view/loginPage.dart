// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:projeto_mobile/bloc/dadosUsuario/dadosUsuario_event.dart';
import '../bloc/dadosUsuario/dadosUsuario_bloc.dart';
import '../bloc/bloc_state.dart';
import '../model/routes.dart';
import '../model/save_path.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //final DadosUsuario _dadosUsuario = DadosUsuario();
  final Box _textformValues = Hive.box("textform_values");

  @override
  Widget build(BuildContext context) {
    // var pessoaCpf = ModalRoute.of(context)!.settings.arguments;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "LOGIN",
                  style: TextStyle(
                    fontFamily: 'bright',
                    color: Color(0xFF05173D),
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                  ),
                ),
              ],
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 35),
                  cpfField(),
                  const SizedBox(height: 25),
                  senhaField(),
                  const SizedBox(height: 25),
                  botaoEntrar(widget.title),
                ],
              ),
            ),
          ],
        ));
  }

  Widget cpfField() {
    return SizedBox(
      width: 250,
      child: TextFormField(
        initialValue: _textformValues.get('cpf'),
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'CPF',
          labelStyle: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.bold,
          ),
          hintText: 'Digite aqui seu CPF',
          hintStyle: TextStyle(
            color: Colors.grey[400],
          ),
        ),
        validator: (String? value) {
          if (value != null) {
            if (value.isEmpty) {
              return "Campo obrigatório.";
            }
          } else {
            return "Insira algum valor.";
          }
          return null;
        },
        onSaved: (String? value) {
          // _dadosUsuario.cpf = value ?? "";
          _textformValues.put('cpf', value);
        },
      ),
    );
  }

  Widget senhaField() {
    return SizedBox(
      width: 250,
      child: TextFormField(
        initialValue: _textformValues.get('senha'),
        obscureText: true,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Senha',
          labelStyle: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.bold,
          ),
          hintText: 'Digite aqui sua senha',
          hintStyle: TextStyle(
            color: Colors.grey[400],
          ),
        ),
        validator: (String? value) {
          if (value != null) {
            if (value.isEmpty) {
              return "Campo obrigatório.";
            }
          } else {
            return "Insira algum valor.";
          }
          return null;
        },
        onSaved: (String? value) {
          // _dadosUsuario.senha = value ?? "";
          _textformValues.put('senha', value);
        },
      ),
    );
  }

  Widget botaoEntrar(String title) {
    return ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            String cpf = _textformValues.get('cpf');
            String senha = _textformValues.get('senha');

            final bloc = DadosUsuarioBloc(context);
            bloc.add(LoginDadosUsuarioEvent(cpf, senha));

            bloc.stream.listen((state) async {
              if (state is LoadedState) {
                // Atualize a lista _items com os dados do estado LoadedState
                Map<String, dynamic>? loginMessage = state.dados;
                showDialogLogin(loginMessage);
              }
            });
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
          "Entrar",
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ));
  }

  void showDialogLogin(loginMessage) async {
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
                loginMessage.containsKey('message')
                    ? loginMessage['message']
                    : loginMessage['error'],
                style: const TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      String cpf = _textformValues.get('cpf');
                      String senha = _textformValues.get('senha');
                      if (loginMessage.containsKey('message')) {
                        if (cpf == '0' && senha == '0') {
                          SavePath.changePath(Routes.admMainPage);
                          Navigator.pushNamed(
                            context,
                            Routes.admMainPage, //define your route name
                          );
                        } else {
                          SavePath.changePath(Routes.mainPage);
                          Navigator.pushNamed(
                            context,
                            Routes.mainPage, //define your route name
                          );
                        }
                      }
                    },
                    child: const Text('Ok'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

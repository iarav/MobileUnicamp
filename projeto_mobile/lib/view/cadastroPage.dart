// ignore: file_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/dadosUsuario.dart';
import '../../model/routes.dart';
import '../bloc/dadosUsuario/dadosUsuario_bloc.dart';
import '../bloc/dadosUsuario/dadosUsuario_event.dart';
import '../bloc/bloc_state.dart';

import 'package:hive/hive.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key, required this.title});

  final String title;

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DadosUsuario _dadosUsuarioCadastro = DadosUsuario();
  StreamSubscription<BlocState>? _blocSubscription;
  final Box _textformValues = Hive.box("textform_values");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(
                fontFamily: 'bright', color: Color(0xFF05173D), fontSize: 24),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "CADASTRO",
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
                      const SizedBox(height: 15),
                      nomeField(),
                      const SizedBox(height: 20),
                      cpfField(),
                      const SizedBox(height: 20),
                      senhaField(),
                      const SizedBox(height: 20),
                      emailField(),
                      const SizedBox(height: 20),
                      telField(),
                      const SizedBox(height: 13),
                      botaoEntrar(widget.title),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget nomeField() {
    return SizedBox(
      width: 250,
      child: TextFormField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Nome',
          labelStyle: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.bold,
          ),
          hintText: 'Digite seu nome completo',
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
            return "Insira o nome completo.";
          }
          return null;
        },
        onSaved: (String? value) {
          _dadosUsuarioCadastro.nome = value ?? "";
        },
      ),
    );
  }

  Widget telField() {
    return SizedBox(
      width: 250,
      child: TextFormField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Telefone',
          labelStyle: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.bold,
          ),
          hintText: 'Digite seu telefone',
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
            return "Insira seu telefone.";
          }
          return null;
        },
        onSaved: (String? value) {
          _dadosUsuarioCadastro.telefone = value ?? "";
        },
      ),
    );
  }

  Widget emailField() {
    return SizedBox(
      width: 250,
      child: TextFormField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'E-mail',
          labelStyle: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.bold,
          ),
          hintText: 'Digite seu email',
          hintStyle: TextStyle(
            color: Colors.grey[400],
          ),
        ),
        validator: (String? value) {
          if (value != null) {
            if (value.isEmpty) {
              return "Campo obrigatório.";
            }
            if (value.contains("@hotmail.com") ||
                value.contains("@gmail.com")) {
            } else {
              return "Formato incorreto. Tente @hotmail.com";
            }
          } else {
            return "Insira o nome completo.";
          }
          return null;
        },
        onSaved: (String? value) {
          _dadosUsuarioCadastro.email = value ?? "";
        },
      ),
    );
  }

  Widget cpfField() {
    return SizedBox(
      width: 250,
      child: TextFormField(
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
          _dadosUsuarioCadastro.cpf = value ?? "";
        },
      ),
    );
  }

  Widget senhaField() {
    return SizedBox(
      width: 250,
      child: TextFormField(
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
            if (value.length < 6) {
              return "Senha deve ter 6 caracteres ou mais.";
            }
          } else {
            return "Insira algum valor.";
          }
          return null;
        },
        onSaved: (String? value) {
          _dadosUsuarioCadastro.senha = value ?? "";
        },
      ),
    );
  }

  Widget botaoEntrar(String title) {
    return ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            final bloc = context.read<DadosUsuarioBloc>();
            _blocSubscription?.cancel();

            String formattedCPF =
                _dadosUsuarioCadastro.cpf.replaceAll(RegExp(r'[^\d]'), '');

            try {
              UserCredential userCredential =
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: '$formattedCPF@cpf.com',
                password: _dadosUsuarioCadastro.senha,
              );

              User? user = userCredential.user;
              if (user != null) {
                bloc.add(InsertDadosUsuarioEvent(_dadosUsuarioCadastro));

                _textformValues.put('cpf', _dadosUsuarioCadastro.cpf);
                _textformValues.put('senha', _dadosUsuarioCadastro.senha);

                bloc.stream.listen((state) async {
                  if (state is LoadedState) {
                    showDialogCadastroEfetuadoComSucesso();
                  }
                });
              } else {
                print('Erro ao criar o usuário.');
              }
            } on FirebaseAuthException catch (e) {
              if (e.code == 'email-already-in-use') {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('CPF já está cadastrado!')));
              } else {
                print('Error creating user: $e');
              }
            } catch (e) {
              print('Error creating user: $e');
            }
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

  void showDialogCadastroEfetuadoComSucesso() async {
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
                'Cadastro efetuado com sucesso! Faça Login.',
                style: TextStyle(
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
                      Navigator.pushNamed(
                        context,
                        Routes.login,
                        arguments: _dadosUsuarioCadastro.cpf,
                      );
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

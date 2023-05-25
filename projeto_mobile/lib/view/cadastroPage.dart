// ignore: file_names
import 'package:flutter/material.dart';

import '../../model/pessoaData.dart';
import '../../model/routes.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key, required this.title});

  final String title;

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PessoaData _pessoaDataCadastro = PessoaData();

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
                      passwordField(),
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
          _pessoaDataCadastro.nome = value ?? "";
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
          _pessoaDataCadastro.tel = value ?? "";
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
          _pessoaDataCadastro.email = value ?? "";
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
          _pessoaDataCadastro.cpf = value ?? "";
        },
      ),
    );
  }

  Widget passwordField() {
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
          } else {
            return "Insira algum valor.";
          }
          return null;
        },
        onSaved: (String? value) {
          _pessoaDataCadastro.password = value ?? "";
        },
      ),
    );
  }

  Widget botaoEntrar(String title) {
    return ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            Navigator.pushNamed(
              context,
              Routes.login,
              arguments: _pessoaDataCadastro.cpf, //define your route name
            );
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
}

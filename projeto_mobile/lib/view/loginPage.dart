// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
  //final PessoaData _pessoaData = PessoaData();
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
                Text("LOGIN",
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
                  passwordField(),
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
          // _pessoaData.cpf = value ?? "";
           _textformValues.put('cpf', value);
        },
      ),
    );
  }

  Widget passwordField() {
    return SizedBox(
      width: 250,
      child: TextFormField(
        initialValue: _textformValues.get('password'),
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
          // _pessoaData.password = value ?? "";
           _textformValues.put('password', value);
        },
      ),
    );
  }

  Widget botaoEntrar(String title) {
    return ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            String cpf = _textformValues.get('cpf');
            String password = _textformValues.get('password');
            // if (_pessoaData.cpf == 'admin' && _pessoaData.password == 'admin') {
              if (cpf == 'admin' && password == 'admin') {
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
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255)),
        ));
  }
}

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:projeto_mobile/bloc/dadosUsuario/dadosUsuario_bloc.dart';
import 'package:projeto_mobile/bloc/dadosUsuario/dadosUsuario_event.dart';
import '../../bloc/bloc_state.dart';
import '../../model/dadosUsuario.dart';
import '../../model/routes.dart';
import '../../model/save_path.dart';
import '../../provider/storage_service.dart';

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({super.key, required this.title});

  final String title;

  @override
  State<EditarPerfil> createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DadosUsuario _dadosUsuarioCadastro = DadosUsuario();
  final Box _textformValues = Hive.box("textform_values");
  TextEditingController nomeController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  final Storage storage = Storage();
  String loggedUserId = "";
  String? imagePath;

  @override
  void initState() {
    super.initState();
    loggedUserId = _textformValues.get('loggedUserId');
    getDadosUsuario(this);
  }

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "EDITAR PERFIL",
                      style: TextStyle(
                        fontFamily: 'bright',
                        color: Color(0xFF05173D),
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    imagePath != null
                        ? imagePath!.contains("firebasestorage")
                            ? Container(
                                width: 150,
                                height: 150,
                                child: ClipOval(
                                  child: Image.network(
                                    imagePath!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: FileImage(File(imagePath!)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                        : CircleAvatar(
                            radius: 75,
                            backgroundColor: Color.fromARGB(255, 78, 78, 78),
                            child: Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete),
                      color: Color.fromARGB(255, 128, 9, 0),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.upload),
                      color: const Color.fromARGB(255, 0, 72, 132),
                      onPressed: () {
                        pickfile(this);
                      },
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
                      telField(),
                      const SizedBox(height: 20),
                      emailField(),
                      const SizedBox(height: 20),
                      senhaField(),
                      const SizedBox(height: 13),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          botaoCancelar(widget.title),
                          const SizedBox(width: 5),
                          botaoSalvar(widget.title),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void pickfile(state) async {
    final myimage = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg'],
    );

    if (myimage == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Nenhuma imagem selecionada!')));
      return;
    }

    final path = myimage.files.single.path;

    state.setState(() {
      imagePath = path;
    });
  }

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
          nomeController.text = _dadosUsuarioCadastro.nome;
          cpfController.text = _dadosUsuarioCadastro.cpf;
          emailController.text = _dadosUsuarioCadastro.email;
          telefoneController.text = _dadosUsuarioCadastro.telefone;
          senhaController.text = _dadosUsuarioCadastro.senha;
          if (_dadosUsuarioCadastro.fotoUrl != "") {
            String? path =
                await storage.getProfileImage(_dadosUsuarioCadastro.fotoUrl);
            if (path != null) {
              stateWidget.setState(() {
                imagePath = path;
              });
            }
          }
        } else {
          showDialogDadosNaoEncontrados();
        }
      }
    });
  }

  Widget nomeField() {
    return SizedBox(
      width: 250,
      child: TextFormField(
        controller: nomeController,
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
        controller: telefoneController,
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
        controller: emailController,
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
        controller: cpfController,
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
        controller: senhaController,
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
          _dadosUsuarioCadastro.senha = value ?? "";
        },
      ),
    );
  }

  Widget botaoSalvar(String title) {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();

          if (imagePath != null) {
            _dadosUsuarioCadastro.fotoUrl = loggedUserId;
            storage
                .uploadFile(imagePath!, loggedUserId)
                .then((value) => print("Imagem Inserida no storage!"));
          }

          final bloc = context.read<DadosUsuarioBloc>();
          bloc.add(
              UpdateDadosUsuarioEvent(loggedUserId, _dadosUsuarioCadastro));
          bloc.stream.listen((state) async {
            if (state is LoadedState) {
              showDialogAtualizacaoRealizada();
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
        "Salvar",
        style: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 15,
          shadows: [
            Shadow(
              blurRadius: 2.0,
              color: Color.fromARGB(255, 24, 24, 24),
              offset: Offset(1.0, 1.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget botaoCancelar(String title) {
    return ElevatedButton(
      onPressed: () {
        SavePath.changePath(Routes.mainPage);
        Navigator.pushNamed(
          context,
          Routes.mainPage,
        );
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 172, 0, 0)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 34.0),
          )),
      child: const Text(
        "Cancelar",
        style: TextStyle(
          fontSize: 15,
          shadows: [
            Shadow(
              blurRadius: 2.0,
              color: Color.fromARGB(255, 24, 24, 24),
              offset: Offset(1.0, 1.0),
            ),
          ],
        ),
      ),
    );
  }

  void showDialogDadosNaoEncontrados() async {
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
                'Ocorreu um erro! Não foi possível buscar os dados.',
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
                        Routes.mainPage,
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

  void showDialogAtualizacaoRealizada() async {
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
                'Perfil atualizado com sucesso!',
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
                        Routes.mainPage,
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

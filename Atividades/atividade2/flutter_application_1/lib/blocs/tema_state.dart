import 'package:flutter/material.dart';

abstract class TemaState{
  Color cor;
  bool foto;
  TemaState({
    required this.cor,
    required this.foto,
  });
}

class TemaInitial extends TemaState{
  TemaInitial() : super(foto: true, cor: const Color.fromARGB(255, 0, 255, 255));
}

class TemaChange extends TemaState{
  TemaChange() : super(foto: false, cor: const Color.fromARGB(255, 72, 0, 187));
}
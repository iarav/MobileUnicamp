// ignore_for_file: file_names
import 'package:flutter/material.dart';

class FazerReserva extends StatefulWidget {
  const FazerReserva({super.key, required this.title});

  final String title;

  @override
  State<FazerReserva> createState() => _FazerReservaState();
}

class _FazerReservaState extends State<FazerReserva> {
  @override
  Widget build(BuildContext context) {
    var item = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Text('This is the detail page for $item'),
      ),
    );
  }
}

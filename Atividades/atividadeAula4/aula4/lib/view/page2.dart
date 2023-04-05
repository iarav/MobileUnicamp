import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../model/complete_data.dart';

class Pagina2 extends StatefulWidget {
  const Pagina2({super.key});

  @override
  State<Pagina2> createState() => _Pagina2State();
}

class _Pagina2State extends State<Pagina2> {

  final CompleteModel completeModel = CompleteModel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        myCheckBox(),
        mySwitch(),
        mySlider(),
        const Divider(
          thickness: 3,
        ),
        const Text("Radios 1:"),
        myRadio(1),
        myRadio(2),
        myRadio(3),
        const Divider(
          thickness: 3,
        ),
        const Text("Radios 2:"),
        myRadio2(1),
        myRadio2(2),
        myRadio2(3),
        //myButton(),
        outroButton(),
      ],
    );
  }

  Widget myCheckBox(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: completeModel.checkboxValue, 
          onChanged: (bool? value){
            if(value != null){
              setState(() {
                completeModel.checkboxValue = value;
              });
            }
          }),
        const Text("Aceitar"),
      ],
    );
  }

   Widget mySwitch(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Switch(
          value: completeModel.switchValue, 
          onChanged: (bool? value){
            if(value != null){
              setState(() {
                completeModel.switchValue = value;
              });
            }
          }),
        const Text("Som"),
      ],
    );
  }

  Widget mySlider(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Volume: "),
        Slider(
          min: 0,
          max: 100,
          value: completeModel.sliderValue, 
          onChanged: (double value){
            setState(() {
              completeModel.sliderValue = value;
            });
          }),
        Text("${completeModel.sliderValue.toStringAsPrecision(4)} %"),  
      ],
    );
  }

  Widget myRadio(int value){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio(
          value: value, 
          groupValue: completeModel.radioValue,
          onChanged: (int? groupValue){ //Esse value se refere ao group value
            setState(() {
              completeModel.radioValue = groupValue ?? 1;
            });
          }),
        Text("$value"),
      ],
    );
  }

  Widget myRadio2(int value){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio(
          value: value, 
          groupValue: completeModel.radioValue2,
          onChanged: (int? groupValue){ //Esse value se refere ao group value
            setState(() {
              completeModel.radioValue2 = groupValue ?? 1;
            });
          }),
        Text("$value"),
      ],
    );
  }

  Widget myButton(){
    return ElevatedButton(
      onPressed: (){
        ScaffoldMessenger.of(context).showSnackBar(mySnackBar());
      }, 
      child: const Text("Call Iara")
    );
  }

   Widget outroButton(){
    return ElevatedButton(
      onPressed: (){
        showBottomSheet(
          context: context, 
          builder: (contex){
            return Container(
              height: 200,
              color: Colors.pink,
              child: Row(
                children: [
                  const Text("Teste"),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                     child: const Text("Até Mais!"))
                ],
              ),
            );
          });
      }, 
      child: const Text("Call outro button")
    );
  }

  SnackBar mySnackBar(){
    return SnackBar(
      backgroundColor: const Color.fromARGB(255, 1, 1, 94),
      duration: const Duration(seconds: 5),
      content: const Text("Iara"),
      action: SnackBarAction(label: 'Voltar', onPressed: (){}),
      );
  }
}
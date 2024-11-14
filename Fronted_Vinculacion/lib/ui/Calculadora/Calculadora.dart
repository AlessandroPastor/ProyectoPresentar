import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vinculacion/comp/CalcButton.dart';
import 'package:vinculacion/comp/CustomAppBar.dart';
import 'package:vinculacion/theme/AppTheme.dart';


class CalcApp extends StatefulWidget {
  const CalcApp({super.key});
  @override
  CalcAppState createState() => CalcAppState();
}

class CalcAppState extends State<CalcApp> {
  String valorAnt = '';
  String operador = '';
  TextEditingController _controller = TextEditingController();

  void numClick(String text) {
    setState(() => _controller.text += text);
    print(_controller);
  }

  void clear(String text) {
    setState(() {
      _controller.text = '';
    });
  }

  void opeClick(String text) {
    setState(() {
      valorAnt = _controller.text;
      operador = text;
      _controller.text = '';
    });
  }

  void accion() {
    setState(() {
      print("");
    });
  }


  void resultOperacion(String text) {
    setState(() {
      double result;
      switch (operador) {
        case "/":
          result = double.parse(valorAnt) / double.parse(_controller.text);
          break;
        case "*":
          result = double.parse(valorAnt) * double.parse(_controller.text);
          break;
        case "+":
          result = double.parse(valorAnt) + double.parse(_controller.text);
          break;
        case "-":
          result = double.parse(valorAnt) - double.parse(_controller.text);
          break;
        case "%":
          result = double.parse(valorAnt) % double.parse(_controller.text);
          break;
        case "√":
          result = sqrt(double.parse(_controller.text));
          break;
        case "^2":
          result = pow(double.parse(_controller.text), 2).toDouble();
          break;
        case "^":
          result = pow(double.parse(valorAnt), double.parse(_controller.text)).toDouble();
          break;
        case "π":
          result = pi;
          break;
        default:
          result = 0;
      }

      // Convertir el resultado a int si no tiene decimales
      _controller.text = (result % 1 == 0 ? result.toInt() : result).toString();
    });
  }



  @override
  Widget build(BuildContext context) {
    AppTheme.colorX = Colors.blue;
    List<List> labelList = [
      ["AC", "C", "%", "/"],
      ["7", "8", "9", "*"],
      ["4", "5", "6", "-"],
      ["1", "2", "3", "+"],
      ["√", "^2", "^", "π"],
      [".", "0", "00", "="]
    ];
    List<List> funx = [
      [clear, clear, opeClick, opeClick],
      [numClick, numClick, numClick, opeClick],
      [numClick, numClick, numClick, opeClick],
      [numClick, numClick, numClick, opeClick],
      [opeClick, opeClick, opeClick, opeClick],
      [numClick, numClick, numClick, resultOperacion]
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      themeMode: AppTheme.useLightMode ? ThemeMode.light : ThemeMode.dark,
      theme: AppTheme.themeData,
      home: Scaffold(
        appBar: CustomAppBar(accionx: accion as Function),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  textAlign: TextAlign.end,
                  controller: _controller,
                ),
              ),
              SizedBox(height: 20),
              ...List.generate(
                labelList.length,
                    (index) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ...List.generate(
                      labelList[index].length,
                          (indexx) => CalcButton(
                        text: labelList[index][indexx],
                        callback: funx[index][indexx] as Function,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
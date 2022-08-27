// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_tts/flutter_tts_web.dart';

final _firstTextField = TextEditingController();
final _secondTextField = TextEditingController();
FlutterTts ftts = FlutterTts();

List<String> typeConvertion = ["Celsius", "Farehehe", "Kelvin"];

var _firstSelection = typeConvertion.toList()[0];
var _secondSelection = typeConvertion.toList()[1];

celsiusToKelvin(double temp) {
  return temp + 273.15;
}

kelvinToCelcius(double temp) {
  return temp - 273.15;
}

fahrenheitToCelsius(double temp) {
  return (temp - 32) * (5 / 9);
}

celsiusToFahrenheit(double temp) {
  return (temp * (9 / 5) + 32);
}

List<List<Function>> matrixConvertion = [
  [(e) => e, celsiusToFahrenheit, celsiusToKelvin],
  [
    fahrenheitToCelsius,
    (e) => e,
    (e) => celsiusToKelvin(fahrenheitToCelsius(e))
  ],
  [kelvinToCelcius, (e) => celsiusToFahrenheit(kelvinToCelcius(e)), (e) => e]
];
onChangeTextTemp() async {
  if (_firstTextField.text.isEmpty) {
    return null;
  }
  var result = await ftts.stop();
  await ftts.setLanguage("pt-BR");
  double fromTemp = double.parse(_firstTextField.text);
  int fromType = typeConvertion.indexOf(_firstSelection);
  int toType = typeConvertion.indexOf(_secondSelection);
  double toTemp = matrixConvertion[fromType][toType](fromTemp);
  _secondTextField.text = toTemp.toString();
  var cu = TtsState.stopped;
}

class ConvertionTemp extends StatefulWidget {
  const ConvertionTemp({Key? key}) : super(key: key);
  @override
  State<ConvertionTemp> createState() => _ConvertionTempState();
}

FloatingActionButton floating(context) {
  return FloatingActionButton(
      child: const Icon(Icons.volume_up),
      onPressed: () async {
        var result = await ftts.stop();
        if (_firstTextField.text.isNotEmpty) {
          double fromTemp = double.parse(_firstTextField.text);
          double toTemp = double.parse(_secondTextField.text);
          if (result == 1) {
            await ftts.speak(
                "$fromTemp em $_firstSelection 'é' $toTemp em $_secondSelection");
          }
        }
      });
}

class _ConvertionTempState extends State<ConvertionTemp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          ListTile(
            title: TextField(
                decoration: const InputDecoration(hintText: "0"),
                keyboardType: TextInputType.number,
                controller: _firstTextField,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  // FilteringTextInputFormatter.deny(RegExp(r'^0.'))
                ],
                onChanged: (value) {
                  if (RegExp(r"^0.").hasMatch(value)) {
                    _firstTextField
                      ..text = value.replaceFirst(RegExp(r'^0+'), "")
                      ..selection = const TextSelection.collapsed(offset: 1);
                  }
                  onChangeTextTemp();
                }),
            trailing: DropdownButton(
              value: _firstSelection,
              items: typeConvertion
                  .map((e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: ((value) {
                setState(() {
                  _firstSelection = value.toString();
                  onChangeTextTemp();
                });
              }),
            ),
          ),
          ListTile(
            title: TextField(
              enabled: false,
              controller: _secondTextField,
              decoration: const InputDecoration(hintText: "0"),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.deny(RegExp(r'^0+'))
              ],
              onChanged: (value) => onChangeTextTemp(),
            ),
            trailing: DropdownButton(
              value: _secondSelection,
              items: typeConvertion
                  .map((e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: ((value) {
                setState(() {
                  _secondSelection = value.toString();
                  onChangeTextTemp();
                });
              }),
            ),
          ),
          Card(
            color: Colors.blue,
            child: ListTile(
              title: const Text(
                "Trocar",
                style: TextStyle(color: Colors.white),
              ),
              leading: const Icon(
                Icons.swap_vert,
                color: Colors.white,
              ),
              onTap: () {
                setState(() {
                  var aux = _firstSelection;
                  _firstSelection = _secondSelection;
                  _secondSelection = aux;
                  onChangeTextTemp();
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

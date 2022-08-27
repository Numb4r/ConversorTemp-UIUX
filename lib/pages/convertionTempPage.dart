// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final _firstTextField = TextEditingController();
final _secondTextField = TextEditingController();

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
onChangeTextTemp() {
  if (_firstTextField.text.isEmpty) {
    return null;
  }
  double toTemp;
  double fromTemp;
  int fromType;
  int toType;

  fromTemp = double.parse(_firstTextField.text);
  fromType = typeConvertion.indexOf(_firstSelection);
  toType = typeConvertion.indexOf(_secondSelection);

  toTemp = matrixConvertion[fromType][toType](fromTemp);

  _secondTextField.text = toTemp.toString();
}

class ConvertionTemp extends StatefulWidget {
  const ConvertionTemp({Key? key}) : super(key: key);

  @override
  State<ConvertionTemp> createState() => _ConvertionTempState();
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

import 'dart:collection';

import 'package:baseconvert/baseconvert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'columns.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Excel Index Finder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: MyHomePage(title: 'Excel Index Finder'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _lettersController = TextEditingController();
  TextEditingController _numbersController = TextEditingController();

  Columns cols = Columns();

  void _onChangedLetters(String text) {
    text = text.toLowerCase();
    var x = cols.entries.keys
        .firstWhere((k) => cols.entries[k] == text, orElse: () => null);
    if (x != null) {
      _numbersController.text = x.toString();
    } else {
      _numbersController.text = "";
    }
  }

  void _onChangedNumbers(String text) {
    int number = -1;
    try {
      number = int.parse(text);
      if (number < 1 || number > 18278) {
        _lettersController.text = "Number too small or too large";
      } else {
        var value = cols.entries[number];
        _lettersController.text = value;
      }
    } catch (Exception) {
      _lettersController.text = "Unsupported Number";
    }
  }

  void _onTapNumbers() {
    _numbersController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _numbersController.text.length,
    );
  }

  void _onTapLetters() {
    _lettersController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _lettersController.text.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Center(
                child: Text(
                  'How to use',
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Center(
                child: Text(
                  'Enter column letters from Excel here:',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: TextField(
                onChanged: _onChangedLetters,
                onTap: _onTapLetters,
                controller: _lettersController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(hintText: "ABC"),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                  LengthLimitingTextInputFormatter(3)
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Center(
                child: Text(
                  'Or enter a column index here:',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: TextField(
                onChanged: _onChangedNumbers,
                onTap: _onTapNumbers,
                controller: _numbersController,
                keyboardType: TextInputType.number,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(hintText: "731"),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Center(
                child: Text(
                  'And look at the other text field to see your result.',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

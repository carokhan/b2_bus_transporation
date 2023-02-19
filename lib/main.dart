//import 'dart:js_util';

import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:nfc_manager/nfc_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edulog Student App',
      theme: ThemeData(
        //theme colors
        primarySwatch: Colors.teal,
      ),
      home: const MyHomePage(title: 'Edulog Student App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title; //App title

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool _isRunning = false;
  IconData _display = Icons.sensors;
  Color _color = Colors.black;
  String _message = "Press to scan";
  String _error = "";

  //Dummy function to be replaced by NFC code
  Future<bool> _testNFC() async {
    NfcManager.instance.stopSession();
    Completer completer = new Completer();
    if (!(await NfcManager.instance.isAvailable())) return Future.value(false);
    await NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      completer.complete(Future.value(true));
    }, onError: (NfcError error) async {
      setState(() {
        _error = error.toString();
      });
      completer.complete(Future.value(false));
    }).then(
      (value) {
        NfcManager.instance.stopSession();
      },
    );
    return _testNFC();
  }

  //Button animations
  void _run() async {
    if (!_isRunning) {
      //stop repeat calls before everything has processed
      _isRunning = true;
      setState(() {
        //wait symbol
        _display = Icons.hourglass_empty;
        _message = "";
      });
      if (await _testNFC().timeout(Duration(seconds: 5),
          onTimeout: () => Future.value(false))) {
        //await bool return from NFC and evaluate
        setState(() {
          //NFC Success
          _display = Icons.check;
          _color = Colors.green;
          _message = "Success!";
        });
      } else {
        setState(() {
          //NFC Error
          _display = Icons.dangerous;
          _color = Colors.red;
          _message = "An error occurred, please try again.";
        });
      }
      Future.delayed(const Duration(milliseconds: 2000), () {
        setState(() {
          _display = Icons.sensors;
          _color = Colors.black;
          _message = "Press to scan";
        });
        _isRunning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    return Scaffold(
      appBar: AppBar(
        //Top Bar of the app
        leading: IconButton(
          //menyu button
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20),
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
        title: Text(widget.title), //App title
      ),
      body: Center(
        //center Horozontaly
        child: Column(
          //stack stuff in column
          mainAxisAlignment:
              MainAxisAlignment.center, //align in center of column
          children: <Widget>[
            IconButton(
              //Run nfc stuff button
              onPressed: _run,
              icon: Icon(_display), //changable icon
              iconSize: 140,
              color: _color,
            ),
            Text(
              // message underneath button
              textAlign: TextAlign.center,
              _message,
              style:
                  Theme.of(context).textTheme.headlineMedium, //changable text
            ),
            Text(_error)
          ],
        ),
      ),
    );
  }
}

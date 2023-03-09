//import 'dart:js_util';

import 'dart:async';

import 'package:flutter/material.dart';
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
  bool _isRunning = false;
  IconData _nfcIconDesplay = Icons.sensors;
  Color _nfcIconColor = Colors.black;
  String _nfcMessage = "Press to scan";
  String _error = ""; //for debug only
  String _loginTooltip = "Login";
  IconData _loginIcon = Icons.login;

  //NFC code
  Future<bool> _testNFC() async {
    NfcManager.instance.stopSession();
    Completer completer = new Completer();
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
        _nfcIconDesplay = Icons.hourglass_empty;
        _nfcMessage = "";
      });
      if (!await NfcManager.instance.isAvailable()) {
        setState(() {
          //No NFC compatibility
          _nfcIconDesplay = Icons.sensors_off;
          _nfcIconColor = Colors.red;
          _nfcMessage = "Error accessing NFC systems.";
        });
      } else if (await _testNFC().timeout(const Duration(seconds: 5),
          onTimeout: () => Future.value(false))) {
        //await bool return from NFC and evaluate
        setState(() {
          //NFC Success
          _nfcIconDesplay = Icons.check;
          _nfcIconColor = Colors.green;
          _nfcMessage = "Success!";
        });
      } else {
        setState(() {
          //NFC Error
          _nfcIconDesplay = Icons.dangerous;
          _nfcIconColor = Colors.red;
          _nfcMessage = "An error occurred, please try again.";
        });
      }
      Future.delayed(const Duration(milliseconds: 2000), () {
        setState(() {
          _nfcIconDesplay = Icons.sensors;
          _nfcIconColor = Colors.black;
          _nfcMessage = "Press to scan";
        });
        _isRunning = false;
      });
    }
  }

  // replace with login function that returns true for successful login or false otherwise
  Future<bool> _runLogin() {
    return Future.value(true);
  }

  //login function
  void _login() async {
    if (_loginIcon == Icons.login) {
      //replace with a better login check after login systems are implemented
      if (await _runLogin()) {
        _loginTooltip = "Logout";
        _loginIcon = Icons.logout;
        setState(() {});
      }
    } else {
      _loginTooltip = "Login";
      _loginIcon = Icons.login;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    return Scaffold(
      appBar: AppBar(
        //Top Bar of the app
        leading: IconButton(
          //menu button
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20),
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: _login,
          icon: Icon(_loginIcon),
          tooltip: _loginTooltip,
        ),
        title: Text(widget.title), //App title
      ),
      body: Center(
        //center horozontaly
        child: Column(
          //stack stuff in column
          mainAxisAlignment:
              MainAxisAlignment.center, //align in center of column
          children: <Widget>[
            IconButton(
              //Run nfc stuff button
              onPressed: _run,
              icon: Icon(_nfcIconDesplay), //changable icon
              iconSize: 140,
              color: _nfcIconColor,
            ),
            Text(
              // message underneath button
              textAlign: TextAlign.center,
              _nfcMessage,
              style:
                  Theme.of(context).textTheme.headlineMedium, //changable text
            ),
            Text(
              _error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            )
          ],
        ),
      ),
    );
  }
}
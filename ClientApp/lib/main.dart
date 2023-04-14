//import 'dart:js_util';

import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:ndef/ndef.dart' as ndef;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edulog Student App', //App Title
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
  //initalise necessary global varables
  bool _isRunning = false;
  IconData _nfcIconDesplay = Icons.sensors;
  Color _nfcIconColor = Colors.black;
  String _nfcMessage = "Press to scan";
  String _loginTooltip = "Login";
  IconData _loginIcon = Icons.login;

  //NFC code

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
      var availability = await FlutterNfcKit.nfcAvailability;
      if (availability != NFCAvailability.available) {
        //Is NFC Available?
        setState(() {
          //No NFC compatibility
          _nfcIconDesplay = Icons.sensors_off;
          _nfcIconColor = Colors.red;
          _nfcMessage = "Error accessing NFC systems.";
        });
        Future.delayed(const Duration(milliseconds: 2000), () {
          //reset to default state
          setState(() {
            _nfcIconDesplay = Icons.sensors;
            _nfcIconColor = Colors.black;
            _nfcMessage = "Press to scan";
          });
          _isRunning = false;
          return;
        });
      }
      setState(() {
        _nfcMessage = "Scanning...";
      });
      //Start NFC Connection
      var tag = await FlutterNfcKit.poll(
              timeout: Duration(seconds: 20),
              androidPlatformSound: true,
              androidCheckNDEF: true,
              iosAlertMessage: "Hold your phone close to the tablet",
              iosMultipleTagMessage: "Please try again",
              readIso14443A: true,
              readIso14443B: true,
              readIso15693: true,
              readIso18092: true)
          .then(
        (returned) {},
      );
      setState(() {
        //NFC Success visual
        _nfcIconDesplay = Icons.check;
        _nfcIconColor = Colors.green;
        _nfcMessage = tag.toString();
      });
      Future.delayed(const Duration(milliseconds: 2000), () {
        setState(() {
          //Reset visual
          _nfcIconDesplay = Icons.sensors;
          _nfcIconColor = Colors.black;
          _nfcMessage = "Press to scan";
        });
        _isRunning = false;
      });
    }
  }

  // replace with login function that returns true for successful login or false otherwise

  //login function
  void _login() async {
    if (_loginIcon == Icons.login) {
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      bool _isLoggedIn = false;
      //late GoogleSignInAccount _userObj;
      try {
        await _googleSignIn.signIn().then((userData) {
          //Login Success
          print("THEN!!! " + userData.toString());
          setState(() {
            //change login button symbol
            _loginTooltip = "Logout";
            _loginIcon = Icons.logout;
          });
        }).catchError((e) {
          print("ERROR!!!!! " + e.toString());
        });
      } catch (e) {
        print("ERR!!!" + e.toString());
      }
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
          ],
        ),
      ),
    );
  }
}

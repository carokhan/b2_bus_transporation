// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
//Importing NFC packages
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

//
//Code that is run when the program is initally ran
//
//
void main() {
  runApp(const MyApp());
}

//
//Sets up the home page with a theme, title, and body; the body is the _myHomePageState class
//
//As a general rule of thumb this class likely does not need to be changed
//
//
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //Anytime you want a page to contain any widgets you need to have an overriden build() method that returns a Widget object and takes BuildContext as an argument
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NFC reader',
      theme: ThemeData(
        //Sets the primary swatch color to blue meaning all widgets will take their main theme color to be this
        primarySwatch: Colors.blue,
      ),
      //This is the homepage, or what will open when the code is run, the title is an argument plugging into the text in the appbar at the top left of the page
      home: const MyHomePage(title: 'NFC Reader'),
    );
  }
}

//
//Builds the page state
//
//Allows whatever class that is called from createState() to run the setState() method which is used to update stateful widgets
//Stateful widgets are any widgets that can be changed over time like updating text
//As a general rule of thumb this class should not be changed, however if you want to have multiple pages you will need multiple of these classes
//
//
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

//
//This is the class that should be changed to represent which widgets are on the screen and how they are displayed
//Any widgets placed within this class are binded to this page and if you implement multiple pages, the other page will not contain these widgets
//The "setState(() {})" method can be called to update any widgets that take data from variables, must be called to update UI after variables have been updated
//Because a state was defined for this class earlier, we can call the "setState(() {})" method either by putting any variable changes inside its brackets or after any variables are changed to update widgets
//
//
class _MyHomePageState extends State<MyHomePage> {
  //Defining variable that is binded to widgets display
  //Must call "setState(() {})" when changing this variable to update the widgets text
  String data = "No NFC Data";

  //
  //This method will scan for other nearby NFC devies
  //This method has detected devices before
  //
  //
  void readNfc() async {
    while (true) {
      //first check if NFC connectivity is possible on the device
      var availability = await FlutterNfcKit.nfcAvailability;
      if (availability != NFCAvailability.available) {
        //Runs if NFC is not avaiable, this can occur if either NFC is disabled in settings or NFC is not possible at all on the device
        data = "An error occured";
        setState(() {});
      }
      //poll() method scans for other NFC tags
      var tag = await FlutterNfcKit.poll(
          //Sets arguments for neatness
          //please note the timeout argument does nothing
          timeout: Duration(seconds: 10),
          iosMultipleTagMessage: "Multiple tags found!",
          iosAlertMessage: "Scan your tag");
      
      //
      //Prototype code: not sure if it works as intended or if it does anything at all
      //
      /*if (tag.type == NFCTagType.iso7816) {
        var result = await FlutterNfcKit.transceive("00B0950000",
            timeout: Duration(
                seconds:
                    5)); // timeout is still Android-only, persist until next change
        setState(() {
          data = result;
        });
      }*/
      //
      //Runs when a tag is found
      //
      if (tag.ndefAvailable!) {
        //Reads all records assigned to a certain tag
        for (var record in await FlutterNfcKit.readNDEFRecords(cached: false)) {
          //Please note: This code will set the "data" variable to the payload of the last record, because of this, this code will not work as intended for multi record reads
          setState(() {
            data = record.toString();
          });
        }
      }
      //Call to end the NFC scan and kill any active connections
      await FlutterNfcKit.finish();
    }
  }


  //
  //Placement for widgets on the page
  //
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: readNfc,
              child: Text(data),
            ),
            Text("Hi")
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

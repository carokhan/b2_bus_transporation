# Serial Port Communication In Flutter

### Introduction
Reading and writing through the serial port is essential for communication of a string or key through the recipient application. The essential code for serial port communication will be disclosed here. Preferably, this code should be done in Visual Studio.

This documentation will cover the creation of the code in a step by step process. To see all of the code, scroll to the bottom of this document.

### Code
Firstly, we must be able to check for all available ports. To do so, you must import the following packages and provide a list of all available ports in the terminal, which is what the following code will do.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    //Will provide all available ports to connect to
    List<String> availablePort = SerialPort.availablePorts
    

    print(‘Available Ports: $availablePort‘)


    Return Container();
  }
}
```

Afterwards, go the the terminal in Visual Studio and enter the following: `flutter run -d windows`

This will provide you the all available ports. Remember the name of the code required and save it as an object. For example, if the port you require is “PORT2”, include the following line of code: 

```dart
print(‘Available Ports: $availablePort‘)

SerialPort port1 = SerialPort(‘PORT2’); // specifies the port being used

    Return Container();
  }
}
```

Afterwards, we will use try catch in order to account for serial port errors. This will also help check if the serial port communication was successful. We will also include code that opens the port to receive information. Remember to add the code at the bottom of this example to convert the string into a usable way, being “Uint8List”.

```dart
SerialPort port1 = SerialPort(‘PORT2’);

/*
Opens the port and writes 'Hello' (upon being converted into a list of uint8s) to the port.
*/
port1.openReadWrite();

try {
  //write to port
  print(‘Written Bytes: ${port1.write(_stringToUint8List(‘Hello’))}’);
}on SerialPortError catch (err_) {
  print(SerialPort.lastError);
  port1.close();
}


    Return Container();
  }
}

// Converts the string to the uint8 list for transmittion through serial.
Uint8List _stringToUint8List(String data {
  List<int> codeUnits = data.codeUnits;
  Unit8List uint8list = Uint8List.fromList(codeUnits;
  return uint8list; 
}
```

After running run `flutter run -d windows` again in the terminal, flutter should tell you how many bites have been written. Using ‘Hello’, the terminal should return 5.

We now must read from the selected port. To do so, return to the try statement and include the following code. It will allow is to read the stream of data passed to the port, and then it will convert each element into the string.

```dart
try {
   //write to port
  print(‘Written Bytes: ${port1.write(_stringToUint8List(‘Hello’))}’);

  // Reads from port
  SerialPortReader reader = SerialPortReader(port1);
  Stream<String> upcomingData = reader.stream.map((data) {
    return String.fromCharCodes(data);
  });

  upcomingData.listen((data) { 
    print(‘Data/String Read: $data’);
  });

}on SerialPortError catch (err_) {
  print(SerialPort.lastError);
  port1.close();
}
```

Afterwards, return to the terminal and enter flutter run -d windows. And we are now done; you have successfully written and read data through a serial port! 🎊

Needed changes, like different port or string to pass, will be easy to implement using the incremental documentation of this code!

Here is the comprehensive version of this code:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    //Will provide all available ports to connect to
    List<String> availablePort = SerialPort.availablePorts
    

    print(‘Available Ports: $availablePort‘)
    SerialPort port1 = SerialPort(‘PORT2’);
    port1.openReadWrite();

    try {
      //write to port
      print(‘Written Bytes: ${port1.write(_stringToUint8List(‘Hello’))}’);

      //read from port
     SerialPortReader reader = SerialPortReader(port1);
     Stream<String> upcomingData = reader.stream.map((data) {
       return String.fromCharCodes(data);
     });

      upcomingData.listen((data) { 
        print(‘Data/String Read: $data’);
      });

    } on SerialPortError catch (err_) {
      print(SerialPort.lastError);
      port1.close();
    }
    
    Return Container();
  }
}

Uint8List _stringToUint8List(String data {
  List<int> codeUnits = data.codeUnits;
  Unit8List uint8list = Uint8List.fromList(codeUnits;
  return uint8list; 
}
```

Use `flutter run -d windows` to properly test this code as needed!


// import 'package:flutter/material.dart';
// import 'package:flutter_boiler_plate/managers/socket_manager.dart';
// import 'package:flutter_boiler_plate/managers/storage_manager.dart';
// import 'package:flutter_boiler_plate/pages/home.dart';
// import 'package:provider/provider.dart';



// void main() {
//   // Initialize the HID listener
  
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider<SocketManager>(
//             create: (context) => SocketManager()),
//         ChangeNotifierProvider<StorageManager>(
//             create: (context) => StorageManager()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       Provider.of<SocketManager>(context, listen: false).setStorageManager(
//           Provider.of<StorageManager>(context, listen: false));
//     });
//     return MaterialApp(
//       home: const HomeScreen(),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hid_listener/hid_listener.dart';

void listener(RawKeyEvent event) {
  print(
      "${event is RawKeyDownEvent} ${event.logicalKey.debugName} ${event.isShiftPressed} ${event.isAltPressed} ${event.isControlPressed}");
}

void mouseListener(MouseEvent event) {
  print("${event}");
}

var registerResult = "";

void main() {
  if (!getListenerBackend()!.initialize()) {
    print("Failed to initialize listener backend");
  }

  getListenerBackend()!.addKeyboardListener(listener);
  // getListenerBackend()!.addMouseListener(mouseListener);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text(registerResult),
        ),
      ),
    );
  }
}
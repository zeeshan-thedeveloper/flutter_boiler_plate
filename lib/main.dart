import 'package:flutter/material.dart';
import 'package:flutter_boiler_plate/managers/socket_manager.dart';
import 'package:flutter_boiler_plate/managers/storage_manager.dart';
import 'package:flutter_boiler_plate/pages/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SocketManager>(
            create: (context) => SocketManager()),
        ChangeNotifierProvider<StorageManager>(
            create: (context) => StorageManager()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<SocketManager>(context, listen: false).setStorageManager(
          Provider.of<StorageManager>(context, listen: false));
    });
    return MaterialApp(
      home: const HomeScreen(),
    );
  }
}

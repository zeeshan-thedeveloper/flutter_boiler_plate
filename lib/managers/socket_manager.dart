import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_boiler_plate/managers/storage_manager.dart';
import 'package:flutter_boiler_plate/utils/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketManager extends ChangeNotifier {
  late IO.Socket socket;
  late StorageManager storageManager;
  Timer? _dataFetchTimer;

  SocketManager() {
    socket = IO.io('${Constants.baseUrl}', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
   
  }

  void setStorageManager(StorageManager storageManager) {
    this.storageManager = storageManager;
  }

  void connect() {
    if (!socket.connected) {
      socket.connect();
      setUpListeners();
      startDataFetchTimer();
      notifyListeners();
    }
  }

  void disconnect() {
    socket.disconnect();
    notifyListeners();
  }

  void emitEvent(String event, dynamic payload) {
    socket.emit(event, payload);
    notifyListeners();
  }

  void setUpListeners() {
    socket.on('reset_project_time_stamps', (data) {
      // print('Received reset_projects event');
      storageManager.resetProjectData(); // Reset project data in storageManager
    });
  }

  void disconnectSocket() {
    socket.disconnect();
    notifyListeners();
  }

  void startDataFetchTimer() {
    _dataFetchTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      // Fetch project data and emit events
      _fetchAndEmitProjectData();
    });
  }

  void _fetchAndEmitProjectData() async {
    if (storageManager == null) {
      return;
    }

    var userData = storageManager.getUserData;

    if (userData == null) {
      return;
    }

    var userId = userData["_id"];
    var parentId = userData["parentUser"];

    var projectData = storageManager.getAllProjectsTime();

    var dataWithTimestampAndUserId = Map<String, dynamic>.from(projectData)
      ..['createdAt'] = DateTime.now().toIso8601String()
      ..['userId'] = userId
      ..['parentId'] = parentId;

    // print(dataWithTimestampAndUserId);

    emitEvent('projectData', dataWithTimestampAndUserId);
  }

  Future<dynamic> _getProjectData() async {
    // Fetch project data from storageManager
    var projectData = storageManager
        .getAllProjectsTime(); // Replace with actual storageManager method
    return projectData;
  }

  @override
  void dispose() {
    _dataFetchTimer?.cancel();
    super.dispose();
  }
}

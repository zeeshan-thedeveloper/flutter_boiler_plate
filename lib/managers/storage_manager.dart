import 'package:flutter/material.dart';
import 'package:flutter_boiler_plate/pages/dashboard/dashboard_body.dart';

class StorageManager extends ChangeNotifier {
  dynamic storedUserData = {};
  Map<String, int> projectTimes = {};
  List<Project> listOfProjects = []; // List to store projects
  Project? currentProjectUnderWork; // Current project under work

  void storeData(dynamic userData) {
    storedUserData = userData;
    notifyListeners();
  }

  dynamic get getUserData => storedUserData;
  void updateProjectTime(String projectName, int seconds) {
    if (storedUserData == null) {
      return;
    } else {
      projectTimes[projectName] = seconds;
      notifyListeners();
    }
  }

  int getProjectTime(String projectName) {
    return projectTimes[projectName] ?? 0;
  }

  Map<String, int> getAllProjectsTime() {
    return projectTimes;
  }

  void resetProjectData() {
    projectTimes = {}; // Reset the projectTimes map to an empty map
    notifyListeners();
  }

  // Method to update the list of projects
  void updateListOfProjects(List<Project> projects) {
    listOfProjects = projects;
    notifyListeners();
  }

  // Method to set the current project under work
  void setCurrentProjectUnderWork(Project project) {
    currentProjectUnderWork = project;
    notifyListeners();
  }

  Project? getCurrentProjectUnderWork() {
    return currentProjectUnderWork;
  }
}

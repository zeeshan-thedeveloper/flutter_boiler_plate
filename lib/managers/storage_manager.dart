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
    print('updating $projectName with $seconds');
    if (storedUserData == null) {
      return;
    } else {
      projectTimes[projectName] = seconds;
      notifyListeners();
    }
  }

  String formatTime(int timeInSeconds) {
    int hours = timeInSeconds ~/ 3600;
    int minutes = (timeInSeconds % 3600) ~/ 60;
    int seconds = timeInSeconds % 60;

    String formattedTime =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return formattedTime;
  }

  List<Map<String, dynamic>> getProjectsAsMapList() {
    List<Map<String, dynamic>> projectsMapList = [];

    for (Project project in listOfProjects) {
      int timeSpentInSeconds = projectTimes[project.id] ??
          0; // Fetch time spent from projectTimes using project id

      Map<String, dynamic> projectMap = {
        'id': project.id,
        'title': project.title,
        'isWorking': project.isWorking,
        'time_spent': formatTime(
            timeSpentInSeconds), // time_spent field from projectTimes
        // Add other properties as needed
      };
      projectsMapList.add(projectMap);
    }

    return projectsMapList;
  }

  int getProjectTime(String projectName) {
    return projectTimes[projectName] ?? 0;
  }

  List<Project> get getListOfProjects => listOfProjects;

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

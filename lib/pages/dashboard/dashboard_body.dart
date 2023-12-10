import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_boiler_plate/apis/api_manager.dart';
import 'package:flutter_boiler_plate/managers/storage_manager.dart';
import 'package:flutter_boiler_plate/utils/app_styles.dart';
import 'package:provider/provider.dart';

class Project {
  final String id;
  final String title;
  bool isWorking; // New property to track project status

  Project({
    required this.id,
    required this.title,
    this.isWorking = false, // Default value for isWorking
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['_id'],
      title: json['projectName'],
    );
  }
}

class DashboardBody extends StatefulWidget {
  const DashboardBody({Key? key}) : super(key: key);

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  late StorageManager storageManager;
  List<Map<String, dynamic>> projects = [];
  bool _isFetchProjectsCalled =
      false; // Flag to track if _fetchProjects is called
  String? _currentProjectTitle; // Track the current project title

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    storageManager = Provider.of<StorageManager>(context);
    if (!_isFetchProjectsCalled) {
      _fetchProjects();
      getProjectsTimeSpentAlready();
      _isFetchProjectsCalled = true;
    }
    // projects = storageManager.getProjectsAsMapList();
  }

  Future<void> _fetchProjects() async {
    try {
      final List<Map<String, dynamic>> fetchedProjects =
          await _getProjectsList();
      setState(() {
        projects = fetchedProjects;
      });

      List<Project> projectObjects = fetchedProjects
          .map((projectMap) => Project.fromJson(projectMap))
          .toList();

      storageManager.updateListOfProjects(projectObjects);
      if (projectObjects.isNotEmpty) {
        storageManager.setCurrentProjectUnderWork(projectObjects.first);
      }
    } catch (error) {
      // Handle errors
    }
  }

  Future<List<Map<String, dynamic>>> _getProjectsList() async {
    try {
      var userParentId = storageManager.getUserData['parentUser'];
      final response = await ApiManager.callApi(
        endpoint: 'projects/parent/$userParentId',
        method: 'GET',
      );

      if (response['success']) {
        final dynamic responseData = response['data'];

        if (responseData is Map<String, dynamic>) {
          final List<Map<String, dynamic>> projectsList = [responseData];
          return projectsList;
        } else if (responseData is List<dynamic>) {
          final List<Map<String, dynamic>> projectsList =
              List<Map<String, dynamic>>.from(responseData);
          return projectsList;
        } else {
          throw Exception('Unexpected data structure in API response');
        }
      } else {
        throw Exception('Failed to fetch projects');
      }
    } catch (error) {
      print(error);
      throw Exception('Failed to fetch projects');
    }
  }

  void getProjectsTimeSpentAlready() async {
    try {
      final response = await ApiManager.callApi(
        endpoint: 'user/myProgress', // Use your endpoint from constants
        method: 'POST',
        body: {
          'userId': storageManager.getUserData['_id'],
          'date': DateTime.now().toString()
        },
        headers: {'Content-Type': 'application/json'},
      );
      print('lgetProjectsTimeSpentAlready $response');
      if (response['success']) {
        final Map<String, dynamic> data = response['data'];
        // Check if the 'record' field is defined
        if (data.containsKey('record')) {
          final Map<String, dynamic> record = data['record'];

          // Check if the 'projects' array is defined and not empty
          if (record.containsKey('projects') && record['projects'] is List) {
            final List<dynamic> projects = record['projects'];

            // Iterate through each project in the 'projects' array
            for (final project in projects) {
              if (project is Map<String, dynamic>) {
                final String projectId = project['projectId'];
                final int timeSpent = project['timeSpent'];

                // Update the project timer using the obtained projectId and timeSpent
                storageManager.updateProjectTime(projectId, timeSpent);
              }
            }
          }
        }
      } else {
        // Error handling for unsuccessful login
        // final errorMessage = response['message'];
        // setState(() {
        //   _loginError = errorMessage; // Set error message
        // });
        // return false;
        // showNotification(context, 'Invalid username or password');
      }
    } catch (error) {
      print(error);
      // Handle network or other errors
      // showNotification(context, 'Network or server error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 0),
            decoration: BoxDecoration(
              color: AppTheme.background_color,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Consumer<StorageManager>(
              builder: (context, storageManager, _) {
                final projects = storageManager.getProjectsAsMapList();
                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    final project = projects[index];
                    return _buildProjectCard(
                      project['title'] ??
                          '', // Replace with your project data keys
                      project['time_spent'] ??
                          '00:00:00', // Replace with your project data keys
                    );
                  },
                );
              },
            )),
      ),
    );
  }

  void _setCurrentProject(String projectName) {
    final storageManager = Provider.of<StorageManager>(context, listen: false);
    final selectedProject = storageManager.listOfProjects.firstWhere(
      (project) => project.title == projectName,
      orElse: () => Project(id: '', title: ''),
    );

    storageManager.setCurrentProjectUnderWork(selectedProject);
  }

  Widget _buildProjectCard(String projectName, String time) {
    final storageManager = Provider.of<StorageManager>(context, listen: false);
    final currentProject = storageManager.getCurrentProjectUnderWork();
    final project = storageManager.listOfProjects.firstWhere(
      (project) => project.title == projectName,
      orElse: () => Project(id: '', title: ''),
    );

    // final isWorkingOnProject =
    // currentProject != null && currentProject.title == projectName;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: AppTheme.background_color_overlay,
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              projectName,
              style: TextStyle(color: Colors.white),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Chip(
                      label: Text(
                        time,
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.grey[800],
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_currentProjectTitle == projectName) {
                        // If the same project is tapped again, pause it
                        final currentProj =
                            storageManager.listOfProjects.firstWhere(
                          (project) => project.title == _currentProjectTitle,
                          orElse: () => Project(id: '', title: ''),
                        );
                        currentProj.isWorking = false;
                        _currentProjectTitle = null;
                      } else {
                        // Pause the previously selected project, if any
                        if (_currentProjectTitle != null) {
                          final prevProject =
                              storageManager.listOfProjects.firstWhere(
                            (project) => project.title == _currentProjectTitle,
                            orElse: () => Project(id: '', title: ''),
                          );
                          prevProject.isWorking = false;
                        }

                        // Start working on the selected project
                        _currentProjectTitle = projectName;
                        final selectedProject =
                            storageManager.listOfProjects.firstWhere(
                          (project) => project.title == projectName,
                          orElse: () => Project(id: '', title: ''),
                        );
                        selectedProject.isWorking = true;
                        storageManager
                            .setCurrentProjectUnderWork(selectedProject);
                      }
                    });
                  },
                  icon: Icon(
                    project.isWorking ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          // _setCurrentProject(projectName);
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_boiler_plate/apis/api_manager.dart';
import 'package:flutter_boiler_plate/managers/storage_manager.dart';
import 'package:flutter_boiler_plate/utils/app_styles.dart';
import 'package:provider/provider.dart';

class Project {
  final String id;
  final String title;

  Project({required this.id, required this.title});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['_id'],
      title: json['projectName'], // Updated to match the JSON key
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    storageManager = Provider.of<StorageManager>(context);
    if (!_isFetchProjectsCalled) {
      _fetchProjects();
      _isFetchProjectsCalled =
          true; // Set the flag to true after calling _fetchProjects
    } // Call method to fetch projects when dependencies change
  }

  // @override
  // void initState() {
  //   super.initState();

  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     storageManager = Provider.of<StorageManager>(context);
  //     _fetchProjects();
  //   });
  // }

  Future<void> _fetchProjects() async {
    try {
      final List<Map<String, dynamic>> fetchedProjects =
          await _getProjectsList();
      setState(() {
        projects = fetchedProjects;
      });

      // Convert fetched projects to List<Project>
      List<Project> projectObjects = fetchedProjects
          .map((projectMap) => Project.fromJson(projectMap))
          .toList();

      // Update the list of projects in StorageManager
      storageManager.updateListOfProjects(projectObjects);
      print("projectObjects");
      print(projectObjects);
      for (Project project in projectObjects) {
        print('Project ID: ${project.id}, Project Title: ${project.title}');
      }
      if (projectObjects.isNotEmpty) {
        print("setting up as under work project ");
        print(projectObjects.first);
        print(
            'Setting up the first project as the current project under work:');
        print(
            'Project ID: ${projectObjects.first.id}, Project Title: ${projectObjects.first.title}');

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
      // print(response);
      ;
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
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];

              return _buildProjectCard(
                project['projectName'] ??
                    '', // Replace with your project data keys
                project['time'] ?? '', // Replace with your project data keys
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(String projectName, String time) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color:
          AppTheme.background_color_overlay, // Replace with your desired color
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
                    // Handle play/pause functionality for the project
                  },
                  icon: const Icon(Icons.play_arrow),
                  color: Colors.white,
                  iconSize: 20,
                ),
              ],
            ),
          ],
        ),
        onTap: () {
          // Handle tap for the project
        },
      ),
    );
  }
}

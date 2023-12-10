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
class Project_model {
  final String projectName;
  final String statusName;
  final double completionPercentage;
  final String? priority;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> tasks;
  final String? icon;
  final String assignees;
  final String link;

  Project_model({
    required this.projectName,
    required this.statusName,
    required this.completionPercentage,
    this.priority,
    this.startDate,
    this.endDate,
    required this.assignees,
    required this.tasks,
    this.icon,
    required this.link,
  });

  factory Project_model.fromSimpleJson(Map<String, dynamic> json) {
    return Project_model(
      projectName: json['projectName'] ?? '',
      statusName: '',
      completionPercentage: 0.0,
      priority: null,
      startDate: null,
      endDate: null,
      link: '',
      tasks: [],
      assignees: '',
      icon: null,
    );
  }
}

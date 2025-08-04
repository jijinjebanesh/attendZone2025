import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:badges/badges.dart' as badges;

import '../helper_functions.dart';
import '../models/project_model.dart';
import 'project_details.dart';

class Projects extends StatefulWidget {
  const Projects({super.key});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  late Future<List<Project_model>> _fetchProjectsFuture;
  int _notificationCount = 3;
  String? Email;

  Future<List<Project_model>> fetchProjects() async {
    await Future.delayed(const Duration(seconds: 1));
    final dummyEmail = 'john.doe@example.com';
    return [
      Project_model(
        projectName: 'Student Portal Revamp',
        statusName: 'In progress',
        completionPercentage: 0.64,
        priority: 'High',
        startDate: DateTime(2024, 6, 10),
        endDate: DateTime(2024, 9, 1),
        tasks: ['Login Page', 'Profile UI', 'Chatbot Integration'],
        assignees: '$dummyEmail, jane.smith@college.edu',
        icon: '💻',
        link: 'https://github.com/yourorg/student-portal',
      ),
      Project_model(
        projectName: 'Attendance Tracker',
        statusName: 'Requested',
        completionPercentage: 0.1,
        priority: 'Medium',
        startDate: DateTime(2024, 7, 1),
        endDate: DateTime(2024, 10, 10),
        tasks: ['API Design', 'QR Scan', 'Report Exports'],
        assignees: dummyEmail,
        icon: '📲',
        link: 'https://github.com/yourorg/attendance-tracker',
      ),
    ];
  }

  @override
  @override
  void initState() {
    super.initState();
    _fetchProjectsFuture = fetchProjects();
    // Instead of loading from SharedPreferences
    Email = 'john.doe@example.com';
  }


  Future<void> _loadEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      Email = prefs.getString('email') ?? 'john.doe@example.com';
    });
  }

  Widget buildShimmerEffect(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 3,
        itemBuilder: (_, __) => Column(
          children: [
            SizedBox(height: EHelperFunctions.screenHeight(context) * .01),
            Container(
              width: screenWidth * .95,
              height: screenWidth * .35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.surfaceContainer,
              ),
            ),
            SizedBox(height: EHelperFunctions.screenHeight(context) * .01),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        title: Text(
          'Projects',
          style: GoogleFonts.rubik(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('/announcements'),
            icon: badges.Badge(
              badgeContent: Text(
                '$_notificationCount',
                style: const TextStyle(color: Colors.white),
              ),
              child: Icon(Iconsax.message, color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
      body: LiquidPullToRefresh(
        animSpeedFactor: 1,
        color: Colors.orange,
        onRefresh: () async {
          setState(() {
            _fetchProjectsFuture = fetchProjects();
          });
        },
        child: FutureBuilder<List<Project_model>>(
          future: _fetchProjectsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return buildShimmerEffect(context);
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final projects = snapshot.data ?? [];
              return ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  final project = projects[index];
                  final show = project.assignees.split(',').map((e) => e.trim()).contains(Email ?? '');
                  return Visibility(
                    visible: show,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Project_Details(
                              projectName: project.projectName,
                              statusName: project.statusName,
                              Link: project.link,
                              completionPercentage: project.completionPercentage,
                              priority: project.priority,
                              startDate: project.startDate,
                              endDate: project.endDate,
                              tasks: project.tasks,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          SizedBox(height: EHelperFunctions.screenHeight(context) * .01),
                          Container(
                            height: screenWidth * .35,
                            width: screenWidth * .95,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).colorScheme.surfaceContainer,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF000000),
                                  offset: Offset.fromDirection(20, 2),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: screenWidth * .03),
                                Expanded(
                                  child: Row(
                                    children: [
                                      CircularPercentIndicator(
                                        radius: 30.0,
                                        animation: true,
                                        animationDuration: 1200,
                                        lineWidth: 8.0,
                                        percent: project.completionPercentage.clamp(0.0, 1.0),
                                        circularStrokeCap: CircularStrokeCap.butt,
                                        fillColor: Theme.of(context).colorScheme.surfaceContainer,
                                        progressColor: Colors.orange,
                                      ),
                                      SizedBox(width: screenWidth * .03),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            project.projectName,
                                            style: GoogleFonts.rubik(
                                              color: Theme.of(context).colorScheme.primary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    SizedBox(height: EHelperFunctions.screenHeight(context) * .13),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: 10,
                                          width: 10,
                                          decoration: BoxDecoration(
                                            color: getCompletionColor(project.priority),
                                            borderRadius: BorderRadius.circular(100),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          project.priority ?? 'Not Set',
                                          style: GoogleFonts.rubik(
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                        ),
                                        const SizedBox(width: 13),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: EHelperFunctions.screenHeight(context) * .01),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

Color getCompletionColor(String? priority) {
  switch (priority) {
    case 'High':
      return Colors.red.shade400;
    case 'Low':
      return Colors.green.shade400;
    case 'Medium':
      return Colors.orange.shade400;
    case 'General':
      return Colors.blue.shade400;
    default:
      return Colors.black;
  }
}

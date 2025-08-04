import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:badges/badges.dart' as badges;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../models/attendance_model.dart';
import '../models/task_model.dart';
import '../utils/taskCard.dart';

List<Task_model> tasks = [
  Task_model(
    statusName: 'In progress',
    email: 'jijinjebanesh@gmail.com',
    taskName: 'Design UI Mockup',
    priority: 'High',
    Description: 'Create visual layout for the main dashboard and login screens.',
    task_id: '',
  ),
  Task_model(
    statusName: 'In progress',
    email: 'jijinjebanesh@gmail.com',
    taskName: 'Write API integration',
    priority: 'Medium',
    Description: 'Integrate backend endpoints for user login and task fetch.',
    task_id: '',
  ),
  Task_model(
    statusName: 'Completed',
    email: 'jijinjebanesh@gmail.com',
    taskName: 'Set up Firebase Authentication',
    priority: 'High',
    Description: 'Configured Firebase for email/password and Google login.',
    task_id: '',
  ),
];

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _notificationCount = 3;
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Static attendance data
  double attendancePercentage = 0.75; // 75%
  double totalHours = 60.0; // 60 hours
  int attendancePercent = 75;
  String timeIn = '09:00 AM';
  String firstName = 'Jijin';
  String email = 'jijinjebanesh@gmail.com';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: GoogleFonts.rubik(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.push('/announcements');
            },
            icon: badges.Badge(
              badgeContent: Text(
                '$_notificationCount',
                style: TextStyle(color: Colors.white),
              ),
              child: Icon(
                Iconsax.message,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: LiquidPullToRefresh(
        animSpeedFactor: 1,
        color: Colors.orange,
        onRefresh: () async {
          // Simulate refresh with static data
          await Future.delayed(Duration(seconds: 1));
          setState(() {});
        },
        child: ListView(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * .07),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * .1),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      firstName,
                      style: GoogleFonts.rubik(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      ),
                    ),
                    Text(
                      email,
                      style: GoogleFonts.rubik(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: MediaQuery.of(context).size.width * .25),
                CircularPercentIndicator(
                  radius: 31.0,
                  animation: true,
                  animationDuration: 1200,
                  lineWidth: 6.0,
                  percent: attendancePercentage,
                  center: Text(
                    '$attendancePercent%',
                    style: GoogleFonts.rubik(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  circularStrokeCap: CircularStrokeCap.butt,
                  fillColor: Colors.transparent,
                  progressColor: Colors.red,
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .1),
            SizedBox(
              height: screenHeight * 0.2957,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: tasks.where((task) => task.statusName == 'In progress').length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final task = tasks.where((task) => task.statusName == 'In progress').toList()[index];
                  return TaskCard(task: task);
                },
              ),
            ),
            SizedBox(
              height: 5,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: tasks.where((task) => task.statusName == 'In progress').length,
                  effect: const WormEffect(
                    activeDotColor: Colors.orange,
                    dotHeight: 5,
                    dotWidth: 10,
                    type: WormType.thinUnderground,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .1),
            Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * .10),
                Column(
                  children: [
                    Text(
                      'IN TIME:',
                      style: GoogleFonts.rubik(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      timeIn,
                      style: GoogleFonts.rubik(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: MediaQuery.of(context).size.width * .4),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .25,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Check-out button pressed")),
                      );
                    },
                    child: Text(
                      "Check-Out",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[200],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
import 'dart:convert';
import 'dart:typed_data';
import 'package:attendzone_new/auth/FDF.dart';
import 'package:attendzone_new/auth/person.dart';
import 'package:attendzone_new/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Api/Api.dart';
import '../Api/chatApi.dart';
import '../auth/facedetectionview.dart';
import '../popups/fullscreen_loaders.dart';
import 'Projects.dart';
import 'attendance_page.dart';
import 'dashboard.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late PageController _pageController;
  String? Email;
  String? usrName;
  List<int> profileBytes = [];

  @override
  void initState() {
    super.initState();
    _check();
   // _loadProfileData();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  // Future<void> _loadProfileData() async {
  //   // Dummy data simulation
  //   setState(() {
  //     Email = 'dummy@example.com';
  //     usrName = 'Dummy User';
  //
  //     // Base64 for a 1x1 transparent PNG
  //     const base64Profile = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQIW2N8+/btfwAJ6AP9US8GlwAAAABJRU5ErkJggg==';
  //     profileBytes = base64Decode(base64Profile);
  //   });
  //
  //  // _fetchChatMessages(); // You can comment this if you want to avoid Chat API call
  // }

  Future<void> _check() async {
    try {
      // Dummy simulation
      debugPrint("Running _check with dummy data");

      await Future.delayed(const Duration(milliseconds: 800));

      EFullScreenLoader.openLoadingDialog('Loading...', context);

      await Future.delayed(const Duration(seconds: 2));
      EFullScreenLoader.stopLoading(context);

      // Simulate IP validation fail/success (optional)
      bool isIpValid = true;

      if (!isIpValid) {
        EHelperFunctions.showSnackBar(context, 'IP invalid');
      }

      // Uncomment below to simulate face detection logic (optional)
      // List<Person> personList = await FaceDect().enrollPerson();
      // if (personList.isNotEmpty) {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => FaceRecognitionView(personList: personList),
      //     ),
      //   );
      // }

    } catch (e) {
      print('An error occurred: $e');
    }
  }

  // Future<void> _fetchChatMessages() async {
  //   if (Email != null) {
  //     try {
  //     //  await ChatApi.getChatMessages(Email!);
  //     } catch (e) {
  //       print('Error fetching chat messages: $e');
  //     }
  //   }
  // }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: const <Widget>[
          MyHomePage(title: ''),
          Projects(),
          AttendancePage(),
          Profile(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home, size: 26),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.briefcase, size: 26),
            label: 'Projects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.calendar_1, size: 26),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.orange),
                  ),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage('https://fxcams.in/assets/img/student/b70c44fea2b026f0e56300d26efe4b96.JPG'),
                    backgroundColor: Colors.transparent,
                    onBackgroundImageError: (error, stackTrace) {
                      print("Image failed to load: $error");
                    },
                  ),
                ),
              ],
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}


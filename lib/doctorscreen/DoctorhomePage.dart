import 'package:dhe/videoupload.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../PatientsPages/homepage.dart';
import '../add_post.dart';
import '../settings.dart';
import 'DHomePage.dart';
import 'ViewAppointments.dart';

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({Key? key}) : super(key: key);

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DocHomePage(),
    VideoUploadPage(),
    AddPostScreen(),
    ViewAppointments(),

    NavigationMenu(),
    // Add other pages here
  ];

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            gap: 8,
            onTabChange: _onTabChange,
            selectedIndex: _selectedIndex,
            padding: EdgeInsets.all(13),
            tabs: const [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.play_arrow, text: 'Tutorials'),
              GButton(icon: Icons.add_box_rounded, text: 'add Post'),
              GButton(icon: Icons.mark_chat_unread_sharp, text: 'Appointments'),
              GButton(icon: Icons.account_circle, text: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}

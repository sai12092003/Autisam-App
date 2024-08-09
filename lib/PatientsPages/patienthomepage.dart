import 'package:dhe/PatientsPages/tut2.dart';
import 'package:dhe/PatientsPages/tutorialcat.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../add_post.dart';
import '../feed_screen.dart';
import '../settings.dart';
import 'ProfileStaticspatient.dart';
import 'homepage.dart';

class PhomePage extends StatefulWidget {
  const PhomePage({Key? key}) : super(key: key);

  @override
  State<PhomePage> createState() => _PhomePageState();
}

class _PhomePageState extends State<PhomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    // HomePage(),
    FeedScreen(),
    Tutorial2(),
    //MyPage(),
    AddPostScreen(),
    HomePage(),
    ProfileDetails(),
    //NavigationMenu()
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
              GButton(icon: Icons.add_box_rounded, text: 'Add Post'),
              GButton(icon: Icons.perm_contact_calendar_outlined, text: 'Book App..'),
              GButton(icon: Icons.account_circle, text: 'Settings'),
            ],
          ),
        ),
      ),
    );
  }
}

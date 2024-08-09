import 'package:dhe/patients_flask/parentalGuide.dart';
import 'package:dhe/patients_flask/speaking_activitiy.dart';
import 'package:flutter/material.dart';

import 'CognitivePage.dart';
import 'GameOptions.dart';



class OptionsDashboard extends StatefulWidget {
  const OptionsDashboard({Key? key}) : super(key: key);

  @override
  State<OptionsDashboard> createState() => _OptionsDashboardState();
}

class _OptionsDashboardState extends State<OptionsDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          children: [
            const SizedBox(height: 40.0),
            _buildListItem('Games', Colors.blue, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => GameOptions()));
            }),
            const SizedBox(height: 35.0), // Adjust the height between list items
            _buildListItem('Speaking Assessment', Colors.green, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SpeakingPage()));
            }),
            const SizedBox(height: 35.0), // Adjust the height between list items
            _buildListItem('Cognitive Assessment', Colors.pink, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CognitativePage()));
            }),
            const SizedBox(height: 35.0), // Adjust the height between list items
            _buildListItem('Workshops', Colors.orange, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ParentalPage()));
            }),
          ],
        ),
      ),
    );
  }

  Container _buildListItem(String title, Color color, Function onTap) {
    return Container(
      height: 140.0, // Adjust the height of the list item
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ListTile(
        title: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold,color: Colors.white),
          ),
        ),
        tileColor: Colors.transparent, // Set this to transparent to avoid color overlapping
        onTap: () => onTap(),
      ),
    );
  }
}


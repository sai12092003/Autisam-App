import 'package:flutter/material.dart';

import 'colourMatchingGame.dart';

class GameOptions extends StatefulWidget {
  const GameOptions({Key? key}) : super(key: key);

  @override
  State<GameOptions> createState() => _GameOptionsState();
}

class _GameOptionsState extends State<GameOptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Games'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildListItem(
            title: 'Colour Matching',
            imagePath: 'assets/child.jpg',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ColorMatching()),
              );
            },
          ),

          // Add more list items as needed
        ],
      ),
    );
  }

  Widget _buildListItem({required String title, required String imagePath, required Function onTap}) {
    return Container(
      height: 80.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.7),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: Container(

          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(imagePath),
            ),
          ),
        ),
        onTap: () => onTap(),
      ),
    );
  }
}

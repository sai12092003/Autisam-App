import 'package:flutter/material.dart';
import 'dart:math';

import '../patients_flask/optionsDashboard.dart';
import '../uploadedvideos.dart';

class Tutorial2 extends StatefulWidget {
  const Tutorial2({Key? key}) : super(key: key);

  @override
  State<Tutorial2> createState() => _Tutorial2State();
}

class _Tutorial2State extends State<Tutorial2> {
  @override
  Widget build(BuildContext context) {
    // List of default colors for cards.
    List<Color> defaultColors = [
      Colors.purple,
      Colors.teal,
      Colors.amber,
      Colors.indigo,
      Colors.pink,
      Colors.cyan,
      Colors.lime,
      Colors.brown,
    ];

    // Shuffle the default colors.
    defaultColors.shuffle(Random());

    return Scaffold(
      appBar: AppBar(
        title: Text('Tutorials'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add_chart_rounded,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OptionsDashboard()),
              );
            },
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: 8,
          itemBuilder: (context, index) {
            if (index < defaultColors.length) {
              return Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UploadedVideos()),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: getGradient(index, defaultColors),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      title: Center(
                        child: Text(
                          getTitle(index),
                          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else {
              // Use a default color for additional cards.
              return Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.grey, // Set a default color for additional cards.
                child: InkWell(
                  onTap: () {
                    if(index<4)
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UploadedVideos()),
                        );
                      }
                    else
                      {

                      }
                  },
                  child: Container(
                    child: ListTile(
                      title: Center(
                        child: Text(
                          getTitle(index),
                          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  LinearGradient getGradient(int index, List<Color> defaultColors) {
    // Use default color if index is within the range of defaultColors.
    if (index < defaultColors.length) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [defaultColors[index], defaultColors[index].withAlpha(200)],
      );
    } else {
      // Use a default gradient for additional cards.
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.grey, Colors.grey.withAlpha(200)],
      );
    }
  }

  String getTitle(int index) {
    switch (index) {
      case 0:
        return 'Joint Attention ';
      case 1:
        return 'Self Confession';
      case 2:
        return 'Speech';
      case 3:
        return 'Pointing';
      default:
        return 'Coming Soon';
    }
  }
}

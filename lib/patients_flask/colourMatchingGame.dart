import 'package:flutter/material.dart';

class ColorMatching extends StatefulWidget {
  const ColorMatching({Key? key}) : super(key: key);

  @override
  State<ColorMatching> createState() => _ColorMatchingState();
}

class _ColorMatchingState extends State<ColorMatching> {
  List<Fruit> fruits = [
    Fruit(name: 'Apple', color: Colors.red),
    Fruit(name: 'Banana', color: Colors.yellow),
    Fruit(name: 'Grapes', color: Colors.purple),
    // Add more fruits as needed
  ];

  List<Color> colors = [
    Colors.red,
    Colors.yellow,
    Colors.purple,
    // Add more colors as needed
  ];

  bool showMatchedMessage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Colour  Game'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: fruits.length,
              itemBuilder: (context, index) {
                return Draggable(
                  data: fruits[index],
                  feedback: FruitCard(fruits[index]),
                  child: FruitCard(fruits[index]),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          AnimatedOpacity(
            opacity: showMatchedMessage ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: Text(
              'Matched! Well done!',
              style: TextStyle(
                color: Colors.green,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: colors
                  .map((color) => DragTarget<Fruit>(
                builder: (context, accepted, rejected) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: accepted.isNotEmpty ? Colors.green : color,
                  );
                },
                onWillAccept: (data) => data?.color == color,
                onAccept: (data) {
                  setState(() {
                    fruits.remove(data);
                    showMatchedMessage = true;
                  });
                  _resetMatchedMessage();
                },
              ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _resetMatchedMessage() {
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        showMatchedMessage = false;
      });
    });
  }
}

class Fruit {
  final String name;
  final Color color;

  Fruit({required this.name, required this.color});
}

class FruitCard extends StatelessWidget {
  final Fruit fruit;

  FruitCard(this.fruit);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        width: 100,
        height: 100,
        color: fruit.color,
        child: Center(
          child: Text(
            fruit.name,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CognitativePage extends StatefulWidget {
  const CognitativePage({Key? key}) : super(key: key);

  @override
  State<CognitativePage> createState() => _CognitativePageState();
}

class _CognitativePageState extends State<CognitativePage> {
  String correctAnswer = 'bird';
  String selectedAnswer = '';
  bool showSuccessMessage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cognitive Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              ' ______ can fly.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOption('Kingfisher'),
                _buildOption('tiger'),
                _buildOption('human'),
              ],
            ),
            SizedBox(height: 20),
            if (showSuccessMessage)
              Text(
                'Correct! $selectedAnswer can fly ',
                style: TextStyle(color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String option) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedAnswer = option;
          if (option == correctAnswer) {
            // Correct answer, show success message
            showSuccessMessage = true;
          } else {
            // Incorrect answer, reset success message
            showSuccessMessage = false;
          }
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      child: Text(
        option,
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
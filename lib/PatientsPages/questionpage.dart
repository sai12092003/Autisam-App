import 'package:flutter/material.dart';
import 'package:animated_card/animated_card.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({Key? key}) : super(key: key);

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Parental Feedback'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedCard(
                direction: AnimatedCardDirection.right,
                // Choose your preferred animation direction
                child:const  QuestionCard(

                  question: "Did your child respond to the video?",
                  options: ["Yes", "No"],
                ),
              ),
              const SizedBox(height: 16),
              AnimatedCard(
                direction: AnimatedCardDirection.left,
                child:const QuestionCard(
                  question: "How confident are you to teach this to your child?",
                  options: ["Low", "Medium", "High"], // For text input
                ),
              ),
              const SizedBox(height: 16),
              AnimatedCard(
                direction: AnimatedCardDirection.right,
                child:const  QuestionCard(
                  question: "How proficient is your child with this skill?",
                  options: ["Low", "Medium", "High"],
                ),
              ),
              const SizedBox(height: 16),
              AnimatedCard(
                direction: AnimatedCardDirection.left,
                child:const  QuestionCard(
                  question: "How many repetitions after your kid followed this skill?",
                  options: null, // For text input
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.lime[900]),
                onPressed: () {

                },
                child:const  Text('SUBMIT',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuestionCard extends StatefulWidget {
  final String question;
  final List<String>? options;

  const QuestionCard({Key? key, required this.question, this.options}) : super(key: key);

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  String? selectedOption;
  TextEditingController? textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: Colors.lime[200],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.question,
              style:const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (widget.options != null)
              Column(
                children: widget.options!
                    .map(
                      (option) => RadioListTile<String>(
                    title: Text(option),
                    value: option,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value;
                      });
                    },
                  ),
                )
                    .toList(),
              )
            else
              TextField(
                controller: textEditingController,

                decoration:const InputDecoration(hintText: "Enter the number",),
              ),
          ]
        ),
      ),
    );
  }

  @override
  void dispose() {
    textEditingController?.dispose();
    super.dispose();
  }
}

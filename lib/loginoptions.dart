import 'package:dhe/signinpatient.dart';
import 'package:dhe/signupdoctor.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center everything vertically
        children: <Widget>[
          Center(
            child: Image.asset(
              'assets/surgeon.png', // Replace with your image asset path
              width: 200, // Adjust the width as needed
              height: 200, // Adjust the height as needed
            ),
          ),
          SizedBox(height: 90), // Add space between the image and buttons
          Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center the buttons horizontally
            children: [
              ElevatedButton(
                onPressed: () {
                  // Navigate to the signup screen for Doctors
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // Set the button color for Doctors
                  minimumSize: Size(350, 50), // Set the minimum button size
                ),
                child: const Text('Doctor',
                  style: TextStyle(color: Colors.white,fontSize:18,fontWeight:FontWeight.bold),

                ),
              ),
              SizedBox(height: 40), // Add some space between the buttons
              ElevatedButton(
                onPressed: () {
                  // Navigate to the signup screen for Patients
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Psignin()));
                },
                child: Text('Patient', style: TextStyle(color: Colors.white,fontSize:18,fontWeight:FontWeight.bold)), // Set the text color to white
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // Set the button color for Patients
                  minimumSize: Size(350, 50), // Set the minimum button size
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'bookingpage.dart';
import 'bookingstatus.dart';
import 'homepage.dart';

class DoctorDetailsPage extends StatelessWidget {
  final String doctorName;
  final String doctorImage;
  final String doctorDescription;
  final String doctoruuid;

  DoctorDetailsPage({
  required this.doctorName,
  required this.doctorImage,
  required this.doctorDescription,
    required this.doctoruuid,
});

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Doctor Details'),
      actions: [
        IconButton(
            icon: const Icon(
              Icons.panorama_photosphere,
              color: Colors.black,
            ),
            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BookingStatus(doctoruuid: doctoruuid,)
                ),
              );
            }
        ),
      ],
    ),
    body: SingleChildScrollView( // Wrap your Column with SingleChildScrollView
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Doctor's Image
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(doctorImage),
                ),
              ),
            ),
           const  SizedBox(height: 20),
            // Doctor's Name
            Text(
              doctorName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 10),
            // Doctor's Description
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                doctorDescription,
                style: const TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 180),
            // Book Appointment Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppointmentBookingPage(doctorName: doctorName, doctorUid:doctoruuid ,)
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Red background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0), // Border radius
                ),
              ),
              child: Container(
                width: 200,
                height: 50,// Adjust the width as needed
                child: const Center(
                  child: Text(
                    'Book Appointment',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}

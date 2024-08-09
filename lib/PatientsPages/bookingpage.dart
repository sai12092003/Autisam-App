import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';



class AppointmentBookingPage extends StatefulWidget {
  final String doctorName;
  final String doctorUid;

  AppointmentBookingPage({required this.doctorName, required this.doctorUid});

  @override
  _AppointmentBookingPageState createState() => _AppointmentBookingPageState();
}

class _AppointmentBookingPageState extends State<AppointmentBookingPage> {
  final TextEditingController nameController = TextEditingController();
  String selectedDate = '';
  final TextEditingController reasonController = TextEditingController();
  bool isDateAvailable = true; // Flag to track date availability

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        selectedDate = picked.toLocal().toString().split(' ')[0];
        // Check if the selected date is available
        _checkDateAvailability(selectedDate);
      });
    }
  }

  // Function to check if the selected date is available
  Future<void> _checkDateAvailability(String date) async {
    final QuerySnapshot appointments = await _firestore
        .collection('appointments')
        .where('doctorId', isEqualTo: widget.doctorUid)
        .where('date', isEqualTo: date)
        .get();

    if (appointments.docs.isNotEmpty) {
      // Date is not available
      setState(() {
        isDateAvailable = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointment on $date is already booked by you.'),
        ),
      );
    } else {
      // Date is available
      setState(() {
        isDateAvailable = true;
      });
    }
  }

  void _submitAppointment() async {
    if (!isDateAvailable) {
      // Date is not available, don't proceed with the booking
      return;
    }

    final User? user = _auth.currentUser;
    if (user != null) {
      final String currentUserId = user.uid;
      final String reason = reasonController.text;
      final String name = nameController.text;

      if (currentUserId.isNotEmpty &&
          widget.doctorUid.isNotEmpty &&
          reason.isNotEmpty &&
          name.isNotEmpty &&
          selectedDate.isNotEmpty) {
        // Add the appointment to Firestore
        await _firestore.collection('appointments').add({
          'currentUserId': currentUserId,
          'doctorId': widget.doctorUid,
          'reason': reason,
          'name': name,
          'date': selectedDate,
          'status': 'pending',
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Appointment Request Sent Successfully'),
          ),
        );
        // Navigate back or perform any other action you need
        Navigator.pop(context);
      } else {
        // Handle validation errors or display a message
        // You can add code to handle these cases
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: 'Patient Name'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: reasonController,
                      decoration: const InputDecoration(labelText: 'Reason for Appointment'),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate.isEmpty ? 'Select Preferred Date' : selectedDate,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 140),
              ElevatedButton(
                onPressed: isDateAvailable ? _submitAppointment : null,
                child: Text(
                  'Book Now',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Red background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
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

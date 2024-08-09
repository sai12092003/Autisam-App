import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Allpatients.dart';
import 'DoctorsFeedScreen.dart';
import 'package:intl/intl.dart';

class DocHomePage extends StatefulWidget {
  const DocHomePage({Key? key}) : super(key: key);

  @override
  State<DocHomePage> createState() => _DocHomePageState();
}

class _DocHomePageState extends State<DocHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const  Text('Autisa',style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,fontSize: 25),),
        centerTitle: true,
        actions: [
          IconButton(
            icon:const Icon(Icons.search,color: Colors.grey,size: 35,),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) =>const SeeAllPatients()),
              );
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // "Explore New" Card
            GestureDetector(
              onTap: () {
                // Navigate to homePage
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) =>const DFeedScreen()),
                );
              },
              child: Container(
                width: double.infinity,
                height: 140,
                margin:const  EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient:const  LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.purple,
                      Colors.deepPurple,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Explore New',
                    style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold,),
                  ),
                ),
              ),
            ),
            // "Today's Appointments" Section
            Container(
              margin:const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Today's Appointments",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                  ),
                 const  SizedBox(height: 14),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('appointments')
                        .where('doctorId', isEqualTo: _auth.currentUser!.uid)
                        .where('status', isEqualTo: 'approved')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      final appointments = snapshot.data!.docs;

                      // Filter appointments for today's date
                      final today = DateTime.now();
                      final DateFormat formatter = DateFormat('yyyy-MM-dd');
                      final todayFormatted = formatter.format(today);

                      final todayAppointments = appointments.where((appointment) {
                        final appointmentDate = appointment['date'];
                        return appointmentDate == todayFormatted;
                      }).toList();

                      if (todayAppointments.isEmpty) {
                        return _buildNoAppointmentsCard();
                      } else {
                        return SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: todayAppointments.length,
                            itemBuilder: (context, index) {
                              return _buildAppointmentCard(todayAppointments[index]);
                            },
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            // "Patients" Section
            Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Patients',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 16),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('users').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      final users = snapshot.data!.docs;

                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return _buildUserCard(users[index]);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoAppointmentsCard() {
    return Container(
      width: double.infinity,
      margin:const  EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient:const  LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.green,
            Colors.redAccent,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      height: 100,
      child:const  Center(
        child: Text(
          'No Appointments Today',
          style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(QueryDocumentSnapshot appointment) {
    final currentUserId = appointment.get('currentUserId');
    final name = appointment.get('name');
    final date = appointment.get('reason');
    final reason = appointment.get('reason');

    return GestureDetector(
      onTap: () {
        // Show the appointment details when tapped
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        color: Colors.deepPurple,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Name: $name', style:const  TextStyle(color: Colors.white),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Reason: $date', style: const TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(QueryDocumentSnapshot user) {
    final userData = user.data() as Map<String, dynamic>;
    final profileUrl = userData['photoUrl'];
    final userName = userData['username'];

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      elevation: 10,
      color: Colors.lightGreen[300],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(profileUrl),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
          ),
        ],
      ),
    );
  }
}

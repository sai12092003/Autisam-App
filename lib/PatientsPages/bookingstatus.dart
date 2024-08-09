
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingStatus extends StatefulWidget {
  final String doctoruuid;
  const BookingStatus({Key? key, required this.doctoruuid}) : super(key: key);

  @override
  State<BookingStatus> createState() => _BookingStatusState();
}

class _BookingStatusState extends State<BookingStatus> with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late TabController _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = 0; // Set the default tab to "Pending"
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments Status'),
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(text: 'Pending'),
            Tab(text: 'Approved'),
            Tab(text: 'Rejected'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _buildAppointmentList('Pending'),
          _buildAppointmentList('Approved'),
          _buildAppointmentList('Rejected'),
        ],
      ),
    );
  }

  Widget _buildAppointmentList(String status) {
    String collectionName = 'appointments'; // The Firestore collection name
    String statusFilter = 'pending';

    if (status == 'Approved') {
      collectionName = 'appointments'; // Use a different collection for approved appointments
      statusFilter = 'approved';
    } else if (status == 'Rejected') {
      collectionName = 'appointments'; // Use a different collection for rejected appointments
      statusFilter = 'rejected';
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection(collectionName)
          .where('currentUserId', isEqualTo: _auth.currentUser?.uid)
          .where('status', isEqualTo: statusFilter)
      .where('doctorId',isEqualTo:widget.doctoruuid)// Filter by status
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final appointments = snapshot.data!.docs;

        return ListView.builder(
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index];
            final String patientName = appointment['name'];
            final String date = appointment['date'];
            final String reason = appointment['reason'];

            return Card(
              elevation: 4, // Add elevation for a card-like effect
              margin: EdgeInsets.all(8), // Add some margin for spacing
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Apply border radius
              ),
              child: ListTile(
                title: Text(patientName),
                subtitle: Text(date),
                trailing: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Only show actions for Pending appointments

                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  }



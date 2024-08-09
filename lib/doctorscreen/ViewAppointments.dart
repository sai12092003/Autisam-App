import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewAppointments extends StatefulWidget {
  const ViewAppointments({Key? key}) : super(key: key);

  @override
  State<ViewAppointments> createState() => _ViewAppointmentsState();
}

class _ViewAppointmentsState extends State<ViewAppointments> with SingleTickerProviderStateMixin {
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
        title: Text('Appointments'),
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(text: 'Pending'),
            Tab(text: 'Approved'),
            Tab(text: 'Rejected'),
          ],
        ),
        automaticallyImplyLeading: false,
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
          .where('doctorId', isEqualTo: _auth.currentUser?.uid)
          .where('status', isEqualTo: statusFilter) // Filter by status
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

            return Dismissible(
              key: Key(appointment.id),
              background: Container(
                color: Colors.green,
                alignment: Alignment.centerLeft,
                child: Icon(Icons.check, color: Colors.white),
              ),
              secondaryBackground: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                child: Icon(Icons.close, color: Colors.white),
              ),
              onDismissed: (direction) {
                if (direction == DismissDirection.startToEnd) {
                  _updateStatus(appointment, 'approved');
                } else if (direction == DismissDirection.endToStart) {
                  _updateStatus(appointment, 'rejected');
                }
              },
              child: Card(
                elevation: 4, // Add elevation for a card-like effect
                margin: EdgeInsets.all(8), // Add some margin for spacing
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Apply border radius
                ),
                child: ListTile(
                  title: Text(patientName),
                  subtitle: Text(reason),
                  onTap: () {
                    _showAppointmentDetails(context, patientName, date, reason);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _updateStatus(DocumentSnapshot appointment, String newStatus) {
    // Update the status field of the appointment document in Firestore
    appointment.reference.update({'status': newStatus});
  }

  void _showAppointmentDetails(
      BuildContext context,
      String patientName,
      String date,
      String reason,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Appointment Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Patient Name: $patientName'),
              Text('Date: $date'),
              Text('Reason: $reason'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

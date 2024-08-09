import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../sstyles/colors.dart';
import 'doctorDetails.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  // Flag to control whether to show search results or all doctors
  bool _showSearchResults = false;
  String _selectedDoctorName = '';
  String _selectedDoctorImage = '';
  String _selectedDoctorDescription = '';
  String _selecteduuid = '';

  // Define a base query for all doctors
  late Query<Map<String, dynamic>> baseQuery;

  @override
  void initState() {
    super.initState();
    baseQuery = FirebaseFirestore.instance.collection('Doctors');
  }

  void _performSearch(String query) {
    setState(() {
      if (query.isNotEmpty) {
        // Update the base query with a search filter
        baseQuery = FirebaseFirestore.instance.collection('Doctors')
            .where('Name', isGreaterThanOrEqualTo: query);
        _showSearchResults = true;
      } else {
        // Reset the base query to show all doctors when the search query is empty
        baseQuery = FirebaseFirestore.instance.collection('Doctors');
        _showSearchResults = false;
      }
      // Clear the selected doctor information
      _selectedDoctorName = '';
      _selectedDoctorImage = '';
      _selectedDoctorDescription = '';
      _selecteduuid='';
    });
  }

  void _showDoctorDetails(String doctorName, String doctorImage, String doctorDescription,String uuid) {
    setState(() {
      _selectedDoctorName = doctorName;
      _selectedDoctorImage = doctorImage;
      _selectedDoctorDescription = doctorDescription;
      _selecteduuid=uuid;
    });
    // Open the doctor's details in a new page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DoctorDetailsPage(
          doctorName: _selectedDoctorName,
          doctorImage: _selectedDoctorImage,
          doctorDescription: _selectedDoctorDescription,
           doctoruuid:_selecteduuid ,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Place elements at the top and bottom
      children: [
        const SizedBox(
          height: 17,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),

          child: Container(
            color: Colors.grey[200], // Light grey background
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                _performSearch(query);
              },
              decoration: InputDecoration(
                labelText: 'Search Doctors with Dr ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: baseQuery.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator(); // Loading indicator
                }

                final doctors = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    final doctorName = doctor['Name'] as String;
                    final doctorTitle = doctor['specialization'] as String;
                    final doctorImage = doctor['ProfImage'] as String;
                    final doctorDescription = doctor['Description'] as String;
                    final uuid=doctor['uid'] as String;

                    return InkWell(
                      onTap: () {
                        _showDoctorDetails(doctorName, doctorImage, doctorDescription,uuid);
                      },
                      child: Card(

                        color: Colors.yellow[200],

                        margin: EdgeInsets.only(bottom: 20),
                        child: Row(

                          children: [

                            Container(
                              width: 70, // Reduce the width
                              height: 80, // Reduce the height
                              color: Colors.grey[200], // Light grey background
                              child: Image(
                                width: 80,
                                height: 80,
                                image: NetworkImage(doctorImage),
                                fit: BoxFit.cover,
                              ),
                            ),
                           const  SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doctorName,
                                  style: TextStyle(
                                    color: Color(MyColors.header01),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  doctorTitle,
                                  style: TextStyle(
                                    color: Colors.brown,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),


                              ],
                            ),


                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}


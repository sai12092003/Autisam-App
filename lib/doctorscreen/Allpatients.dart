import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String photoUrl;

  User({required this.username, required this.photoUrl});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'] as String,
      photoUrl: map['photoUrl'] as String,
    );
  }
}

class UserDetailsPage extends StatelessWidget {
  final User user;

  UserDetailsPage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoUrl),
              radius: 50.0,
            ),
            SizedBox(height: 20.0),
            Text(
              user.username,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            // Add more details or customize the layout as needed
          ],
        ),
      ),
    );
  }
}

class SeeAllPatients extends StatefulWidget {
  const SeeAllPatients({Key? key}) : super(key: key);

  @override
  _SeeAllPatientsState createState() => _SeeAllPatientsState();
}

class _SeeAllPatientsState extends State<SeeAllPatients> {
  final TextEditingController _searchController = TextEditingController();
  late List<User> allUsers = [];
  List<User> displayedUsers = [];

  @override
  void initState() {
    super.initState();
    // Fetch user data from Firestore on initialization
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('users').get();
      final List<User> userList = snapshot.docs
          .map((doc) => User.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      setState(() {
        allUsers = userList;
        displayedUsers = allUsers; // Initialize displayedUsers with all users
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  void filterUsers(String query) async {
    // Wait for a short period after the user stops typing
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      if (query.isEmpty) {
        // If the search query is empty, display all users
        displayedUsers = allUsers;
      } else {
        // If there's a search query, filter the users based on the query
        displayedUsers = allUsers
            .where((user) =>
            user.username.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Center(
              child: Container(
                width: 380.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Colors.grey[200],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        // Handle search functionality
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: filterUsers, // Call filterUsers when the text changes
                        decoration: InputDecoration(
                          hintText: 'Search Patients',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: displayedUsers.length,
              itemBuilder: (context, index) {
                final user = displayedUsers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.photoUrl),
                  ),
                  title: Text(user.username),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () {
                      // Handle navigation to the user's details page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailsPage(user: user),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

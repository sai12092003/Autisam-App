import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dhe/signinpatient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dhe/utils/colors.dart';
import 'package:dhe/widgets/post_card.dart';

import '../resources/auth_methods.dart';



class DFeedScreen extends StatefulWidget {
  const DFeedScreen({Key? key}) : super(key: key);

  @override
  State<DFeedScreen> createState() => _DFeedScreenState();
}

class _DFeedScreenState extends State<DFeedScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:Colors.white,
      appBar: width > 600
          ? null
          : AppBar(
        backgroundColor: Colors.purple,
        centerTitle: true,
        title: Text('Autisa Feed',style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),



      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == null) {
            // Handle the case where the snapshot data is null, e.g., display an error message.
            return const Center(
              child: Text('No data available'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => Container(
              margin: EdgeInsets.symmetric(
                horizontal: width > 600 ? width * 0.4 : 0,
                vertical: width > 600 ? 13 : 0,
              ),
              child: PostCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            ),
          );
        },
      ),
    );
  }
}
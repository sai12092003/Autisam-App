import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dhe/models/user.dart'as m;
import 'package:dhe/providers/user_provider.dart';
import 'package:dhe/resources/firestore_methods.dart';
import 'package:dhe/utils/utils.dart';
import 'package:dhe/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final postId;
  const CommentsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController commentEditingController =
  TextEditingController();
  String? uu;
  String? pp;
  String? pro="https://firebasestorage.googleapis.com/v0/b/atttendaceml.appspot.com/o/profilePics%2FpT4AGAcTwnSzj2sz9kkhNFKkuq42?alt=media&token=c9221343-d64f-4d12-98ed-6889a734b491";
  @override




  void postComment(String uid, String name, String profilePic) async {
    try {

      final FirebaseAuth _auth = FirebaseAuth.instance;
      User currentUser = _auth.currentUser!;
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      if (currentUser != null) {
        DocumentSnapshot documentSnapshot = await _firestore.collection('users').doc(currentUser.uid).get();
        if (documentSnapshot.exists) {
          uu = documentSnapshot.get('username'); // Set the username variable
          pp = documentSnapshot.get('photoUrl'); // Set the photo URL variable

          print('name: $uu');

        }
      }

      print('$uu');
      String res = await FireStoreMethods().postComment(
        widget.postId,
        commentEditingController.text,
        currentUser.uid,
        uu!,
        pp!,
      );

      if (res != 'success') {
        if (context.mounted) showSnackBar(context, res);
      }
      setState(() {
        commentEditingController.text = "";
      });
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final m.User? user = Provider.of<UserProvider>(context).getUser;



    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Comments',
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .collection('comments')
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => CommentCard(
              snap: snapshot.data!.docs[index],
            ),
          );
        },
      ),
      // text input
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(pp==null?pro!:pp!),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: commentEditingController,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${uu}',
                      border: InputBorder.none,

                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => postComment(
                  'user!.uid',
                  'uu!',
                  'pp!',
                ),
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
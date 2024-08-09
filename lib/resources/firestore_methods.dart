import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:dhe/models/post.dart';
import 'package:dhe/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? uname="";
  String? phurl="";
  Future<String?> uploadPost(String description, Uint8List file, String uid, String username, String profImage) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      User currentUser = _auth.currentUser!;
      String photoUrl = await StorageMethods().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();

       // User from firebase_auth
      if (currentUser != null) {
        DocumentSnapshot documentSnapshot = await _firestore.collection('users').doc(currentUser.uid).get();
        if (documentSnapshot.exists) {
          uname = documentSnapshot.get('username'); // Set the username variable
          phurl = documentSnapshot.get('photoUrl'); // Set the photo URL variable

        }
      }



      // creates unique id based on time
      Post post = Post(
        description: description,
        uid: currentUser.uid,
        username: uname!,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: phurl!,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post comment
  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      String namee="",ppurl="";
      final FirebaseAuth _auth = FirebaseAuth.instance;
      User currentUser = _auth.currentUser!;
      if (currentUser != null) {
        DocumentSnapshot documentSnapshot = await _firestore.collection('users').doc(currentUser.uid).get();
        if (documentSnapshot.exists) {
          uname = documentSnapshot.get('username'); // Set the username variable
          phurl = documentSnapshot.get('photoUrl'); // Set the photo URL variable
          namee=uname!;
          ppurl=phurl!;
          //print('name: $uname');

        }
      }


      if (text.isNotEmpty) {

        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': ppurl,
          'name': namee,
          'uid': currentUser.uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
      await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }
}
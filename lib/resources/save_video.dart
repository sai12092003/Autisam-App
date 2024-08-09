
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';





class StoreData {
  Future<String?> uploadVideo(String videoUrl, Function(double) onProgress) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('videos/${DateTime.now()}.mp4');
    UploadTask uploadTask = ref.putFile(File(videoUrl));

    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      double progress = (snapshot.bytesTransferred / snapshot.totalBytes);
      onProgress(progress);
    });

    try {
      await uploadTask;
      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading video: $e');
      return null; // Handle the error gracefully in your app
    }
  }

  Future<void> saveVideoData(String videoDownloadUrl, String title, String Desc,/* File imageFile*/) async {
    await FirebaseFirestore.instance.collection('videos').add({
      'url': videoDownloadUrl,
      'timestamp': FieldValue.serverTimestamp(),
      'name': title,
      'subtitle':Desc,
      //'thumbnail':imageFile
    });
  }
}

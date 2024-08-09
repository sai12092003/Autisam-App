import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class VideoUploadPage extends StatefulWidget {
  const VideoUploadPage({Key? key}) : super(key: key);

  @override
  State<VideoUploadPage> createState() => _VideoUploadPageState();
}

class _VideoUploadPageState extends State<VideoUploadPage> {
  String? _videoURL;
  late VideoPlayerController _controller;
  String? _downloadURL;
  double _uploadProgress = 0.0;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? _category;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  _VideoUploadPageState() {
    _controller = VideoPlayerController.network('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text('Video Upload'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Stack(

        children: [
          SizedBox(width: 250,),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _videoURL != null
                      ? _videoPreviewWidget()
                      : GestureDetector(
                    onTap: _pickVideo,
                    child: Center(
                      child: Column(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload,
                              size: 170, color: Colors.grey),
                          const Text('Tap to upload',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Center(
                    child: Container(
                      width: 250,
                      child: ElevatedButton(
                        onPressed: _pickVideo,
                        child: const Text('Pick Video',style: TextStyle(fontWeight: FontWeight.bold),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_uploadProgress > 0)
            Center(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicatorWithLabel(
                    value: _uploadProgress,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  _pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      _videoURL = pickedFile.path;
      _initializeVideoPlayer();
    }
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.file(File(_videoURL!))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  Widget _videoPreviewWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          DropdownButtonFormField<String>(
            value: _category,
            items: ['Joint Attention', 'Self Confession', 'Speech', 'Pointing']
                .map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _category = newValue;
              });
            },
            decoration: InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a category';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          Container(
            width: 250,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.purple,
                onPrimary: Colors.white,
              ),
              onPressed: _uploadVideo,
              child: const Text('UPLOAD'),
            ),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Future<void> _uploadVideo() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String fileName = path.basename(_videoURL!);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('videos/$fileName');
    UploadTask uploadTask = ref.putFile(File(_videoURL!));

    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      setState(() {
        _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
      });
    });

    TaskSnapshot taskSnapshot = await uploadTask;
    _downloadURL = await taskSnapshot.ref.getDownloadURL();

    if (_controller.value.isPlaying) {
      _controller.pause();
    }

    await FirebaseFirestore.instance.collection('videos').add({
      'title': titleController.text,
      'description': descriptionController.text,
      'category': _category,
      'url': _downloadURL,
      'created_at': FieldValue.serverTimestamp(),
    });

    setState(() {
      _videoURL = null;
      titleController.clear();
      descriptionController.clear();
      _category = null;
      _uploadProgress = 0.0;
    });
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class CircularProgressIndicatorWithLabel extends StatelessWidget {
  final double value;

  const CircularProgressIndicatorWithLabel({required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(
          value: value,
          strokeWidth: 8,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
        const SizedBox(height: 8),
        Text('${(value * 100).toStringAsFixed(1)}%'),
      ],
    );
  }
}

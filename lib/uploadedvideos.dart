import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

import 'PatientsPages/questionpage.dart';

class UploadedVideos extends StatefulWidget {
  @override
  State<UploadedVideos> createState() => _UploadedVideosState();
}

class _UploadedVideosState extends State<UploadedVideos> {
  late ChewieController _chewieController;
  bool isDataLoading = true;
  late String enteredValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Videos'),
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _fetchVideoData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No videos found.');
          } else {
            isDataLoading = false;
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final videoData = snapshot.data![index].data() as Map<String, dynamic>;
                final videoUrl = videoData['url'] as String;
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 4.0,
                  child: ListTile(
                    title: Text(
                      '${videoData['name']} ',
                      style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${videoData['subtitle']}', style: TextStyle(color: Colors.white)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.play_circle_outline, color: Colors.white, size: 29),
                          onPressed: () {
                            _showInstructionsCard(() {
                              _playVideo(videoUrl);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  color: Colors.indigo[200],
                );
              },
            );
          }
        },
      ),
    );
  }

  void _playVideo(String videoUrl) {
    _chewieController = ChewieController(
      videoPlayerController: VideoPlayerController.network(videoUrl),
      aspectRatio: 16 / 9,
      autoPlay: true,
      looping: false,
      allowedScreenSleep: false,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Chewie(
              controller: _chewieController,
            ),
          ),
        ),
      ),
    ).then((value) {
      _chewieController.pause();
      _showCalculatorPopup();
    });
  }

  Future<List<DocumentSnapshot>> _fetchVideoData() async {
    final snapshot = await FirebaseFirestore.instance.collection('videos').get();
    return snapshot.docs;
  }

  void _showInstructionsCard(Function onPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AnimatedContainer(
            duration:const  Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.yellow, Colors.orange],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0),
                       bottomLeft:Radius.circular(15.0),
                        bottomRight:Radius.circular(15.0),
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        const Text(
                          'Instructions to Parent',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),
                        const Text('1. Sit, Watch with Your child.\n2. Observe, Interact, Participate.\n3. Answer parental qes once video is done.\n4. Press "Continue" to proceed.'),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green[500]),
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                            onPressed(); // Continue with video playback
                          },

                          child: const Text('Continue',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                        ),
                      ],
                    ),
                  ),


                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCalculatorPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:const Text('Answer the Question'),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('What is 5 * 5?'),
                const SizedBox(height: 10),
                TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    enteredValue = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Check the answer
                Navigator.pop(context); // Close the dialog
                if (enteredValue == '25' && enteredValue != '') {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>const QuestionPage(),
                    ),
                  );
                } else {
                  _showCalculatorPopup();
                }
              },
              child:const  Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _chewieController.dispose();
  }
}



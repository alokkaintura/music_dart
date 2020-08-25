//import 'dart:html';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:player/main.dart';
import 'package:video_player/video_player.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:file_picker/file_picker.dart';

import 'package:LinuxMusic/player/allmp.dart' show VideoPlayerApp;

void main() => runApp(OninePlayer());

class OninePlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LinuxWorld',
      debugShowCheckedModeBanner: false,
      home: VideoScreen(),
    );
  }
}

Future<List<File>> asynce() async {
  return await FilePicker.getMultiFile();
}

class VideoScreen extends StatefulWidget {
  VideoScreen({Key key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
     _controller = VideoPlayerController.network(
      'https://github.com/alokkaintura/video/blob/master/2020-03-14-203222138.mp4');
    //_controller = VideoPlayerController.asset('assets/son.mp4');
    _initializeVideoPlayerFuture = _controller.initialize();

    _controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  double opacityLevel = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.grey.shade700,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VideoPlayerApp()),
                      );
                    }),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.all(15)),
                    Text(
                      'Online Video Player',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800),
                    ),
                    Text(''),
                    Text(
                      'Now Playing',
                      style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.deepOrangeAccent),
                    ),
                  ],
                ),
                Container(
                    child: CupertinoButton(
                        onPressed: () async {
                          var path;
                          path.filePath = await FilePicker.getFilePath();
                        },
                        child: Icon(
                          Icons.online_prediction,
                          color: Colors.grey.shade700,
                          size: 25,
                        ))),
              ],
            ),
          ),
          SizedBox(height: 8),
          Expanded(
              child: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child:
                          Icon(Icons.favorite, color: Colors.pink, size: 30)),
                ),
                SizedBox(height: 30),
                Center(
                  child: FutureBuilder(
                    future: _initializeVideoPlayerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller));
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
                SizedBox(height: 20),
                Padding(padding: EdgeInsets.only(left: 40, right: 40)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    //Padding(padding: EdgeInsets.all(12)),

                    Icon(Icons.skip_previous, size: 30),
                    FloatingActionButton(
                        splashColor: Colors.deepOrangeAccent,
                        onPressed: () {
                          setState(() {
                            if (_controller.value.isPlaying) {
                              _controller.pause();
                            } else {
                              _controller.play();
                            }
                          });
                        },
                        child: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 40,
                          color: Colors.white,
                        )),
                    Icon(Icons.skip_next, size: 30),
                  ],
                ),
                SizedBox(height: 40),
                Padding(padding: EdgeInsets.only(left: 30, right: 30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Icon(Icons.share, size: 30),
                    Icon(Icons.search, size: 30),
                    Icon(Icons.music_note, size: 30),
                    Icon(Icons.fullscreen, size: 30),
                  ],
                ),
                SizedBox(height: 30),
                Padding(padding: EdgeInsets.only(left: 30, right: 30)),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      MaterialButton(
                        color: Colors.grey.shade300,
                        splashColor: Colors.deepOrangeAccent,
                        child: Text(
                          'My Mentor',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () => setState(() {
                          opacityLevel = 1.0;
                        }),
                      ),
                      AnimatedOpacity(
                        opacity: opacityLevel,
                        duration: Duration(seconds: 3),
                        child: Column(
                          children: <Widget>[
                            Text(
                              '',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurpleAccent),
                            ),
                            Text(
                              'Mr. Vimal Daga Sir',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                  color: Colors.redAccent),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }
}

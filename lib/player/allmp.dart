//import 'dart:html';

import 'dart:ui';

//import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:LinuxMusic/player/video.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';
import 'player/video.dart';

void main() => runApp(MyApp());

AnimationController _animationIconController1;

AudioCache audioCache;

AudioPlayer audioPlayer;

Duration _duration = new Duration();
Duration _position = new Duration();

bool issongplaying = false;

bool isplaying = false;

class path {
  static String filePath = 'sample';
}

class Constants {
  static const String Home = 'Home';
  static const String Video = 'Video Player';

  static const List<String> choices = <String>[Home, Video];
}

void seekToSeconds(int second) {
  Duration newDuration = Duration(seconds: second);
  audioPlayer.seek(newDuration);
}

Future<List<File>> asynce() async {
  return await FilePicker.getMultiFile();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Masti',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class VideoPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LinuxWorld',
      debugShowCheckedModeBanner: false,
      home: VideoPlayerScreen(),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({Key key}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    _controller = VideoPlayerController.asset('assets/Bom.mp4');

    _initializeVideoPlayerFuture = _controller.initialize();

    _controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

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
                        MaterialPageRoute(builder: (context) => MyApp()),
                      );
                    }),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.all(15)),
                    Text(
                      'Video Player',
                      style: TextStyle(
                          fontSize: 30,
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
                          path.filePath = await FilePicker.getFilePath();
                        },
                        child: Icon(
                          Icons.video_library_rounded,color: Colors.grey.shade700,
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
                SizedBox(height: 50),
                Center(
                  child: Card(
                    child: InkWell(
                      splashColor: Colors.deepOrangeAccent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OninePlayer()),
                        );
                      },
                      child: Container(
                        color: Colors.blueGrey.shade200,
                        width: 200,
                        height: 50,
                        child: Text(
                          'Go Online',
                          style: TextStyle(fontSize: 40),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    elevation: 15,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    initPlayer();
  }

  void initPlayer() {
    _animationIconController1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 750),
      reverseDuration: Duration(milliseconds: 750),
    );
    audioPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: audioPlayer);
    audioPlayer.durationHandler = (d) => setState(() {
          _duration = d;
        });
    audioPlayer.positionHandler = (p) => setState(() {
          _position = p;
        });
  }

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
                PopupMenuButton(
                    onSelected: choiceAction,
                    itemBuilder: (BuildContext context) {
                      return Constants.choices.map((String choice) {
                        return PopupMenuItem(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    }),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.all(15)),
                    Text(
                      '  Music Masti',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800),
                    ),
                    Text(''),
                    Text(
                      '  Now Playing',
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
                      path.filePath = await FilePicker.getFilePath();
                    },
                    child: Icon(
                      Icons.library_music,
                      color: Colors.grey.shade700,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.favorite,
                      color: Colors.pinkAccent,
                      size: 30,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Container(
                    width: 300,
                    height: 300,
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.transparent],
                          begin: Alignment.topCenter),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Card(
                      margin: EdgeInsets.all(6),
                      child: Image.network(
                        'https://raw.githubusercontent.com/alokkaintura/image/master/girl.jpg',
                        fit: BoxFit.cover,
                      ),
                      elevation: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    'LinuxWorld',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    '-mp3',
                    style: TextStyle(fontSize: 19, color: Colors.grey.shade600),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Slider(
                  activeColor: Colors.deepOrangeAccent,
                  inactiveColor: Colors.grey,
                  value: _position.inSeconds.toDouble(),
                  max: _duration.inSeconds.toDouble(),
                  onChanged: (double value) {
                    setState(() {
                      seekToSeconds(value.toInt());
                      value = value;
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(
                        Icons.skip_previous,
                        size: 40,
                      ),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            isplaying
                                ? _animationIconController1.reverse()
                                : _animationIconController1.forward();
                            isplaying = !isplaying;
                          });
                          if (issongplaying == false) {
                            //audioCache.play("viah.mp3");
                            audioPlayer.play(path.filePath, isLocal: true);
                            setState(() {
                              issongplaying = true;
                            });
                          } else {
                            audioPlayer.pause();
                            setState(() {
                              issongplaying = false;
                            });
                          }
                        },
                        child: ClipOval(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2.5,
                                color: Colors.deepOrangeAccent,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(50.0),
                              ),
                            ),
                            width: 75,
                            height: 75,
                            child: Center(
                              child: AnimatedIcon(
                                icon: AnimatedIcons.play_pause,
                                progress: _animationIconController1,
                                color: Colors.deepOrangeAccent,
                                size: 60,
                              ),
                            ),
                          ),
                        ),
                      ),

                      /*Container(
                        child: FloatingActionButton(
                          backgroundColor: Colors.redAccent,
                          child: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 50,
                          ),
                          onPressed: () => _handleOnPressed(),
                        ),
                      ),*/
                      Icon(
                        Icons.skip_next,
                        size: 40,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        Icons.repeat,
                        size: 25,
                      ),
                      Icon(
                        Icons.arrow_downward,
                        size: 25,
                      ),
                      Icon(
                        Icons.shuffle,
                        size: 25,
                      ),
                      Icon(
                        Icons.favorite_border,
                        size: 25,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }

  void choiceAction(String choice) {
    if (choice == Constants.Home) {
      print('Home');
    } else {
      if (choice == Constants.Video) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VideoPlayerApp()),
        );
      }
    }
  }
}

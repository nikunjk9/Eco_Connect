
import 'package:flutter/material.dart';
import 'package:specathon/screens/carbon_calculator.dart';
import 'package:specathon/screens/chat_screen.dart';
import 'package:specathon/screens/credits_Screen.dart';
import 'package:specathon/screens/login_screen.dart';
import 'package:specathon/screens/tips_screen.dart';
import 'package:video_player/video_player.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/vid.mp4')
      ..initialize().then((_) {
        print("Video initialized successfully");
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout Confirmation'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              style: TextButton.styleFrom(
                primary: Colors.brown, // Set the text color to brown
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              style: TextButton.styleFrom(
                primary: Colors.brown, // Set the text color to brown
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmailPasswordLogin(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Eco Connect Home',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false,
        leading: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
          Container(
            color: Colors.black.withOpacity(0.2),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // Customize button appearance
                _buildButton(
                  'Carbon Footprint Calculator',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CarbonFootprintCalculator(),
                      ),
                    );
                  },
                ),
                _buildButton(
                  'Community Group',
                  () {
                    Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => ChatScreen()),
                     );
                  },
                ),
                _buildButton(
                  'Tips Page',
                  () {
                    Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => CarbonFootprintTipsScreen()),
                     );
                  },
                ),
                _buildButton(
                  'Credits',
                  () {
                    Navigator.push(
                       context,
                       MaterialPageRoute(builder: (context) => CreditsPage()),
                     );               
                       },
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 50.0,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF4BAE6C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
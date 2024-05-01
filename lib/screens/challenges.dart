// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class ChallengeScreen extends StatefulWidget {
  @override
  _ChallengeScreenState createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  int coins = 0;
  int timeRemaining = 0;
  bool isChallengeActive = false;
  double totalDistanceWalked = 0.0; // Initialize total distance to 0
  SharedPreferences? preferences;
  User? user = _auth.currentUser;
  bool startButtonVisible = true;

  @override
  void initState() {
    super.initState();
    initializePreferences();
  }

  void initializePreferences() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      coins = 0; 
    });
  }

  void startChallenge() {
    setState(() {
      isChallengeActive = true;
      timeRemaining = 30 * 60; 
      totalDistanceWalked = 0.0; 
      startButtonVisible = false; 
    });
    // Countdown timer
    startCountdownTimer();
    startLocationTracking();
  }

  void startCountdownTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeRemaining <= 0) {
        timer.cancel();
        if (totalDistanceWalked >= 1.0) {
          // Challenge completed
          completeChallenge();
        } else {
          // Challenge failed
          failChallenge();
          setState(() {
            startButtonVisible = true; 
          });
        }
      } else {
        setState(() {
          timeRemaining--;
        });
      }
    });
  }

void startLocationTracking() {
  Geolocator.getPositionStream(
    desiredAccuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 10, // 10 meters
  ).listen((Position position) {
    // Calculate distance walked
    if (position != null) {
      totalDistanceWalked += position.speed * 0.06; 

      if (totalDistanceWalked >= 1000.0) {
        coins += 50;
        preferences?.setInt('coins', coins);
        setState(() {});
      }
      setState(() {});
    }
  });
}

  void completeChallenge() {
    setState(() {
      isChallengeActive = false;
    });
    if (timeRemaining >= 0) {
      // User completed the challenge within the time limit
      coins += 50;
      preferences?.setInt('coins', coins);
      // Update user's coins and distance walked in Firestore
      if (user != null) {
        _firestore.collection('challenge_progress').doc(user!.uid).set({
          'coins': coins,
          'totalDistanceWalked': totalDistanceWalked,
        }, SetOptions(merge: true));
      }
    }
  }

  void failChallenge() {
    setState(() {
      isChallengeActive = false;
    });
    // Handle challenge failure logic, e.g., show a popup
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Challenge Failed"),
          content: Text("You did not complete the challenge in time. Better Luck Next Time."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
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
        leading: null,
        title: Text(
          'Walking Challenge',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children:[
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/coin.png',
                      width: 32,
                      height: 32,
                    ),
                  ),
                ),
                SizedBox(width: 4),
                Text(coins.toString(), style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/bg_cal.jpg', // Replace with your image path
            fit: BoxFit.cover,
          ),
          Column(
            children: [
              Card(
                color: Colors.brown, // Change card color to brown
                elevation: 5,
                margin: EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Goal: Walk 1 kilometer in 30 minutes or less.",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Reward: 50 coins",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Instructions:",
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "1. Find a safe and comfortable place to walk, such as a park, track, or treadmill.",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      Text(
                        "2. Keep track of your time and distance. You can use a fitness tracker, a phone app, or simply keep an eye on the clock and your surroundings.",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      Text(
                        "3. If you need to take a break, that's okay. Just start walking again as soon as you're ready.",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              if (isChallengeActive)
                Card(
                  color: Colors.brown, // Change card color to brown
                  elevation: 5,
                  margin: EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          "Time Remaining:",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        Text(
                          "${Duration(seconds: timeRemaining).toString().split('.').first}",
                          style: TextStyle(fontSize: 36, color: Colors.white),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Total Distance Walked:",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        Text(
                          "${totalDistanceWalked.toStringAsFixed(2)} meters",
                          style: TextStyle(fontSize: 36, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              Spacer(),
              if (startButtonVisible)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.brown, // Change button color to brown
                    ),
                    onPressed: startChallenge,
                    child: Text(
                      "Start Challenge",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }
}

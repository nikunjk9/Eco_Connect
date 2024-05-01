import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carbon Footprint Tips',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CarbonFootprintTipsScreen(),
    );
  }
}

class CarbonFootprintTipsScreen extends StatefulWidget {
  @override
  _CarbonFootprintTipsScreenState createState() =>
      _CarbonFootprintTipsScreenState();
}

class _CarbonFootprintTipsScreenState extends State<CarbonFootprintTipsScreen> {
  List<Tip> tips = [
    Tip(
      'Reduce your meat consumption:',
      'Eating less meat can help reduce greenhouse gas emissions from livestock and the production of animal feed.',
      'assets/tip_1.jpeg',
    ),
    Tip(
      'Use energy-efficient appliances:',
      'Switching to energy-efficient appliances can help reduce your electricity usage and carbon footprint.',
      'assets/tip_2.jpg',
    ),
    Tip(
      'Walk, bike, or take public transportation:',
      'Using alternative modes of transportation can help reduce your carbon footprint from driving.',
      'assets/tip_3.jpg',
    ),
    Tip(
      'Plant trees:',
      'Trees absorb carbon dioxide from the atmosphere and can help reduce greenhouse gas emissions.',
      'assets/tip_4.jpg',
    ),
    Tip(
      'Reduce your plastic usage:',
      'Plastics are made from fossil fuels and contribute to greenhouse gas emissions when they are produced and disposed of.',
      'assets/tip_5.jpg',
    ),
    Tip(
      'Use renewable energy sources:',
      'Switching to renewable energy sources like solar or wind power can help reduce your carbon footprint.',
      'assets/tip_6.png',
    ),
  ];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    shuffleTips(); // Shuffle the tips when the screen initializes.
  }

  void shuffleTips() {
    setState(() {
      tips.shuffle();
      currentIndex = 0;
    });
  }

  void showNextTips() {
    setState(() {
      currentIndex += 3;
      if (currentIndex >= tips.length) {
        // If we reach the end of the tips list, shuffle again.
        shuffleTips();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Tip> displayedTips = currentIndex < tips.length
        ? tips.sublist(currentIndex, min(currentIndex + 3, tips.length))
        : [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Carbon Footprint Tips',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bg_main.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              SizedBox(height: 20.0),
              Expanded(
                child: PageView.builder(
                  itemCount: displayedTips.length,
                  itemBuilder: (context, index) {
                    return TipCard(tip: displayedTips[index]);
                  },
                ),
              ),
              SizedBox(height: 15.0),
              ElevatedButton(
                onPressed: showNextTips,
                child: Text(
                  'Next Tips',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 15.0),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Remember, every small action counts towards reducing our carbon footprint and protecting the environment for future generations.',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TipCard extends StatelessWidget {
  final Tip tip;

  TipCard({required this.tip});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300, // Adjust the width as needed
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tip.title,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    tip.description,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
                child: Center(
                  child: Image.asset(
                    tip.imageSource, // Image source for the tip
                    fit: BoxFit.cover,
                    width: 300, // Adjust the width as needed
                    height: 200, // Adjust the height as needed
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Tip {
  final String title;
  final String description;
  final String imageSource;

  Tip(this.title, this.description, this.imageSource);
}

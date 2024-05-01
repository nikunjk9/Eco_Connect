import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Credits',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto', // Use a custom font
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_main.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center( 
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '‣ What is Carbon Footprint:',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(
                  'A carbon footprint is a measure of the total greenhouse gas emissions, primarily carbon dioxide (CO2), produced directly or indirectly by an individual, organization, event, or product throughout its lifecycle',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    launch('https://en.wikipedia.org/wiki/Carbon_footprint');
                  },
                  child: Text(
                    'Learn More',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Roboto', 
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '‣ Stats and Calculations:',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 8),
                buildGovernmentInfo(
                  name: 'Average carbon footprint of an Indian Individual',
                  websiteURL:
                      'https://www.statista.com/statistics/606019/co2-emissions-india/#:~:text=Per%20capita%20carbon%20dioxide%20(CO₂,in%20comparison%20to%202021%20levels.',
                ),
                SizedBox(height: 8),
                buildGovernmentInfo(
                  name: 'The Enviornment Equation',
                  websiteURL:
                      'https://www.google.co.in/books/edition/_/i8BGOgAACAAJ?hl=en',
                ),
                SizedBox(height: 16),
                Text(
                  '‣ Know more about developers:',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 8),
                buildDeveloperInfo(
                  name: 'Kapil Kukreja',
                  portfolioURL: 'https://kapilkukreja.netlify.app',
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDeveloperInfo({required String name, required String portfolioURL}) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          launch(portfolioURL);
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            name,
            style: TextStyle(
              fontSize: 18,
              color: Colors.green,
              decoration: TextDecoration.underline,
              fontFamily: 'Roboto', // Use a custom font
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGovernmentInfo({required String name, required String websiteURL}) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          launch(websiteURL);
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            name,
            style: TextStyle(
              fontSize: 18,
              color: Colors.green,
              decoration: TextDecoration.underline,
              fontFamily: 'Roboto', 
            ),
          ),
        ),
      ),
    );
  }
}

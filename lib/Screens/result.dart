import 'package:biblioteca/Screens/home.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background Image
          Image.asset(
            'assets/background.png', // Replace with your desired background image
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.white.withOpacity(0.7), // set opacity here
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
                height: 500,
                width: 400, // Set the desired height of the Card widget
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0), // Set the rounded corner radius
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/CN.PNG',
                          height: 100, // Set the height of the logo image
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Computer Networks', // Replace with your desired text
                          style: TextStyle(fontSize: 22.0),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Tanenbaum, Andrew S', // Replace with your desired text
                          style: TextStyle(fontSize: 22.0),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Master of computer applications', // Replace with your desired text
                          style: TextStyle(fontSize: 22.0),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Shelf Number : 2', // Replace with your desired text
                          style: TextStyle(fontSize: 22.0),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Row Number : 2', // Replace with your desired text
                          style: TextStyle(fontSize: 22.0),
                        ),
                        const SizedBox(height: 16),
                        InkWell(
  onTap: () => launchUrl(Uri.parse('https://www.google.com')),
  child: const Text(
    'Open AR View',
    style: TextStyle(decoration: TextDecoration.underline,fontSize: 22.0, color: Colors.blue),
  ),
),
const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                             Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
                          },
                          child: const Text('Go Back'), // Replace with your desired button label
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:biblioteca/Screens/qr.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:biblioteca/Screens/result.dart';

import 'login.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _authorController = TextEditingController();
  TextEditingController _editionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
         _logout();
        },
        label: const Text('Log Out'),
        icon: const Icon(Icons.account_circle_outlined),
      ),
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
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.white.withOpacity(0.7), // set opacity here
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Wrap(
                alignment: WrapAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(16.0),
                  child: Image.asset(
                'assets/logo.png',
                height: 100, // Set the height of the logo image
              ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: "Title of the Book",
                        focusedBorder: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: _authorController,
                      decoration: const InputDecoration(
                        labelText: "Author",
                        focusedBorder: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: _editionController,
                      decoration: const InputDecoration(
                        labelText: "Edition",
                        focusedBorder: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(140, 50),
                    ),
                    onPressed: () {
                       Navigator.push(context,
                MaterialPageRoute(builder: (context) => ResultPage()));
                    },
                    child: const Text('Search'),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(140, 50),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                MaterialPageRoute(builder: (context) => ScanPage()));
                    },
                    child: const Text('Scan'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('password');

    FirebaseAuth.instance.signOut();

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => SignInPage()));
  }
}

import 'dart:ui';

import 'package:biblioteca/Screens/qr.dart';
import 'package:biblioteca/Screens/userlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_apps/device_apps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String author = '';
  String name = '';
  String edition = '';
  String ebookLink = '';

  Future<void> searchBooks() async {
    CollectionReference booksRef =
        FirebaseFirestore.instance.collection('books');
    QuerySnapshot querySnapshot =
        await booksRef.where('name', isEqualTo: name).get();

    if (querySnapshot.docs.isNotEmpty) {
      var docData = querySnapshot.docs[0].data()
          as Map<String, dynamic>?; // Explicit casting
      if (docData != null) {
        ebookLink = docData['ebook_link'];
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              backgroundColor: Colors.white.withOpacity(0.7),
              title: Center(child: Text('Book Details')),
              content: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        docData['image'],
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            );
                          }
                        },
                      ),
                      TextButton(
                        onPressed: () async {
                          // Check if the URL is not null or empty
                          if (ebookLink != null && ebookLink.isNotEmpty) {
                            print('$ebookLink');
                            launchUrl(Uri.parse('$ebookLink'));
                          }
                        },
                        child: const Text('Download eBook'),
                      ),
                      SizedBox(height: 1),
                      Text('Author: ${docData['author']}'),
                      SizedBox(height: 1),
                      Text('Title: ${docData['name']}'),
                      SizedBox(height: 1),
                      Text('Edition: ${docData['edition']}'),
                      SizedBox(height: 1),
                      Text('Department: ${docData['department']}'),
                      SizedBox(height: 1),
                      Text('Shelf: ${docData['shelf_no']}'),
                      SizedBox(height: 1),
                      Text('Row: ${docData['row_no']}'),
                      SizedBox(height: 1),
                      Text('Column: ${docData['col_no']}'),
                      SizedBox(height: 1),
                      Text('Available: ${docData['is_available']}'),
                      SizedBox(height: 1),
                      docData['is_available'] == 'No'
                          ? Text(
                              'Date of Return: ${docData['not_available_date']}')
                          : SizedBox.shrink(),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  ///checks if the app is installed on your mobile device
                                  bool isInstalled =
                                      await DeviceApps.isAppInstalled(
                                          'com.silver.s2');
                                  if (isInstalled) {
                                    DeviceApps.openApp("com.silver.s2");
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: const Icon(Icons.view_in_ar),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                try {
                                  ///checks if the app is installed on your mobile device
                                  bool isInstalled =
                                      await DeviceApps.isAppInstalled(
                                          'com.alex.alex');
                                  if (isInstalled) {
                                    DeviceApps.openApp("com.alex.alex");
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              },
                              child: const Icon(Icons.view_in_ar_sharp),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        print('No matching documents found.');
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('No Matching Books'),
            content: Text('No books found with the specified criteria.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

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
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: "Title of the Book",
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
                      searchBooks();
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
                          MaterialPageRoute(builder: (context) => ListPage()));
                    },
                    child: const Text('List Books'),
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

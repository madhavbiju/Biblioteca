import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login.dart';
import 'bottomnav.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  String ebookLink = '';
  String? date;
  final TextEditingController _dateTimeController = TextEditingController();
  final CollectionReference booksCollection =
      FirebaseFirestore.instance.collection('books');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        centerTitle: true,
        title: InkWell(
          onTap: () {},
          child: const Text(
            'Books',
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
            ),
            tooltip: 'Logout',
            onPressed: () {
              _logout();
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: const BottomNav(selectedIndex: 0),
      body: StreamBuilder<QuerySnapshot>(
        stream: booksCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['name']),
                subtitle: Text('${data['author']} - ${data['department']}'),
                onTap: () {
                  ebookLink = data['ebook_link'];
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Center(child: Text('Book Details')),
                        content: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  data['image'],
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(height: 20),
                                Text('Author: ${data['author']}'),
                                const SizedBox(height: 5),
                                Text('Title: ${data['name']}'),
                                const SizedBox(height: 5),
                                Text('Edition: ${data['edition']}'),
                                const SizedBox(height: 5),
                                Text('Department: ${data['department']}'),
                                const SizedBox(height: 5),
                                Text('Shelf: ${data['shelf_no']}'),
                                const SizedBox(height: 5),
                                Text('Row: ${data['row_no']}'),
                                const SizedBox(height: 5),
                                Text('Column: ${data['col_no']}'),
                                const SizedBox(height: 5),
                                Text('Available: ${data['is_available']}'),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: Text(data['is_available'] == 'Yes'
                                ? 'Make Not Available'
                                : 'Make Available'),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              String newAvailability =
                                  data['is_available'] == 'Yes' ? 'No' : 'Yes';
                              if (newAvailability == 'No') {
                                // Show a dialog to enter the date
                                date = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Enter Details'),
                                    content: TextFormField(
                                      controller: _dateTimeController,
                                      autofocus: true,
                                      decoration: const InputDecoration(
                                        labelText: 'Date',
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('CANCEL'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () async {
                                          await booksCollection
                                              .doc(document.id)
                                              .update({
                                            'is_available': newAvailability,
                                            'not_available_date':
                                                _dateTimeController.text,
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                                if (date != null) {
                                  // Update the document with the new availability and date
                                  await booksCollection
                                      .doc(document.id)
                                      .update({
                                    'is_available': newAvailability,
                                    'not_available_date': _dateTimeController,
                                  });
                                }
                              } else {
                                // Update the document with the new availability only
                                await booksCollection
                                    .doc(document.id)
                                    .update({'is_available': newAvailability});
                              }
                            },
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                await FirebaseFirestore.instance
                                    .collection('books')
                                    .doc(document.id)
                                    .delete();
                                Navigator.of(context).pop();
                              } catch (e) {
                                // Handle any errors that occur during the delete operation
                                print('Error deleting document: $e');
                              }
                            },
                            child: const Text('Delete'),
                          )
                        ],
                      );
                    },
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('password');

    FirebaseAuth.instance.signOut();

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignInPage()));
  }
}

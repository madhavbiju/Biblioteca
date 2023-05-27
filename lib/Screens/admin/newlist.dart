import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login.dart';
import 'bottomnav.dart';
import 'edit.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];
  final String myVariable = "Hello, World!";
  List _allResults = [];
  String ebookLink = '';
  String? date;
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _borrowerController = TextEditingController();

  List data = [];

  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  _onSearchChanged() {
    print(_searchController.text);
    searchResultList();
  }

  searchResultList() {
    var showResults = [];
    if (_searchController.text != "") {
      for (var clientSnapShot in _allResults) {
        var name = clientSnapShot['name'].toString().toLowerCase();
        if (name.contains(_searchController.text.toLowerCase())) {
          showResults.add(clientSnapShot);
        }
        var author = clientSnapShot['author'].toString().toLowerCase();
        if (author.contains(_searchController.text.toLowerCase())) {
          showResults.add(clientSnapShot);
        }
        var department = clientSnapShot['department'].toString().toLowerCase();
        if (department.contains(_searchController.text.toLowerCase())) {
          showResults.add(clientSnapShot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      data = showResults;
    });
  }

  getClientStream() async {
    var data = await FirebaseFirestore.instance
        .collection('books')
        .orderBy('name')
        .get();
    setState(() {
      _allResults = data.docs;
    });
    searchResultList();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getClientStream();
    super.didChangeDependencies();
  }

  bool isValidEmail(String email) {
    // Regular expression pattern for email validation
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
    );
    return emailRegex.hasMatch(email);
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('password');

    FirebaseAuth.instance.signOut();

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignInPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        elevation: 4,
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
            icon: Icon(Icons.search, color: Colors.white),
          ),
          onChanged: (value) {
            _onSearchChanged();
          },
        ),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: const BottomNav(selectedIndex: 0),
      body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                ebookLink = data[index]['ebook_link'];
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
                                data[index]['image'],
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
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
                              Text('Author: ${data[index]['author']}'),
                              const SizedBox(height: 5),
                              Text('Title: ${data[index]['name']}'),
                              const SizedBox(height: 5),
                              Text('Edition: ${data[index]['edition']}'),
                              const SizedBox(height: 5),
                              Text('Department: ${data[index]['department']}'),
                              const SizedBox(height: 5),
                              Text('Shelf: ${data[index]['shelf_no']}'),
                              const SizedBox(height: 5),
                              Text('Row: ${data[index]['row_no']}'),
                              const SizedBox(height: 5),
                              Text('Column: ${data[index]['col_no']}'),
                              const SizedBox(height: 5),
                              Text('Available: ${data[index]['is_available']}'),
                              const SizedBox(height: 5),
                              data[index]['is_available'] == 'No'
                                  ? Text(
                                      'Date of Return: ${data[index]['not_available_date']}\n\nBorrower Name: ${data[index]['user']}\n\nBorrower Email: ${data[index]['email']}\n\nBorrower Role: ${data[index]['borrower']}')
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          child: Text(data[index]['is_available'] == 'Yes'
                              ? 'Make Not Available'
                              : 'Make Available'),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            String newAvailability =
                                data[index]['is_available'] == 'Yes'
                                    ? 'No'
                                    : 'Yes';
                            if (newAvailability == 'No') {
                              // Show a dialog to enter the date
                              date = await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Enter Details'),
                                  content: Column(
                                    children: [
                                      Form(
                                        key: formKeys[0],
                                        child: TextFormField(
                                          controller: _dateTimeController,
                                          decoration: const InputDecoration(
                                            labelText: 'Date',
                                            suffixIcon:
                                                Icon(Icons.calendar_today),
                                          ),
                                          onTap: () async {
                                            DateTime? selectedDate =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1900),
                                              lastDate: DateTime(2100),
                                            );
                                            if (selectedDate != null) {
                                              _dateTimeController.text =
                                                  DateFormat('dd-MM-yyyy')
                                                      .format(selectedDate);
                                            }
                                          },
                                        ),
                                      ),
                                      Form(
                                        key: formKeys[1],
                                        child: TextFormField(
                                          controller: _userNameController,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(
                                                    r'[a-zA-Z]')), // Only alphabets allowed
                                          ],
                                          decoration: const InputDecoration(
                                            labelText: 'User Name',
                                            // Add any desired decoration or styling properties
                                          ),
                                        ),
                                      ),
                                      Form(
                                        key: formKeys[2],
                                        child: TextFormField(
                                          controller: _emailController,
                                          decoration: const InputDecoration(
                                            labelText: 'Mail Id',
                                            // Add any desired decoration or styling properties
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter an email';
                                            }
                                            if (!isValidEmail(value!)) {
                                              return 'Please enter a valid email';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Form(
                                        key: formKeys[3],
                                        child: TextFormField(
                                          controller: _departmentController,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(
                                                    r'[a-zA-Z]')), // Only alphabets allowed
                                          ],
                                          decoration: const InputDecoration(
                                            labelText: 'Department',
                                            // Add any desired decoration or styling properties
                                          ),
                                        ),
                                      ),
                                      Form(
                                        key: formKeys[4],
                                        child: TextFormField(
                                          controller: _borrowerController,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(
                                                    r'[a-zA-Z]')), // Only alphabets allowed
                                          ],
                                          decoration: const InputDecoration(
                                            labelText:
                                                'Borrower - Student/Staff',
                                            hintText: 'Student/Staff',
                                            // Add any desired decoration or styling properties
                                          ),
                                        ),
                                      ),
                                    ],
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
                                        if ((formKeys[0].currentState!.validate()) &&
                                            (formKeys[1]
                                                .currentState!
                                                .validate()) &&
                                            (formKeys[2]
                                                .currentState!
                                                .validate()) &&
                                            (formKeys[3]
                                                .currentState!
                                                .validate()) &&
                                            (formKeys[4]
                                                .currentState!
                                                .validate())) {
                                          await FirebaseFirestore.instance
                                              .collection('books')
                                              .doc(data[index].id)
                                              .update({
                                            'is_available': newAvailability,
                                            'not_available_date':
                                                _dateTimeController.text,
                                            'user': _userNameController.text,
                                            'email': _emailController.text,
                                            'userdept':
                                                _departmentController.text,
                                            'borrower': _borrowerController.text
                                          });

                                          Navigator.of(context).pop();
                                        }
                                        ;
                                      },
                                    ),
                                  ],
                                ),
                              );
                              if (date != null) {
                                // Update the document with the new availability and date
                                await FirebaseFirestore.instance
                                    .doc(data[index])
                                    .update({
                                  'is_available': newAvailability,
                                  'not_available_date': _dateTimeController,
                                });
                              }
                            } else {
                              // Update the document with the new availability only
                              await FirebaseFirestore.instance
                                  .collection('books')
                                  .doc(data[index].id)
                                  .update({'is_available': newAvailability});
                            }
                          },
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditPage(myVariable: data[index].id),
                              ),
                            );
                          },
                          child: const Text('Edit'),
                        )
                      ],
                    );
                  },
                );
              },
              child: ListTile(
                title: Text(
                  data[index]['name'],
                ),
                subtitle: Text(
                  data[index]['author'],
                ),
                trailing: Text(
                  data[index]['department'],
                ),
              ),
            );
          }),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'bottomnav.dart';
import 'edit.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final String myVariable = "Hello, World!";
  List _allResults = [];
  String ebookLink = '';
  String? date;
  TextEditingController _dateTimeController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _departmentController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
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
      bottomNavigationBar: BottomNav(selectedIndex: 0),
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
                      title: Center(child: Text('Book Details')),
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
                              SizedBox(height: 20),
                              Text('Author: ${data[index]['author']}'),
                              SizedBox(height: 5),
                              Text('Title: ${data[index]['name']}'),
                              SizedBox(height: 5),
                              Text('Edition: ${data[index]['edition']}'),
                              SizedBox(height: 5),
                              Text('Department: ${data[index]['department']}'),
                              SizedBox(height: 5),
                              Text('Shelf: ${data[index]['shelf_no']}'),
                              SizedBox(height: 5),
                              Text('Row: ${data[index]['row_no']}'),
                              SizedBox(height: 5),
                              Text('Column: ${data[index]['col_no']}'),
                              SizedBox(height: 5),
                              Text('Available: ${data[index]['is_available']}'),
                              SizedBox(height: 5),
                              data[index]['is_available'] == 'No'
                                  ? Text(
                                      'Date of Return: ${data[index]['not_available_date']}')
                                  : SizedBox.shrink(),
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
                                  title: Text('Enter Return Date'),
                                  content: Column(
                                    children: [
                                      TextFormField(
                                        controller: _dateTimeController,
                                        decoration: InputDecoration(
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
                                      TextFormField(
                                        controller: _userNameController,
                                        decoration: InputDecoration(
                                          labelText: 'User Name',
                                          // Add any desired decoration or styling properties
                                        ),
                                      ),
                                      TextFormField(
                                        controller: _emailController,
                                        decoration: InputDecoration(
                                          labelText: 'Mail Id',
                                          // Add any desired decoration or styling properties
                                        ),
                                      ),
                                      TextFormField(
                                        controller: _departmentController,
                                        decoration: InputDecoration(
                                          labelText: 'Department',
                                          // Add any desired decoration or styling properties
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('CANCEL'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () async {
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
                                        });

                                        Navigator.of(context).pop();
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
                          child: Text('Edit'),
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

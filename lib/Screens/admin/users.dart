import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login.dart';
import 'bottomnav.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final String myVariable = "Hello, World!";
  List _allResults = [];
  String ebookLink = '';
  String? date;
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _userfirstNameController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
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
        var firstName = clientSnapShot['firstName'].toString().toLowerCase();
        if (firstName.contains(_searchController.text.toLowerCase())) {
          showResults.add(clientSnapShot);
        }
        var email = clientSnapShot['email'].toString().toLowerCase();
        if (email.contains(_searchController.text.toLowerCase())) {
          showResults.add(clientSnapShot);
        }

        var sname = clientSnapShot['secondName'].toString().toLowerCase();
        if (sname.contains(_searchController.text.toLowerCase())) {
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
        .collection('users')
        .orderBy('firstName')
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
      bottomNavigationBar: const BottomNav(selectedIndex: 2),
      body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: ListTile(
                title: Text(
                  data[index]['firstName'] + ' ' + data[index]['secondName'],
                ),
                subtitle: Text(
                  data[index]['email'],
                ),
              ),
            );
          }),
    );
  }
}

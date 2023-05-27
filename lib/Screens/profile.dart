import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:biblioteca/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:biblioteca/Screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? email;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    _fetchEmail();
    if (loggedInUser.firstName == null && loggedInUser.secondName == null) {
      loggedInUser.firstName = '';
      loggedInUser.secondName = '';
    }
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  void _fetchEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = (prefs.getString('email') ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Hi, ${loggedInUser.firstName} ${loggedInUser.secondName}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text("$email",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  )),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(150, 50),
                ),
                onPressed: () {
                  _logout();
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('password');

    FirebaseAuth.instance.signOut();

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => const SignInPage()));
  }
}

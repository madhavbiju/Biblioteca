import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:biblioteca/Screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemindVerifyPage extends StatefulWidget {
  const RemindVerifyPage({super.key});

  @override
  _RemindVerifyPageState createState() => _RemindVerifyPageState();
}

class _RemindVerifyPageState extends State<RemindVerifyPage> {
  String? email;

  @override
  void initState() {
    super.initState();
    _fetchEmail();
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Please verify the mail sent to $email to use the App",
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
                child: const Text('Back to Login'),
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

import 'package:biblioteca/Screens/admin/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:biblioteca/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:biblioteca/Screens/remindv.dart';
import 'package:biblioteca/Screens/home.dart';

class VerifyCheckPage extends StatefulWidget {
  const VerifyCheckPage({super.key});

  @override
  _VerifyCheckPageState createState() => _VerifyCheckPageState();
}

class _VerifyCheckPageState extends State<VerifyCheckPage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    pullData();
  }

  Future<void> decidePage() async {
    print("Hello2${loggedInUser.isVerified}");
    if (loggedInUser.isVerified == true) {
      setState(() {
        _isLoading = true;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('userid',user!.uid );
      if (loggedInUser.admin == true) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const AdminPage()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()));
      }
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const RemindVerifyPage()));
    }
  }

  void pullData() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      print("Hello1${loggedInUser.isVerified}");
      decidePage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

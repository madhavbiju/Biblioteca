import 'package:biblioteca/Screens/admin/users.dart';
import 'package:flutter/material.dart';
import 'package:biblioteca/Screens/admin/newlist.dart';
import 'package:biblioteca/Screens/admin/home.dart';

class BottomNav extends StatelessWidget {
  final int selectedIndex;
  BottomNav({this.selectedIndex = 0});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      animationDuration: const Duration(seconds: 1),
      selectedIndex: selectedIndex,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.list),
          icon: Icon(Icons.list_outlined),
          label: 'Books',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.add),
          icon: Icon(Icons.add_outlined),
          label: 'Add a Book',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.account_box_outlined),
          icon: Icon(Icons.account_box_outlined),
          label: 'Users',
        ),
      ],
      onDestinationSelected: (int index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => SearchPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => AdminPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => UserPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
            break;
        }
      },
    );
  }
}

import 'package:code_glamour/Views/Items/Display.dart';
import 'package:code_glamour/Views/Items/FashionNews.dart';
import 'package:code_glamour/Views/Profile/Profile.dart';
import 'package:code_glamour/constants.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Widget> bodyPages = [Profile(), Display(), NewsPage()];
  int _index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _index,
          selectedItemColor: clr1,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_rounded),
                label: "Your Profile"),
            BottomNavigationBarItem(
                icon: Icon(Icons.image_rounded), label: "Exhibits"),
            BottomNavigationBarItem(
                icon: Icon(Icons.newspaper_rounded), label: "News"),
          ],
          onTap: (int index) {
            setState(() {
              _index = index;
            });
          },
        ),
        body: Stack(
          children: [
            IndexedStack(
              index: _index,
              children: bodyPages,
            ),
          ],
        ));
  }
}

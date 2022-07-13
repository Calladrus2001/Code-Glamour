import 'package:code_glamour/Views/Items/chatbot.dart';
import 'package:code_glamour/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class Display extends StatefulWidget {
  const Display({Key? key}) : super(key: key);

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: clr1,
        child: Row(
          children: [
            SizedBox(width: 13),
            Icon(FontAwesomeIcons.robot),
          ],
        ),
        onPressed: () {
          Get.to(() => Chatbot());
        },
      ),
    );
  }
}

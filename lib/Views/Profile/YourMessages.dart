import 'package:code_glamour/constants.dart';
import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: "AddMessage",
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: clr1),
        onPressed: () {
          /// create a new chat with some email
        },
      ),
    );
  }
}

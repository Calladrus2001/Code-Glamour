import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_glamour/Views/Profile/Chat.dart';
import 'package:code_glamour/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  List<DocumentSnapshot> people = [];

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("Chats")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("With")
        .get()
        .then((QuerySnapshot snap) {
      snap.docs.forEach((doc) {
        setState(() {
          people.add(doc);
        });
      });
    });
    super.initState();
  }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.builder(
              itemCount: people.length,
              shrinkWrap: true,
              itemBuilder: (context, int index) {
                return GestureDetector(
                  child: Card(
                    child: ListTile(
                      title: Text(people[index]["With"].toString(),
                          style: TextStyle(color: clr1)),
                    ),
                  ),
                  onTap: () {
                    Get.to(() => ChatHome(), arguments: people[index]["With"]);
                  },
                );
              }),
        ),
      ),
    );
  }
}

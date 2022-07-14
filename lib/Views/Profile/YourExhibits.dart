import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_glamour/Views/Profile/AddExhibit.dart';
import 'package:code_glamour/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class YourExhibits extends StatefulWidget {
  const YourExhibits({Key? key}) : super(key: key);

  @override
  State<YourExhibits> createState() => _YourExhibitsState();
}

class _YourExhibitsState extends State<YourExhibits> {
  List<DocumentSnapshot> snaps = [];

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('Exhibits')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc["CreatedBy"] == FirebaseAuth.instance.currentUser!.email) {
          setState(() {
            snaps.add(doc);
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: clr1),
        onPressed: () {
          Get.to(() => AddExhibit());
        },
      ),
      body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 6, mainAxisSpacing: 6),
          itemCount: snaps.length,
          itemBuilder: (context, int index) {
            return GridTile(
              child: Ink.image(
                image: NetworkImage(snaps[index]["imageUrl"]),
                fit: BoxFit.cover,
              ),
              footer: Container(
                  padding: EdgeInsets.only(left: 8, top: 2, bottom: 1),
                  color: Colors.grey.withOpacity(0.25),
                  child: Text(
                    snaps[index]["CreatedBy"],
                    style: TextStyle(color: Colors.white),
                  )),
            );
          }),
    );
  }
}

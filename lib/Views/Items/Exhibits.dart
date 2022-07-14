import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_glamour/Views/Items/chatbot.dart';
import 'package:code_glamour/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class Exhibit extends StatefulWidget {
  const Exhibit({Key? key}) : super(key: key);

  @override
  State<Exhibit> createState() => _ExhibitState();
}

class _ExhibitState extends State<Exhibit> {
  List<DocumentSnapshot> snaps = [];

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('Exhibits')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          snaps.add(doc);
        });
      });
    });
    super.initState();
  }

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
      body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 6, mainAxisSpacing: 6),
          itemCount: snaps.length,
          itemBuilder: (context, int index) {
            return GestureDetector(
              child: GridTile(
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
              ),
              onTap: () {
                /// lead to specific gridTile page
              },
            );
          }),
    );
  }
}

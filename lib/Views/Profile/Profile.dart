import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_glamour/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isDesigner = false;
  List<dynamic> tags = [];
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot["Designer"] == true) {
        setState(() {
          isDesigner = true;
          tags = snapshot["tags"];
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            SizedBox(height: 40),
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  Chip(
                    backgroundColor: Colors.white,
                    elevation: 4.0,
                    label: Text(
                        FirebaseAuth.instance.currentUser!.email.toString(),
                        style: TextStyle(
                            color: clr1,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  ),
                  SizedBox(width: 8),
                  isDesigner
                      ? Chip(
                          elevation: 4.0,
                          backgroundColor: clr1,
                          label: Text("Designer",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16)))
                      : SizedBox()
                ],
              ),
            ),
            SizedBox(height: 10),
            isDesigner
                ? Row(
                    children: [
                      SizedBox(width: 6),
                      Text("Your tags: ", style: TextStyle(color: Colors.grey)),
                      Container(
                        height: 40,
                        width: 280,
                        child: ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: tags.length,
                            itemBuilder: (context, int index) {
                              return Row(
                                children: [
                                  Chip(
                                    label: Text(tags[index].toString(),
                                        style: TextStyle(color: clr1)),
                                    backgroundColor: Colors.white,
                                    elevation: 2.0,
                                  ),
                                  SizedBox(width: 4),
                                ],
                              );
                            }),
                      )
                    ],
                  )
                : SizedBox(),
            SizedBox(height: 30),
            GestureDetector(
              child: Card(
                child: ListTile(
                  title: Text(
                    "Your Messages",
                    style: TextStyle(color: clr1),
                  ),
                  trailing: Icon(Icons.keyboard_arrow_right, color: clr1),
                ),
              ),
              onTap: () {
                /// take to chat page
              },
            ),
            isDesigner ? SizedBox(height: 5) : SizedBox(),
            isDesigner
                ? GestureDetector(
                    child: Card(
                      child: ListTile(
                        title: Text(
                          "Your Exhibits",
                          style: TextStyle(color: clr1),
                        ),
                        trailing: Icon(Icons.keyboard_arrow_right, color: clr1),
                      ),
                    ),
                    onTap: () {
                      /// take to chat page
                    },
                  )
                : SizedBox(),
            SizedBox(height: 20),
            GestureDetector(
              child: CircleAvatar(
                backgroundColor: clr1,
                minRadius: 24.5,
                child: CircleAvatar(
                  minRadius: 23,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.logout, color: clr1),
                ),
              ),
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
            )
          ],
        ),
      ),
    );
  }
}

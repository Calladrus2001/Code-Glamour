import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_glamour/Views/Profile/Chat/video_join.dart';
import 'package:code_glamour/Widgets/ChatBubble.dart';
import 'package:code_glamour/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ChatHome extends StatefulWidget {
  const ChatHome({Key? key}) : super(key: key);

  @override
  State<ChatHome> createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  final messageController = new TextEditingController();
  bool isAvailable = false;
  String secondEmail = Get.arguments;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> journalStream = FirebaseFirestore.instance
      .collection('Chats')
      .doc(FirebaseAuth.instance.currentUser!.email)
      .collection("With")
      .doc(secondEmail)
      .collection("Chats")
      .orderBy("Time")
      .snapshots();

  late CollectionReference entries = FirebaseFirestore.instance
      .collection('Chats')
      .doc(FirebaseAuth.instance.currentUser!.email)
      .collection("With")
      .doc(secondEmail)
      .collection("Chats");

  late CollectionReference entries2 = FirebaseFirestore.instance
      .collection('Chats')
      .doc(secondEmail)
      .collection("With")
      .doc(FirebaseAuth.instance.currentUser!.email)
      .collection("Chats");

  @override
  void initState() {
    if (journalStream != null && entries != null) {
      setState(() {
        isAvailable = true;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.85,
              child: StreamBuilder(
                stream: journalStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (!snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(color: clr1));
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return ChatBubble()
                            .buildBubble(data["By"], data["Message"]);
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: Chip(
                    backgroundColor: Colors.white,
                    elevation: 4.0,
                    label: Icon(
                      Icons.videocam_outlined,
                      color: clr1,
                    ),
                  ),
                  onTap: () {
                    Get.to(() => IndexPage());
                  },
                ),
                SizedBox(width: 8),
                Chip(
                  elevation: 4.0,
                  backgroundColor: Colors.white,
                  label: Icon(
                    FontAwesomeIcons.userAstronaut,
                    size: 16,
                    color: clr1,
                  ),
                )
              ],
            ),
            Container(
              child: ListTile(
                title: Container(
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      color: Color(0xffF2F4F6),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: TextFormField(
                    controller: messageController,
                    decoration: InputDecoration(
                        hintText: "Send Message",
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none),
                    cursorColor: clr1,
                  ),
                ),
                trailing: GestureDetector(
                  child: Icon(Icons.send_outlined, color: clr1),
                  onTap: () {
                    setState(() {
                      entries
                          .add({
                            "Message": messageController.text,
                            "By": FirebaseAuth.instance.currentUser!.email,
                            "Time": Timestamp.now(),
                          })
                          .then((value) => print("Entry Added"))
                          .catchError(
                              (error) => print("Failed to add entry: $error"));
                      entries2
                          .add({
                            "Message": messageController.text,
                            "By": FirebaseAuth.instance.currentUser!.email,
                            "Time": Timestamp.now(),
                          })
                          .then((value) => print("Entry Added"))
                          .catchError(
                              (error) => print("Failed to add entry: $error"));
                    });
                    messageController.text = "";
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

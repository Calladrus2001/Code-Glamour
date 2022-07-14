import 'package:code_glamour/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddExhibit extends StatefulWidget {
  const AddExhibit({Key? key}) : super(key: key);

  @override
  State<AddExhibit> createState() => _AddExhibitState();
}

class _AddExhibitState extends State<AddExhibit> {
  bool hasImage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            SizedBox(height: 80),
            GestureDetector(
              child: Center(
                child: Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                      color: clr1,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Icon(
                    Icons.add_photo_alternate_outlined,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
              onTap: () {
                /// pick image
              },
            ),
            SizedBox(height: 40),
            TextFormField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Enter description',
              ),
              onChanged: (value) {},
            ),
            SizedBox(height: 80),
            GestureDetector(
              child: Container(
                height: 55,
                width: double.infinity,
                child: Center(
                    child: Text(
                  "Add Exhibit",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                )),
                decoration: BoxDecoration(
                    color: clr1,
                    borderRadius: BorderRadius.all(Radius.circular(25))),
              ),
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_glamour/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AddExhibit extends StatefulWidget {
  const AddExhibit({Key? key}) : super(key: key);

  @override
  State<AddExhibit> createState() => _AddExhibitState();
}

class _AddExhibitState extends State<AddExhibit> {
  bool hasImage = false;
  bool imageUploaded = false;
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  final descController = new TextEditingController();
  late String downloadUrl;
  CollectionReference exhibit =
      FirebaseFirestore.instance.collection("Exhibits");

  @override
  void dispose() {
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
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
                    child: hasImage
                        ? Image.file(File(_image!.path), fit: BoxFit.fill)
                        : Icon(
                            Icons.add_photo_alternate_outlined,
                            color: Colors.white,
                            size: 32,
                          ),
                  ),
                ),
                onTap: () async {
                  XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    _image = image;
                    hasImage = true;
                  });
                },
              ),
              SizedBox(height: 10),
              imageUploaded
                  ? SizedBox()
                  : GestureDetector(
                      child: Chip(
                        elevation: 4.0,
                        backgroundColor: clr1,
                        label: Text("Upload image",
                            style: TextStyle(color: Colors.white)),
                      ),
                      onTap: () async {
                        final imageName = _image!.name;
                        final destination =
                            "${FirebaseAuth.instance.currentUser!.email}/${imageName}";
                        final ref = FirebaseStorage.instance.ref(destination);
                        UploadTask? task = ref.putFile(File(_image!.path));
                        task.then((res) async {
                          downloadUrl = await res.ref.getDownloadURL();
                          setState(() {
                            imageUploaded = true;
                          });
                        });
                      },
                    ),
              TextFormField(
                maxLines: 3,
                controller: descController,
                decoration: InputDecoration(
                  labelText: 'Enter description',
                ),
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
                onTap: () {
                  exhibit.add({
                    "CreatedBy": FirebaseAuth.instance.currentUser!.email,
                    "Time": Timestamp.now(),
                    "description": descController.text,
                    "imageUrl": downloadUrl
                  });
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

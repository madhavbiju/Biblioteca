import 'dart:io';
import 'package:biblioteca/Screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottomnav.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  File? _imageFile;
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _editionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rowController = TextEditingController();
  final TextEditingController _colController = TextEditingController();
  final TextEditingController _shelfController = TextEditingController();
  final TextEditingController _eBookController = TextEditingController();
  GlobalKey<FormState> key = GlobalKey();

  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('books');

  String imageUrl = '';
  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 4,
        centerTitle: true,
        title: const Text('Add a Book'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
            ),
            tooltip: 'Logout',
            onPressed: () {
              _logout();
            },
          ),
        ],
      ),
      bottomNavigationBar: const BottomNav(selectedIndex: 1),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () async {
          if (imageUrl.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please upload an image')));

            return;
          }

          if (key.currentState!.validate()) {
            if ((formKeys[0].currentState!.validate()) &&
                (formKeys[1].currentState!.validate()) &&
                (formKeys[2].currentState!.validate()) &&
                (formKeys[3].currentState!.validate()) &&
                (formKeys[4].currentState!.validate())) {
              Map<String, dynamic> dataToSend = {
                'author': _authorController.text,
                'department': _departmentController.text,
                'edition': _editionController.text,
                'image': imageUrl,
                'name': _nameController.text,
                'row_no': _rowController.text,
                'col_no': _colController.text,
                'shelf_no': _shelfController.text,
                'ebook_link': _eBookController.text,
                'is_available': "yes"
              };
              _reference.add(dataToSend);
            }
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const AdminPage()));
            Fluttertoast.showToast(
                msg: "Uploaded!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        },
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 1, 20, 1),
              child: Form(
                key: key,
                child: Column(
                  children: [
                    Form(
                        key: formKeys[0],
                        child: TextFormField(
                          controller: _authorController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z ]')), // Only alphabets allowed
                          ],
                          decoration: const InputDecoration(
                            labelText: "Author",
                          ),
                        )),
                    Form(
                      key: formKeys[1],
                      child: TextFormField(
                        controller: _departmentController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z ]')), // Only alphabets allowed
                        ],
                        decoration: const InputDecoration(
                          labelText: "Department",
                        ),
                      ),
                    ),
                    Form(
                        key: formKeys[2],
                        child: TextFormField(
                          controller: _editionController,
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly, // Only numeric characters allowed
                          ],
                          decoration: const InputDecoration(
                            labelText: "Edition",
                          ),
                        )),
                    Form(
                      key: formKeys[3],
                      child: TextFormField(
                        controller: _nameController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z ]')), // Only alphabets allowed
                        ],
                        decoration: const InputDecoration(
                          labelText: "Name",
                        ),
                      ),
                    ),
                    Form(
                      key: formKeys[4],
                      child: TextFormField(
                        controller: _rowController,
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly, // Only numeric characters allowed
                        ],
                        decoration: const InputDecoration(
                          labelText: "Row",
                        ),
                      ),
                    ),
                    Form(
                      key: formKeys[5],
                      child: TextFormField(
                        controller: _colController,
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly, // Only numeric characters allowed
                        ],
                        decoration: const InputDecoration(
                          labelText: "Column",
                        ),
                      ),
                    ),
                    Form(
                      key: formKeys[6],
                      child: TextFormField(
                        controller: _shelfController,
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly, // Only numeric characters allowed
                        ],
                        decoration: const InputDecoration(
                          labelText: "Shelf",
                        ),
                      ),
                    ),
                    Form(
                      key: formKeys[7],
                      child: TextFormField(
                        controller: _eBookController,
                        decoration: const InputDecoration(
                          labelText: "eBook Link",
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _imageFile != null
                          ? Image.file(
                              _imageFile!,
                              width: 150.0,
                              height: 150.0,
                              fit: BoxFit.cover,
                            )
                          : ElevatedButton(
                              child: const Text('Take a Photo'),
                              onPressed: () async {
                                ImagePicker imagePicker = ImagePicker();
                                XFile? file = await imagePicker.pickImage(
                                    source: ImageSource.camera);
                                print('${file?.path}');

                                if (file == null) return;
                                setState(() {
                                  _imageFile = File(file.path);
                                });

                                if (file == null) return;
//Import dart:core
                                String uniqueFileName = DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString();
                                Reference referenceRoot =
                                    FirebaseStorage.instance.ref();
                                Reference referenceDirImages =
                                    referenceRoot.child('images');

                                Reference referenceImageToUpload =
                                    referenceDirImages.child(
                                        '$uniqueFileName.jpg'); // Use unique filename for each image

                                try {
                                  await referenceImageToUpload
                                      .putFile(File(file.path));
                                  imageUrl = await referenceImageToUpload
                                      .getDownloadURL();
                                } catch (error) {}
                              },
                            ),
                    ),
                    Visibility(
                      visible: _imageFile == null,
                      child: ElevatedButton(
                        child: const Text('Upload a Photo'),
                        onPressed: () async {
                          ImagePicker imagePicker = ImagePicker();
                          XFile? file = await imagePicker.pickImage(
                              source: ImageSource.gallery);
                          print('${file?.path}');

                          if (file == null) return;
                          setState(() {
                            _imageFile = File(file.path);
                          });

                          if (file == null) return;
//Import dart:core
                          String uniqueFileName =
                              DateTime.now().millisecondsSinceEpoch.toString();
                          Reference referenceRoot =
                              FirebaseStorage.instance.ref();
                          Reference referenceDirImages =
                              referenceRoot.child('images');

                          Reference referenceImageToUpload =
                              referenceDirImages.child(
                                  '$uniqueFileName.jpg'); // Use unique filename for each image

                          try {
                            await referenceImageToUpload
                                .putFile(File(file.path));
                            imageUrl =
                                await referenceImageToUpload.getDownloadURL();
                          } catch (error) {}
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('password');

    FirebaseAuth.instance.signOut();

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignInPage()));
  }
}

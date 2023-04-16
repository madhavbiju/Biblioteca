import 'dart:io';
import 'package:biblioteca/Screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  File? _imageFile;
  TextEditingController _authorController = TextEditingController();
  TextEditingController _departmentController = TextEditingController();
  TextEditingController _editionController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _rowController = TextEditingController();
  TextEditingController _colController = TextEditingController();
  TextEditingController _shelfController = TextEditingController();

  GlobalKey<FormState> key = GlobalKey();

  CollectionReference _reference =
      FirebaseFirestore.instance.collection('books');

  String imageUrl = '';

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        centerTitle: true,
        title: Text('Admin'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
            ),
            tooltip: 'Logout',
            onPressed: () {
        _logout();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (imageUrl.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please upload an image')));

            return;
          }

          if (key.currentState!.validate()) {
            Map<String, dynamic> dataToSend = {
              'author': 'hi',
              'department': _departmentController.text,
              'edition': _editionController.text,
              'image': imageUrl,
              'name': _nameController.text,
              'row_no': _rowController.text,
              'col_no': _colController.text,
              'shelf_no': _shelfController.text,
            };
            _reference.add(dataToSend);
          }
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => AdminPage()));
        },
        label: const Text('Submit'),
        icon: const Icon(Icons.save),
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
                   Padding(
              padding: EdgeInsets.all(1.0),
              child: TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(
                  labelText: "Author",
                  
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(1.0),
              child: TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(
                  labelText: "Department",
                  
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(1.0),
              child: TextFormField(
                controller: _editionController,
                decoration: const InputDecoration(
                  labelText: "Edition",
                  
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(1.0),
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(1.0),
              child: TextFormField(
                controller: _rowController,
                decoration: const InputDecoration(
                  labelText: "Row",
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(1.0),
              child: TextFormField(
                controller: _colController,
                decoration: const InputDecoration(
                  labelText: "Column",
                  
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(1.0),
              child: TextFormField(
                controller: _shelfController,
                decoration: const InputDecoration(
                  labelText: "Shelf",
                  
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
                              child: Text('Take a Photo'),
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
                                    referenceDirImages.child('name');

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
                        child: Text('Upload a Photo'),
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
                              referenceDirImages.child('name');

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

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => SignInPage()));
  }

}

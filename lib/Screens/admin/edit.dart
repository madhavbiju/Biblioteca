import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditPage extends StatefulWidget {
  final String myVariable;

  const EditPage({Key? key, required this.myVariable}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _editionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rowController = TextEditingController();
  final TextEditingController _colController = TextEditingController();
  final TextEditingController _shelfController = TextEditingController();
  final TextEditingController _eBookController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Book'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('books')
            .doc(widget.myVariable)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          _authorController.text = snapshot.data!['author'];
          _authorController.text = snapshot.data!['author'];
          _departmentController.text = snapshot.data!['department'];
          _editionController.text = snapshot.data!['edition'];
          _nameController.text = snapshot.data!['name'];
          _rowController.text = snapshot.data!['row_no'];
          _colController.text = snapshot.data!['col_no'];
          _shelfController.text = snapshot.data!['shelf_no'];
          _eBookController.text = snapshot.data!['ebook_link'];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: TextFormField(
                      controller: _authorController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z ]')), // Only alphabets allowed
                      ],
                      decoration: const InputDecoration(
                        labelText: "Author",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
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
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: TextFormField(
                      controller: _editionController,
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly, // Only numeric characters allowed
                      ],
                      decoration: const InputDecoration(
                        labelText: "Edition",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(1.0),
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
                  Padding(
                    padding: const EdgeInsets.all(1.0),
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
                  Padding(
                    padding: const EdgeInsets.all(1.0),
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
                  Padding(
                    padding: const EdgeInsets.all(1.0),
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
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: TextFormField(
                      controller: _eBookController,
                      decoration: const InputDecoration(
                        labelText: "eBook Link",
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      deleteDocument(widget.myVariable);
                    },
                    child: const Text('Delete Book'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _updateBook();
                    },
                    child: const Text('Update Book'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void deleteDocument(String documentId) {
    FirebaseFirestore.instance
        .collection('books')
        .doc(documentId)
        .delete()
        .then((value) {
      print('Document with ID $documentId deleted');
    }).catchError((error) {
      print('Failed to delete document: $error');
    });
  }

  void _updateBook() {
    FirebaseFirestore.instance
        .collection('books')
        .doc(widget.myVariable)
        .update({
      'author': _authorController.text,
      'department': _departmentController.text,
      'edition': _editionController.text,
      'name': _nameController.text,
      'row_no': _rowController.text,
      'col_no': _colController.text,
      'shelf_no': _shelfController.text,
      'ebook_link': _eBookController.text,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book updated successfully')));
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    });
  }
}

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List _allResults = [];
  String ebookLink = '';
  String? date;
  final TextEditingController _dateTimeController = TextEditingController();
  List data = [];

  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  _onSearchChanged() {
    print(_searchController.text);
    searchResultList();
  }

  searchResultList() {
    var showResults = [];
    if (_searchController.text != "") {
      for (var clientSnapShot in _allResults) {
        var name = clientSnapShot['name'].toString().toLowerCase();
        if (name.contains(_searchController.text.toLowerCase())) {
          showResults.add(clientSnapShot);
        }
        var author = clientSnapShot['author'].toString().toLowerCase();
        if (author.contains(_searchController.text.toLowerCase())) {
          showResults.add(clientSnapShot);
        }
        var department = clientSnapShot['department'].toString().toLowerCase();
        if (department.contains(_searchController.text.toLowerCase())) {
          showResults.add(clientSnapShot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      data = showResults;
    });
  }

  getClientStream() async {
    var data = await FirebaseFirestore.instance
        .collection('books')
        .orderBy('name')
        .get();
    setState(() {
      _allResults = data.docs;
    });
    searchResultList();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getClientStream();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
            icon: Icon(Icons.search, color: Colors.white),
          ),
          onChanged: (value) {
            _onSearchChanged();
          },
        ),
      ),
      body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                ebookLink = data[index]['ebook_link'];
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Center(child: Text('Book Details')),
                      content: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                data[index]['image'],
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    );
                                  }
                                },
                              ),
                              TextButton(
                                onPressed: () async {
                                  // Check if the URL is not null or empty
                                  if (ebookLink.isNotEmpty) {
                                    print(ebookLink);
                                    launchUrl(Uri.parse(ebookLink));
                                  }
                                },
                                child: const Text('Download eBook'),
                              ),
                              const SizedBox(height: 1),
                              Text('Author: ${data[index]['author']}'),
                              const SizedBox(height: 1),
                              Text('Title: ${data[index]['name']}'),
                              const SizedBox(height: 1),
                              Text('Edition: ${data[index]['edition']}'),
                              const SizedBox(height: 1),
                              Text('Department: ${data[index]['department']}'),
                              const SizedBox(height: 1),
                              Text('Shelf: ${data[index]['shelf_no']}'),
                              const SizedBox(height: 1),
                              Text('Row: ${data[index]['row_no']}'),
                              const SizedBox(height: 1),
                              Text('Column: ${data[index]['col_no']}'),
                              const SizedBox(height: 1),
                              Text('Available: ${data[index]['is_available']}'),
                              const SizedBox(height: 1),
                              data[index]['is_available'] == 'No'
                                  ? Text(
                                      'Date of Return: ${data[index]['not_available_date']}')
                                  : const SizedBox.shrink(),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          ///checks if the app is installed on your mobile device
                                          bool isInstalled =
                                              await DeviceApps.isAppInstalled(
                                                  'com.silver.s2');
                                          if (isInstalled) {
                                            DeviceApps.openApp("com.silver.s2");
                                          }
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                      child: const Icon(Icons.view_in_ar),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          ///checks if the app is installed on your mobile device
                                          bool isInstalled =
                                              await DeviceApps.isAppInstalled(
                                                  'com.alex.alex');
                                          if (isInstalled) {
                                            DeviceApps.openApp("com.alex.alex");
                                          }
                                        } catch (e) {
                                          print(e);
                                        }
                                      },
                                      child: const Icon(Icons.view_in_ar_sharp),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'),
                        )
                      ],
                    );
                  },
                );
              },
              child: ListTile(
                title: Text(
                  data[index]['name'],
                ),
                subtitle: Text(
                  data[index]['author'],
                ),
                trailing: Text(
                  data[index]['department'],
                ),
              ),
            );
          }),
    );
  }
}

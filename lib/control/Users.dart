// ignore: file_names
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:models_tests_1/dataBase/firebase_DataBase.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  int count = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Users').get();
    if (mounted) {
      setState(() {
        count = querySnapshot.docs.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('قائمة المستخدمين'),
          actions: [
            Text("$count"),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: fetchData,
            ),
          ],
        ),
        body: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('Users').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text(
                      'حدث خطأ أثناء قراءة البيانات: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<Widget> userTiles = [];
                snapshot.data?.docs.forEach((DocumentSnapshot document) {
                  Map<String, dynamic> userData =
                      document.data() as Map<String, dynamic>;

                  String username = userData["name"];
                  String phoneNumber = userData['phone'];
                  String grade = userData['grade'];

                  userTiles.add(
                    ListTile(
                      title: Text(
                        username,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(phoneNumber),
                          Text(grade),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: SingleChildScrollView(
                                      child: AlertDialog(
                                        title: const Text(
                                          "حذف مستخدم",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        content: const Text(
                                          "هل أنت متأكد من أنك تريد حذف هذا المستخدم ",
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              await FireBase()
                                                  .deleteDataFromFirebase(
                                                'Users',
                                                document.id,
                                              );
                                              // ignore: use_build_context_synchronously
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              "حذف",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('إلغاء'))
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                });

                return Expanded(
                  child: ListView(
                    children: userTiles,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

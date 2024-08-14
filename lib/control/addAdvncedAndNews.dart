// ignore: file_names
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:models_tests_1/dataBase/firebase_DataBase.dart';

class StudentTipsFormScreen extends StatefulWidget {
  const StudentTipsFormScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StudentTipsFormScreenState createState() => _StudentTipsFormScreenState();
}

class _StudentTipsFormScreenState extends State<StudentTipsFormScreen> {
  final TextEditingController _tipsController = TextEditingController();
  final TextEditingController _newsTitleController = TextEditingController();
  final TextEditingController _newsContentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> readData() async {
    Map<String, dynamic> data =
        await FireBase().fetchDataFromFirebase11("tips");
    _tipsController.text = data['tip'];
  }

  @override
  void initState() {
    readData();
    super.initState();
  }

  void _addTip() async {
    String tip = _tipsController.text;
    await FireBase()
        .updateDataInFirebase('tips', "e2ZT7rDQKNtJCMRiYCD0", {'tip': tip});

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.maybeOf(context)
        ?.showSnackBar(const SnackBar(content: Text("تم التعديل")));
    // await _firestore.collection('tips').add({'tip': tip});
  }

  void _addNews() async {
    String title = _newsTitleController.text;
    String content = _newsContentController.text;
    await _firestore
        .collection('news')
        .add({'title': title, 'content': content});
    _newsTitleController.clear();
    _newsContentController.clear();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.maybeOf(context)
        ?.showSnackBar(const SnackBar(content: Text("تم إضافة خبر جديد")));
  }

  void _deleteNews(String newsId) async {
    showDialog(
        context: context,
        builder: (context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              child: AlertDialog(
                title: const Text(
                  "حذف الخبر",
                  style: TextStyle(color: Colors.red),
                ),
                content: const Text("هل أنت متأكد من أنك تريد حذف الخبر "),
                actions: [
                  ElevatedButton(
                      onPressed: () async {
                        await _firestore
                            .collection('news')
                            .doc(newsId)
                            .delete();
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      },
                      child: const Text("حذف")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("حذف")),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('نموذج إدخال البيانات'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min, // قمنا بإضافة هذا السطر
              children: [
                TextFormField(
                  controller: _tipsController,
                  maxLines: 7,
                  decoration: const InputDecoration(
                    labelText: 'نصائح الطلاب',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addTip,
                  child: const Text('حفظ النصيحة'),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _newsTitleController,
                  decoration: const InputDecoration(
                    labelText: 'عنوان الخبر',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _newsContentController,
                  maxLines: 7,
                  decoration: const InputDecoration(
                    labelText: 'الخبر',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addNews,
                  child: const Text('إضافة الخبر'),
                ),
                const SizedBox(height: 32),
                const Text(
                  'الأخبار المضافة:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('news').snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Text('جارٍ التحميل...');
                    }
                    List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: documents.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> news =
                            documents[index].data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text(news['title']),
                          subtitle: Text(news['content']),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteNews(documents[index].id),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

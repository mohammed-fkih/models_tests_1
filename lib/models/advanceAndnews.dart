// ignore: file_names
import 'package:flutter/material.dart';
import 'package:models_tests_1/dataBase/firebase_DataBase.dart';

class StudentTipsScreen extends StatefulWidget {
  const StudentTipsScreen({super.key});

  @override
  State<StudentTipsScreen> createState() => _StudentTipsScreenState();
}

class _StudentTipsScreenState extends State<StudentTipsScreen> {
  // ignore: non_constant_identifier_names
  String advece = "";

  List<Map<String, dynamic>> newsList = [];

  Future<void> fechData() async {
    newsList = await FireBase().fetchAllDataFromFirebase("news");
    setState(() {});
  }

  Future<void> readData() async {
    Map<String, dynamic> data =
        await FireBase().fetchDataFromFirebase11("tips");
    advece = data['tip'];
  }

  @override
  void initState() {
    fechData();
    readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: const Text(
            'نصائح وأخبار مهمة للطلاب',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Divider(thickness: 1),
                    ),
                    const SizedBox(height: 9),
                    const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'نصائح مهمة لطلاب العلم',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ]),
                    const SizedBox(height: 9),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Divider(thickness: 1),
                    ),
                    // const SizedBox(height: 16),
                    Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 7),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 160, 212, 207),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          advece,
                          style: const TextStyle(fontSize: 17),
                        ))
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Divider(thickness: 1),
            ),
            const SizedBox(height: 10),
            const Text(
              "أخبار مهمة للطلاب",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Divider(thickness: 1),
            ),
            // const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: newsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 167, 212, 208),
                    ),
                    margin: const EdgeInsets.all(2),
                    child: ListTile(
                      title: Text(
                        newsList[index]['title'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Text(
                        newsList[index]['content'],
                        style: const TextStyle(fontSize: 16),
                      ),
                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

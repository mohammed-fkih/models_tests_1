
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
//  import 'package:models_tests_1/dataBase/firebase_DataBase.dart';
import 'package:models_tests_1/models/advanceAndnews.dart';
import 'package:models_tests_1/models/home_models.dart';
 import 'package:models_tests_1/models/resulte.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final FirebaseDatabase database;
  List<Map<String, dynamic>> modesAnd = [];
  List<Map<String, dynamic>> option1List = [];
  List<Map<String, dynamic>> option2List = [];
  List<Map<String, dynamic>> option3List = [];
  final List<String> _ninth = [
    'القرأن',
    'التربية الاسلامية',
    "اللغة العربية",
    "اللغة الانجليزية",
    "العلوم",
    "الرياضيات",
    "الاجتماعيات"
  ];
  final List<String> _secondThired = [
    'القرأن',
    'التربية الاسلامية',
    "اللغة العربية",
    "اللغة الانجليزية",
    "التكامل والتفاضل",
    "الجبر والهندسة",
    "الأحياء ",
    'الفيزياء',
    "الكيمياء"
  ];

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp(); 
    readDataFromFirebase();// Initialize Firebase
    // fetchData();
    setState(() {
      
    });
  }

  Future<void> readDataFromFirebase() async {
  Map<String,dynamic>? data={};

  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('models').get();
  for (var doc in querySnapshot.docs) {
     data = doc.data() as Map<String, dynamic>?;
    modesAnd.add(data!);
  }
}

  Future<void> fetchData() async {
    // modesAnd = await FireBase().fetchAllDataFromFirebase('models');
    database = FirebaseDatabase.instance;
    // ignore: deprecated_member_use
    database.reference().child("models").onValue.listen((event) async {
      DataSnapshot snapshot = event.snapshot;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("modesAndData", snapshot.value.toString());

      setState(() {
        modesAnd = (snapshot.value as Map<dynamic, dynamic>)
            .values
            .cast<Map<String, dynamic>>()
            .toList();
      });
    }, onError: (Object? error) async {
      // If there is no internet connectivity, read the temporarily stored data from the local database
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? modesAndData = prefs.getString("modesAndData");
      if (modesAndData != null) {
        setState(() {
          modesAnd = (jsonDecode(modesAndData) as List<dynamic>)
              .cast<Map<String, dynamic>>();
        });
      } else {
        const snackBar = SnackBar(
          content: Text(
              'لايوجد أي بيانات في قاعدة بياناتك المؤقته يرجى الاتصال بالانترنت ليتم إظهار البيانات مرة أخرى'),
          duration: Duration(seconds: 5),
        );
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (modesAnd.isEmpty) {
    //   return const Center(
    //     child: CircularProgressIndicator(),
    //   );
    // } else {
      return Scaffold(
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            // backgroundColor: const Color.fromARGB(255, 198, 223, 220),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: ElevatedButton(
                      onPressed: () {
                        List<Map<String, dynamic>> option1List = [];
                        for (var element in modesAnd) {
                          if (element['option'] == 'الصف التاسع') {
                            option1List.add(element);
                          }
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeModels(
                              modelsList: option1List,
                              article: _ninth,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "نماذج الصف التاسع",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: ElevatedButton(
                      onPressed: () async {
                        List<Map<String, dynamic>> option2List = [];
                        for (var element in modesAnd) {
                          if (element['option'] == 'الصف الثالث الثانوي') {
                            option2List.add(element);
                          }
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeModels(
                              modelsList: option2List,
                              article: _secondThired,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "نماذج الصف الثالث الثانوي",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // FractionallySizedBox(
                  //   widthFactor: 0.8,
                  //   child: ElevatedButton(
                  //     onPressed: () {},
                  //     child: const Text(
                  //       "نماذج إختبارات القبول الجامعي",
                  //       style: TextStyle(fontSize: 18),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TestResultsScreen()),
                        );
                      },
                      child: const Text(
                        "قائمة نتائج الاختبارت",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.8,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StudentTipsScreen()),
                        );
                      },
                      child: const Text(
                        "نصائح وأخبار مهمة للطلاب",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),

                   
    
                ],
              ),
            ),
          ),
        ),
      );
    }
  }


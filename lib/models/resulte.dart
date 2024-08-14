import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestResultsScreen extends StatefulWidget {
  const TestResultsScreen({
    super.key,
  });

  @override
  _TestResultsScreenState createState() => _TestResultsScreenState();
}

class _TestResultsScreenState extends State<TestResultsScreen> {
  String name = '';
  String phone = '';
  double totalPercentage = 0.0;
  int totalTests = 0;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? '';
      phone = prefs.getString('phone') ?? '';
    });
  }

  Future<void> calculateTotalPercentage() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('results')
        .where('userName', isEqualTo: name)
        .where('userPhone', isEqualTo: phone)
        .get();

    double totalPercentageSum = 0.0;
    int totalTestsCount = snapshot.docs.length;

    for (var testResult in snapshot.docs) {
      totalPercentageSum += testResult['avrage'];
    }

    double averagePercentage =
        totalTestsCount > 0 ? totalPercentageSum / totalTestsCount : 0.0;

    setState(() {
      totalPercentage = averagePercentage;
      totalTests = totalTestsCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    calculateTotalPercentage(); // قم بحساب النسبة الكلية هنا

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            ' الاختبارات ($totalTests) - النسبة  : ${totalPercentage.toStringAsFixed(1)}%',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.teal,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('results')
              .where('userName', isEqualTo: name)
              .where('userPhone', isEqualTo: phone)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  var testResult = snapshot.data!.docs[index];
                 
                  String testName = testResult['modelname'];
                  String score = testResult['correctAnswar'];
                  String percentage = testResult['avrage'].toStringAsFixed(1);
                  String timeTaken = testResult['time'].toString();
                  Timestamp createdAt = testResult['createdAt'];
                  DateTime date = createdAt.toDate();
                  String formattedDate =
                      '${date.year}-${date.month}-${date.day}';

                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white38,
                      border: Border.all(color: Colors.teal, width: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Row(
                        children: [
                          Expanded(flex: 5, child: Text(testName)),
                          Expanded(flex: 1, child: Text("% $percentage")),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('النتيجة: $score'),
                          Text('الوقت : $timeTaken دقيقة'),
                          Text('تاريخ الاختبار: $formattedDate'),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Text('حدث خطأ أثناء استرجاع البيانات');
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}